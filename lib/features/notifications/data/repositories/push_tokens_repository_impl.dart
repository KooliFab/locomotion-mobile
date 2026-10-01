import 'dart:math';
import '../../../../core/storage/secure_storage.dart';
import '../../domain/entities/push_token.dart';
import '../../domain/repositories/push_tokens_repository.dart';
import '../datasources/push_tokens_remote_data_source.dart';

class PushTokensRepositoryImpl implements PushTokensRepository {
  static const String _installationIdKey = 'app_installation_id';

  final PushTokensRemoteDataSource _remoteDataSource;
  final SecureStorageService _storageService;

  const PushTokensRepositoryImpl(this._remoteDataSource, this._storageService);

  @override
  Future<String> getOrCreateInstallationId() async {
    final existing = await _storageService.read(_installationIdKey);
    if (existing != null && existing.isNotEmpty) {
      return existing;
    }

    final newId = _generateUuidV4();
    await _storageService.write(_installationIdKey, newId);
    return newId;
  }

  @override
  Future<PushToken> registerToken({
    required String token,
    required String platform,
    String? appVersion,
  }) async {
    final installationId = await getOrCreateInstallationId();
    return _remoteDataSource.registerPushToken(
      token: token,
      platform: platform,
      installationId: installationId,
      appVersion: appVersion,
    );
  }

  @override
  Future<void> revokeCurrentInstallationToken() async {
    final installationId = await getOrCreateInstallationId();
    await _remoteDataSource.revokeTokenByInstallation(
      installationId: installationId,
    );
  }

  static String _generateUuidV4() {
    final random = Random.secure();
    final values = List<int>.generate(16, (_) => random.nextInt(256));
    values[6] = (values[6] & 0x0f) | 0x40; // RFC 4122 version 4
    values[8] = (values[8] & 0x3f) | 0x80; // RFC 4122 variant
    final hex = values.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
    return '${hex.substring(0, 8)}-${hex.substring(8, 12)}-${hex.substring(12, 16)}-${hex.substring(16, 20)}-${hex.substring(20, 32)}';
  }
}
