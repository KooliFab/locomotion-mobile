import 'dart:convert';
import 'dart:io';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/storage/secure_storage.dart';
import '../../domain/entities/return_draft.dart';

abstract class ReturnDraftLocalDataSource {
  Future<void> saveDraft(ReturnDraft draft);
  Future<ReturnDraft?> getDraft({required int userId, required int loanId});
  Future<void> clearDraft({required int userId, required int loanId});
}

class ReturnDraftLocalDataSourceImpl implements ReturnDraftLocalDataSource {
  final SecureStorageService _storage;

  const ReturnDraftLocalDataSourceImpl(this._storage);

  @override
  Future<void> saveDraft(ReturnDraft draft) async {
    final key = StorageKeys.returnDraft(draft.userId, draft.loanId);
    final jsonStr = jsonEncode(draft.toJson());
    await _storage.write(key, jsonStr);
  }

  @override
  Future<ReturnDraft?> getDraft({
    required int userId,
    required int loanId,
  }) async {
    final key = StorageKeys.returnDraft(userId, loanId);
    final jsonStr = await _storage.read(key);
    if (jsonStr == null || jsonStr.isEmpty) return null;

    try {
      final map = jsonDecode(jsonStr) as Map<String, dynamic>;
      return ReturnDraft.fromJson(map);
    } catch (_) {
      await clearDraft(userId: userId, loanId: loanId);
      return null;
    }
  }

  @override
  Future<void> clearDraft({
    required int userId,
    required int loanId,
  }) async {
    final key = StorageKeys.returnDraft(userId, loanId);

    // Purge cached local photo files before deleting references
    final jsonStr = await _storage.read(key);
    if (jsonStr != null && jsonStr.isNotEmpty) {
      try {
        final map = jsonDecode(jsonStr) as Map<String, dynamic>;
        final draft = ReturnDraft.fromJson(map);
        for (final photo in draft.photos.values) {
          if (photo.localPath != null && photo.localPath!.isNotEmpty) {
            final file = File(photo.localPath!);
            if (await file.exists()) {
              await file.delete();
            }
          }
        }
        if (draft.signaturePhoto?.localPath != null &&
            draft.signaturePhoto!.localPath!.isNotEmpty) {
          final sigFile = File(draft.signaturePhoto!.localPath!);
          if (await sigFile.exists()) {
            await sigFile.delete();
          }
        }
      } catch (_) {
        // Silently ignore file purge failure
      }
    }

    await _storage.delete(key);
  }
}
