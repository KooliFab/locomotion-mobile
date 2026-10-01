import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/notifications/data/datasources/push_tokens_remote_data_source.dart';
import 'package:mobile/features/notifications/data/repositories/push_tokens_repository_impl.dart';

import '../../helpers/mock_api_client.dart';

void main() {
  group('PushTokensRemoteDataSource', () {
    test('registerPushToken posts correctly formatted body and parses response', () async {
      late RequestOptions capturedOptions;

      final client = createMockApiClient((options) async {
        capturedOptions = options;
        return jsonResponse({
          'data': {
            'id': 15,
            'user_id': 3,
            'platform': 'ios',
            'installation_id': 'inst_uuid_123',
            'app_version': '1.0.0+1',
            'created_at': '2026-10-01T10:00:00Z',
            'updated_at': '2026-10-01T10:00:00Z',
          }
        }, statusCode: 201);
      });

      final dataSource = PushTokensRemoteDataSourceImpl(client);
      final result = await dataSource.registerPushToken(
        token: 'fcm_token_sample_abc',
        platform: 'ios',
        installationId: 'inst_uuid_123',
        appVersion: '1.0.0+1',
      );

      expect(capturedOptions.path, '/auth/user/push-tokens');
      expect(capturedOptions.method, 'POST');
      expect(capturedOptions.data, {
        'token': 'fcm_token_sample_abc',
        'platform': 'ios',
        'installation_id': 'inst_uuid_123',
        'app_version': '1.0.0+1',
      });

      expect(result.id, 15);
      expect(result.platform, 'ios');
      expect(result.installationId, 'inst_uuid_123');
      expect(result.appVersion, '1.0.0+1');
    });

    test('revokeTokenByInstallation issues DELETE with URL encoded path parameter', () async {
      late RequestOptions capturedOptions;

      final client = createMockApiClient((options) async {
        capturedOptions = options;
        return jsonResponse(null, statusCode: 204);
      });

      final dataSource = PushTokensRemoteDataSourceImpl(client);
      await dataSource.revokeTokenByInstallation(installationId: 'inst_uuid_123');

      expect(capturedOptions.path, '/auth/user/push-tokens/installations/inst_uuid_123');
      expect(capturedOptions.method, 'DELETE');
    });

    test('revokeTokenById issues DELETE with ID path parameter', () async {
      late RequestOptions capturedOptions;

      final client = createMockApiClient((options) async {
        capturedOptions = options;
        return jsonResponse(null, statusCode: 204);
      });

      final dataSource = PushTokensRemoteDataSourceImpl(client);
      await dataSource.revokeTokenById(id: 42);

      expect(capturedOptions.path, '/auth/user/push-tokens/42');
      expect(capturedOptions.method, 'DELETE');
    });
  });

  group('PushTokensRepositoryImpl', () {
    test('getOrCreateInstallationId generates and saves UUID if not already stored', () async {
      final storage = FakeSecureStorageService();
      final client = createMockApiClient((options) async => jsonResponse(null, statusCode: 204));
      final dataSource = PushTokensRemoteDataSourceImpl(client);

      final repo = PushTokensRepositoryImpl(dataSource, storage);

      expect(await storage.read('app_installation_id'), isNull);

      final id1 = await repo.getOrCreateInstallationId();
      expect(id1, isNotEmpty);
      expect(await storage.read('app_installation_id'), id1);

      // Subsequent call reuses the same ID
      final id2 = await repo.getOrCreateInstallationId();
      expect(id2, id1);
    });

    test('registerToken passes stored installationId to remoteDataSource', () async {
      final storage = FakeSecureStorageService();
      await storage.write('app_installation_id', 'persisted_device_id_999');

      late RequestOptions capturedOptions;
      final client = createMockApiClient((options) async {
        capturedOptions = options;
        return jsonResponse({
          'id': 1,
          'platform': 'android',
          'installation_id': 'persisted_device_id_999',
        });
      });
      final dataSource = PushTokensRemoteDataSourceImpl(client);
      final repo = PushTokensRepositoryImpl(dataSource, storage);

      final token = await repo.registerToken(
        token: 'sample_token_xyz',
        platform: 'android',
        appVersion: '1.0.0',
      );

      expect(token.installationId, 'persisted_device_id_999');
      expect(capturedOptions.data['installation_id'], 'persisted_device_id_999');
      expect(capturedOptions.data['token'], 'sample_token_xyz');
      expect(capturedOptions.data['platform'], 'android');
      expect(capturedOptions.data['app_version'], '1.0.0');
    });

    test('revokeCurrentInstallationToken revokes token for stored installationId', () async {
      final storage = FakeSecureStorageService();
      await storage.write('app_installation_id', 'device_to_revoke_444');

      late RequestOptions capturedOptions;
      final client = createMockApiClient((options) async {
        capturedOptions = options;
        return jsonResponse(null, statusCode: 204);
      });
      final dataSource = PushTokensRemoteDataSourceImpl(client);
      final repo = PushTokensRepositoryImpl(dataSource, storage);

      await repo.revokeCurrentInstallationToken();

      expect(capturedOptions.path, '/auth/user/push-tokens/installations/device_to_revoke_444');
      expect(capturedOptions.method, 'DELETE');
    });
  });
}
