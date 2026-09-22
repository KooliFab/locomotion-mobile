import '../../../../core/constants/app_constants.dart';
import '../../../../core/network/api_client.dart';
import '../../domain/entities/auth_tokens.dart';
import '../../domain/entities/user.dart';

abstract class AuthRemoteDataSource {
  Future<AuthTokens> login({required String email, required String password});
  Future<AuthTokens> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  });
  Future<void> logout();
  Future<User> getCurrentUser();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient _apiClient;

  const AuthRemoteDataSourceImpl(this._apiClient);

  @override
  Future<AuthTokens> login({
    required String email,
    required String password,
  }) async {
    final response = await _apiClient.post(
      ApiEndpoints.login,
      data: {'email': email, 'password': password},
    );

    return AuthTokens.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<AuthTokens> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  }) async {
    final response = await _apiClient.post(
      ApiEndpoints.register,
      data: {
        'email': email,
        'password': password,
        'first_name': firstName,
        'last_name': lastName,
      },
    );

    return AuthTokens.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<void> logout() async {
    await _apiClient.put(ApiEndpoints.logout);
  }

  @override
  Future<User> getCurrentUser() async {
    final response = await _apiClient.get(ApiEndpoints.currentUser);
    final data = response.data;
    if (data is Map<String, dynamic>) {
      // Backend might return user object under 'user' key or root
      final userMap = data['user'] is Map<String, dynamic>
          ? data['user'] as Map<String, dynamic>
          : data;
      return User.fromJson(userMap);
    }
    throw Exception('Format de réponse utilisateur invalide');
  }
}
