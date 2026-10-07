import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../constants/app_constants.dart';
import '../storage/secure_storage.dart';
import '../storage/storage_providers.dart';
import 'inspection_photo_service.dart';

/// Inspection flow a camera capture belongs to.
enum PhotoCapturePhase { departure, returnInspection }

/// Context persisted *before* the camera is launched.
///
/// On Android the OS may destroy the app process while the camera is in the
/// foreground. When the app restarts, the picked image can only be retrieved
/// through `ImagePicker.retrieveLostData()`, which carries no business context.
/// This record ties the recovered file back to its user / loan / field.
@immutable
class PendingPhotoCapture {
  final int userId;
  final int loanId;
  final PhotoCapturePhase phase;
  final String field;
  final bool requiresMileage;
  final DateTime startedAt;

  const PendingPhotoCapture({
    required this.userId,
    required this.loanId,
    required this.phase,
    required this.field,
    required this.requiresMileage,
    required this.startedAt,
  });

  Map<String, dynamic> toJson() => {
    'user_id': userId,
    'loan_id': loanId,
    'phase': phase.name,
    'field': field,
    'requires_mileage': requiresMileage,
    'started_at': startedAt.toIso8601String(),
  };

  static PendingPhotoCapture? tryFromJson(Map<String, dynamic> json) {
    try {
      final phaseName = json['phase'] as String;
      final phase = PhotoCapturePhase.values.firstWhere(
        (p) => p.name == phaseName,
      );
      return PendingPhotoCapture(
        userId: json['user_id'] as int,
        loanId: json['loan_id'] as int,
        phase: phase,
        field: json['field'] as String,
        requiresMileage: json['requires_mileage'] as bool,
        startedAt: DateTime.parse(json['started_at'] as String),
      );
    } catch (_) {
      return null;
    }
  }
}

/// Persists at most one pending capture per user.
abstract class PendingPhotoCaptureStore {
  Future<void> save(PendingPhotoCapture capture);
  Future<PendingPhotoCapture?> load(int userId);
  Future<void> clear(int userId);
}

class SecureStoragePendingPhotoCaptureStore
    implements PendingPhotoCaptureStore {
  final SecureStorageService _storage;

  const SecureStoragePendingPhotoCaptureStore(this._storage);

  @override
  Future<void> save(PendingPhotoCapture capture) async {
    await _storage.write(
      StorageKeys.pendingPhotoCapture(capture.userId),
      jsonEncode(capture.toJson()),
    );
  }

  @override
  Future<PendingPhotoCapture?> load(int userId) async {
    final key = StorageKeys.pendingPhotoCapture(userId);
    final raw = await _storage.read(key);
    if (raw == null || raw.isEmpty) return null;
    try {
      final parsed = PendingPhotoCapture.tryFromJson(
        jsonDecode(raw) as Map<String, dynamic>,
      );
      if (parsed == null || parsed.userId != userId) {
        await _storage.delete(key);
        return null;
      }
      return parsed;
    } catch (_) {
      await _storage.delete(key);
      return null;
    }
  }

  @override
  Future<void> clear(int userId) async {
    await _storage.delete(StorageKeys.pendingPhotoCapture(userId));
  }
}

/// Outcome of a recovery attempt after the activity was destroyed.
@immutable
class RecoveredPhotoCapture {
  final PendingPhotoCapture context;
  final File? file;
  final String? errorMessage;

  const RecoveredPhotoCapture({
    required this.context,
    this.file,
    this.errorMessage,
  });

  bool get hasFile => file != null;
}

/// Wraps camera capture so that the business context survives a process kill,
/// and recovers the lost image on the next launch.
class PhotoCaptureCoordinator {
  final InspectionPhotoService _photoService;
  final PendingPhotoCaptureStore _store;

  const PhotoCaptureCoordinator(this._photoService, this._store);

  /// Records the context, launches the picker, and clears the context once the
  /// result has been delivered to the caller. If the process is killed while the
  /// picker is open, the context stays persisted for [recover].
  Future<PhotoCaptureResult> capture({
    required PendingPhotoCapture context,
    required ImageSource source,
  }) async {
    // Gallery picks are not affected by camera-induced activity destruction in
    // the same way, but the picker activity can still be killed: track both.
    await _safely(() => _store.save(context));
    try {
      return await _photoService.capturePhoto(source: source);
    } finally {
      await _safely(() => _store.clear(context.userId));
    }
  }

  /// Returns the recovered capture for this user/loan/phase, if any.
  ///
  /// Returns `null` when nothing is pending, or when the pending capture belongs
  /// to another loan or phase (it is left untouched for its own screen).
  Future<RecoveredPhotoCapture?> recover({
    required int userId,
    required int loanId,
    required PhotoCapturePhase phase,
  }) async {
    PendingPhotoCapture? pending;
    try {
      pending = await _store.load(userId);
    } catch (e) {
      debugPrint('[PhotoCapture] Unable to read pending capture: $e');
      return null;
    }
    if (pending == null) return null;
    if (pending.loanId != loanId || pending.phase != phase) return null;

    try {
      final lost = await _photoService.retrieveLostCapture();
      switch (lost) {
        case PhotoCaptureSuccess(:final file):
          return RecoveredPhotoCapture(context: pending, file: file);
        case PhotoCaptureFailure(:final message):
          return RecoveredPhotoCapture(context: pending, errorMessage: message);
        case _:
          // Nothing was lost: the capture was cancelled or already delivered.
          return null;
      }
    } finally {
      await _safely(() => _store.clear(userId));
    }
  }

  Future<void> _safely(Future<void> Function() action) async {
    try {
      await action();
    } catch (e) {
      debugPrint('[PhotoCapture] Pending capture storage error: $e');
    }
  }
}

final pendingPhotoCaptureStoreProvider = Provider<PendingPhotoCaptureStore>((
  ref,
) {
  return SecureStoragePendingPhotoCaptureStore(
    ref.watch(secureStorageServiceProvider),
  );
});

final photoCaptureCoordinatorProvider = Provider<PhotoCaptureCoordinator>((
  ref,
) {
  return PhotoCaptureCoordinator(
    ref.watch(inspectionPhotoServiceProvider),
    ref.watch(pendingPhotoCaptureStoreProvider),
  );
});
