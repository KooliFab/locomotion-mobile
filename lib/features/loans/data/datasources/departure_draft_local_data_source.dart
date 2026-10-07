import 'dart:convert';
import 'dart:io';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/storage/secure_storage.dart';
import '../../domain/entities/departure_draft.dart';

abstract class DepartureDraftLocalDataSource {
  Future<void> saveDraft(DepartureDraft draft);
  Future<DepartureDraft?> getDraft({required int userId, required int loanId});
  Future<void> clearDraft({required int userId, required int loanId});
}

class DepartureDraftLocalDataSourceImpl
    implements DepartureDraftLocalDataSource {
  final SecureStorageService _storage;

  const DepartureDraftLocalDataSourceImpl(this._storage);

  @override
  Future<void> saveDraft(DepartureDraft draft) async {
    final key = StorageKeys.departureDraft(draft.userId, draft.loanId);
    final jsonStr = jsonEncode(draft.toJson());
    await _storage.write(key, jsonStr);
  }

  @override
  Future<DepartureDraft?> getDraft({
    required int userId,
    required int loanId,
  }) async {
    final key = StorageKeys.departureDraft(userId, loanId);
    final jsonStr = await _storage.read(key);
    if (jsonStr == null || jsonStr.isEmpty) return null;

    try {
      final map = jsonDecode(jsonStr) as Map<String, dynamic>;
      return DepartureDraft.fromJson(map);
    } catch (_) {
      // In case of corrupt draft, clear it and return null
      await clearDraft(userId: userId, loanId: loanId);
      return null;
    }
  }

  @override
  Future<void> clearDraft({required int userId, required int loanId}) async {
    final key = StorageKeys.departureDraft(userId, loanId);

    // Purge cached local photo files before deleting references
    final jsonStr = await _storage.read(key);
    if (jsonStr != null && jsonStr.isNotEmpty) {
      try {
        final map = jsonDecode(jsonStr) as Map<String, dynamic>;
        final draft = DepartureDraft.fromJson(map);
        for (final photo in draft.photos.values) {
          if (photo.localPath != null && photo.localPath!.isNotEmpty) {
            final file = File(photo.localPath!);
            if (await file.exists()) {
              await file.delete();
            }
          }
        }
      } catch (_) {
        // Silently ignore file purge failure
      }
    }

    await _storage.delete(key);
  }
}
