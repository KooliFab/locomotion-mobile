import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

sealed class PhotoCaptureResult {
  const PhotoCaptureResult();
}

class PhotoCaptureSuccess extends PhotoCaptureResult {
  final File file;
  const PhotoCaptureSuccess(this.file);
}

class PhotoCaptureCancelled extends PhotoCaptureResult {
  const PhotoCaptureCancelled();
}

class PhotoCapturePermissionDenied extends PhotoCaptureResult {
  final String message;
  const PhotoCapturePermissionDenied([
    this.message = 'Permission refusée pour accéder à la caméra ou à la galerie.',
  ]);
}

class PhotoCaptureFailure extends PhotoCaptureResult {
  final String message;
  const PhotoCaptureFailure(this.message);
}

abstract class InspectionPhotoService {
  Future<PhotoCaptureResult> capturePhoto({
    ImageSource source = ImageSource.camera,
  });

  /// Retrieves an image picked just before the Android activity was destroyed.
  ///
  /// Returns `null` when nothing was lost (always the case on iOS/web). Must be
  /// called after restart, and only once: the platform drops the data after it
  /// has been returned.
  Future<PhotoCaptureResult?> retrieveLostCapture();
}

class InspectionPhotoServiceImpl implements InspectionPhotoService {
  final ImagePicker _picker;

  InspectionPhotoServiceImpl([ImagePicker? picker])
      : _picker = picker ?? ImagePicker();

  @override
  Future<PhotoCaptureResult> capturePhoto({
    ImageSource source = ImageSource.camera,
  }) async {
    try {
      final xFile = await _picker.pickImage(
        source: source,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );
      if (xFile == null) {
        return const PhotoCaptureCancelled();
      }
      return PhotoCaptureSuccess(File(xFile.path));
    } on PlatformException catch (e) {
      final code = e.code.toLowerCase();
      final msg = (e.message ?? '').toLowerCase();
      if (code.contains('camera_access_denied') ||
          code.contains('photo_access_denied') ||
          code.contains('permission') ||
          code.contains('denied') ||
          msg.contains('permission') ||
          msg.contains('denied')) {
        return PhotoCapturePermissionDenied(
          e.message ??
              'Permission refusée pour accéder à la caméra ou à la galerie.',
        );
      }
      return PhotoCaptureFailure(
        e.message ?? 'Erreur technique lors de la prise de vue.',
      );
    } catch (e) {
      return PhotoCaptureFailure(e.toString());
    }
  }

  @override
  Future<PhotoCaptureResult?> retrieveLostCapture() async {
    if (kIsWeb || !Platform.isAndroid) return null;
    try {
      final response = await _picker.retrieveLostData();
      if (response.isEmpty) return null;
      final exception = response.exception;
      if (exception != null) {
        return PhotoCaptureFailure(
          exception.message ?? 'Impossible de récupérer la photo interrompue.',
        );
      }
      final xFile = response.file ?? response.files?.firstOrNull;
      if (xFile == null) return null;
      return PhotoCaptureSuccess(File(xFile.path));
    } catch (e) {
      return PhotoCaptureFailure(e.toString());
    }
  }
}

final inspectionPhotoServiceProvider = Provider<InspectionPhotoService>((ref) {
  return InspectionPhotoServiceImpl();
});
