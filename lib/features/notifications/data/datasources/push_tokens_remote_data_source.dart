import '../../../../core/network/api_client.dart';
import '../../domain/entities/push_token.dart';

abstract class PushTokensRemoteDataSource {
  Future<PushToken> registerPushToken({
    required String token,
    required String platform,
    required String installationId,
    String? appVersion,
  });

  Future<void> revokeTokenByInstallation({required String installationId});

  Future<void> revokeTokenById({required int id});
}

class PushTokensRemoteDataSourceImpl implements PushTokensRemoteDataSource {
  final ApiClient _client;

  const PushTokensRemoteDataSourceImpl(this._client);

  @override
  Future<PushToken> registerPushToken({
    required String token,
    required String platform,
    required String installationId,
    String? appVersion,
  }) async {
    final response = await _client.post<Map<String, dynamic>>(
      '/auth/user/push-tokens',
      data: {
        'token': token,
        'platform': platform,
        'installation_id': installationId,
        'app_version': ?appVersion,
      },
    );

    final rawData = response.data;
    if (rawData == null) {
      throw const FormatException('Empty response when registering push token');
    }

    // Response structure from Laravel: JsonResource { id, platform, installation_id, ... }
    final json = rawData.containsKey('data') && rawData['data'] is Map<String, dynamic>
        ? rawData['data'] as Map<String, dynamic>
        : rawData;

    return PushToken(
      id: json['id'] as int?,
      token: token,
      platform: json['platform'] as String? ?? platform,
      installationId: json['installation_id'] as String? ?? installationId,
      appVersion: json['app_version'] as String? ?? appVersion,
      lastActiveAt: json['last_active_at'] != null
          ? DateTime.tryParse(json['last_active_at'].toString())
          : null,
    );
  }

  @override
  Future<void> revokeTokenByInstallation({required String installationId}) async {
    await _client.delete<void>(
      '/auth/user/push-tokens/installations/$installationId',
    );
  }

  @override
  Future<void> revokeTokenById({required int id}) async {
    await _client.delete<void>(
      '/auth/user/push-tokens/$id',
    );
  }
}
