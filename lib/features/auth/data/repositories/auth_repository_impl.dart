import '../../../../core/storage/secure_storage.dart';
import '../../domain/entities/auth_tokens.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final SecureStorageService storageService;

  const AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.storageService,
  });

  @override
  Future<AuthTokens> login({
    required String email,
    required String password,
  }) async {
    final tokens = await remoteDataSource.login(
      email: email,
      password: password,
    );

    await storageService.saveTokens(
      accessToken: tokens.accessToken,
      refreshToken: tokens.refreshToken,
    );

    return tokens;
  }

  @override
  Future<AuthTokens> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  }) async {
    final tokens = await remoteDataSource.register(
      email: email,
      password: password,
      firstName: firstName,
      lastName: lastName,
    );

    await storageService.saveTokens(
      accessToken: tokens.accessToken,
      refreshToken: tokens.refreshToken,
    );

    return tokens;
  }

  @override
  Future<void> logout() async {
    try {
      await remoteDataSource.logout();
    } catch (_) {
      // Still clear local tokens even if server logout fails
    } finally {
      await storageService.clearTokens();
    }
  }

  @override
  Future<User> getCurrentUser() {
    return remoteDataSource.getCurrentUser();
  }

  @override
  Future<bool> isAuthenticated() async {
    final token = await storageService.getAccessToken();
    return token != null && token.isNotEmpty;
  }
}
