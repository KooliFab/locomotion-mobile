import '../entities/auth_tokens.dart';
import '../entities/user.dart';

abstract class AuthRepository {
  Future<AuthTokens> login({
    required String email,
    required String password,
  });

  Future<AuthTokens> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  });

  Future<void> logout();

  Future<User> getCurrentUser();

  Future<bool> isAuthenticated();
}
