import '../entities/push_token.dart';

abstract class PushTokensRepository {
  Future<String> getOrCreateInstallationId();
  Future<PushToken> registerToken({
    required String token,
    required String platform,
    String? appVersion,
  });
  Future<void> revokeCurrentInstallationToken();
}
