import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/constants/app_constants.dart';
import 'package:mobile/core/storage/secure_storage.dart';
import 'package:mobile/features/loans/data/datasources/return_draft_local_data_source.dart';
import 'package:mobile/features/loans/data/repositories/return_draft_repository_impl.dart';
import 'package:mobile/features/loans/domain/entities/departure_draft.dart';
import 'package:mobile/features/loans/domain/entities/return_draft.dart';

class FakeSecureStorageService implements SecureStorageService {
  final Map<String, String> _store = {};

  @override
  Future<void> write(String key, String value) async {
    _store[key] = value;
  }

  @override
  Future<String?> read(String key) async {
    return _store[key];
  }

  @override
  Future<void> delete(String key) async {
    _store.remove(key);
  }

  @override
  Future<void> clearTokens() async {
    _store.clear();
  }

  @override
  Future<String?> getAccessToken() async => _store[StorageKeys.accessToken];

  @override
  Future<String?> getRefreshToken() async => _store[StorageKeys.refreshToken];

  @override
  Future<void> saveTokens({required String accessToken, required String refreshToken}) async {
    _store[StorageKeys.accessToken] = accessToken;
    _store[StorageKeys.refreshToken] = refreshToken;
  }
}

void main() {
  late FakeSecureStorageService fakeStorage;
  late ReturnDraftLocalDataSource localDataSource;
  late ReturnDraftRepositoryImpl repository;

  setUp(() {
    fakeStorage = FakeSecureStorageService();
    localDataSource = ReturnDraftLocalDataSourceImpl(fakeStorage);
    repository = ReturnDraftRepositoryImpl(localDataSource);
  });

  group('ReturnDraftRepository', () {
    test('saveDraft and getDraft successfully roundtrips draft', () async {
      const draft = ReturnDraft(
        userId: 1,
        loanId: 42,
        odometerKm: 125000,
        fuelBatteryLevelPercent: 75,
        cleanlinessRating: 4,
        checklist: {'key_returned': true, 'clean_inside': true},
        photos: {
          'front': DraftPhotoEntry(
            field: 'front',
            status: DraftPhotoStatus.uploaded,
            imageId: 99,
          ),
        },
      );

      await repository.saveDraft(draft);
      final retrieved = await repository.getDraft(userId: 1, loanId: 42);

      expect(retrieved, isNotNull);
      expect(retrieved!.userId, 1);
      expect(retrieved.loanId, 42);
      expect(retrieved.odometerKm, 125000);
      expect(retrieved.fuelBatteryLevelPercent, 75);
      expect(retrieved.checklist['key_returned'], isTrue);
      expect(retrieved.photos['front']?.status, DraftPhotoStatus.uploaded);
      expect(retrieved.photos['front']?.imageId, 99);
    });

    test('clearDraft removes the draft from storage', () async {
      const draft = ReturnDraft(
        userId: 2,
        loanId: 88,
        odometerKm: 50000,
      );

      await repository.saveDraft(draft);
      expect(await repository.getDraft(userId: 2, loanId: 88), isNotNull);

      await repository.clearDraft(userId: 2, loanId: 88);
      expect(await repository.getDraft(userId: 2, loanId: 88), isNull);
    });

    test('clearDraft cleans up existing local temporary photo files', () async {
      final tempDir = Directory.systemTemp.createTempSync('lot11_return_test');
      final tempFile = File('${tempDir.path}/test_photo.jpg');
      await tempFile.writeAsString('test photo bytes');
      expect(tempFile.existsSync(), isTrue);

      final draft = ReturnDraft(
        userId: 3,
        loanId: 99,
        photos: {
          'front': DraftPhotoEntry(
            field: 'front',
            localPath: tempFile.path,
            status: DraftPhotoStatus.uploaded,
            imageId: 100,
          ),
        },
      );

      await repository.saveDraft(draft);
      await repository.clearDraft(userId: 3, loanId: 99);

      expect(tempFile.existsSync(), isFalse);
      tempDir.deleteSync(recursive: true);
    });
  });
}
