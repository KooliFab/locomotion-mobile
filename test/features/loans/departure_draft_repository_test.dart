import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/constants/app_constants.dart';
import 'package:mobile/core/storage/secure_storage.dart';
import 'package:mobile/features/loans/data/datasources/departure_draft_local_data_source.dart';
import 'package:mobile/features/loans/data/repositories/departure_draft_repository_impl.dart';
import 'package:mobile/features/loans/domain/entities/departure_draft.dart';

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
  group('DepartureDraftLocalDataSource & Repository', () {
    late FakeSecureStorageService fakeStorage;
    late DepartureDraftLocalDataSource localDataSource;
    late DepartureDraftRepositoryImpl repository;

    setUp(() {
      fakeStorage = FakeSecureStorageService();
      localDataSource = DepartureDraftLocalDataSourceImpl(fakeStorage);
      repository = DepartureDraftRepositoryImpl(localDataSource);
    });

    test('saveDraft and getDraft returns persisted draft', () async {
      const draft = DepartureDraft(
        userId: 1,
        loanId: 100,
        odometerKm: 54321,
        fuelBatteryLevelPercent: 78,
        cleanlinessRating: 4,
        checklist: {'key_present': true, 'clean_interior': true},
        existingDamagesNotes: 'Rayure aile gauche',
        photos: {
          'front': DraftPhotoEntry(
            field: 'front',
            localPath: '/tmp/front.jpg',
            status: DraftPhotoStatus.uploaded,
            imageId: 999,
          ),
        },
      );

      await repository.saveDraft(draft);

      final retrieved = await repository.getDraft(userId: 1, loanId: 100);
      expect(retrieved, isNotNull);
      expect(retrieved!.odometerKm, 54321);
      expect(retrieved.fuelBatteryLevelPercent, 78);
      expect(retrieved.cleanlinessRating, 4);
      expect(retrieved.checklist['key_present'], isTrue);
      expect(retrieved.photos['front']?.imageId, 999);
      expect(retrieved.photos['front']?.status, DraftPhotoStatus.uploaded);
    });

    test('getDraft returns null when draft does not exist', () async {
      final retrieved = await repository.getDraft(userId: 2, loanId: 999);
      expect(retrieved, isNull);
    });

    test('getDraft recovers gracefully and deletes corrupt json', () async {
      final key = StorageKeys.departureDraft(1, 100);
      await fakeStorage.write(key, 'invalid-non-json-content');

      final retrieved = await repository.getDraft(userId: 1, loanId: 100);
      expect(retrieved, isNull);

      // Corrupt content should have been deleted
      final rawAfter = await fakeStorage.read(key);
      expect(rawAfter, isNull);
    });

    test('clearDraft removes the stored draft', () async {
      const draft = DepartureDraft(userId: 1, loanId: 100, odometerKm: 12000);
      await repository.saveDraft(draft);

      var retrieved = await repository.getDraft(userId: 1, loanId: 100);
      expect(retrieved, isNotNull);

      await repository.clearDraft(userId: 1, loanId: 100);

      retrieved = await repository.getDraft(userId: 1, loanId: 100);
      expect(retrieved, isNull);
    });

    test('clearDraft purges local photo files from disk and removes the stored draft', () async {
      final tempDir = Directory.systemTemp.createTempSync();
      final photoFile = File('${tempDir.path}/departure_front.jpg')..writeAsStringSync('dummy content');
      expect(photoFile.existsSync(), isTrue);

      final draft = DepartureDraft(
        userId: 1,
        loanId: 100,
        photos: {
          'front': DraftPhotoEntry(
            field: 'front',
            localPath: photoFile.path,
            status: DraftPhotoStatus.uploaded,
            imageId: 999,
          ),
        },
      );
      await repository.saveDraft(draft);

      await repository.clearDraft(userId: 1, loanId: 100);

      expect(photoFile.existsSync(), isFalse);
      final retrieved = await repository.getDraft(userId: 1, loanId: 100);
      expect(retrieved, isNull);

      tempDir.deleteSync(recursive: true);
    });
  });
}
