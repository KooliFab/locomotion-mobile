import 'package:dio/dio.dart';
import '../constants/app_constants.dart';
import '../storage/secure_storage.dart';

class AuthInterceptor extends QueuedInterceptor {
  final SecureStorageService _storageService;
  final Dio _dio;

  AuthInterceptor(this._storageService, this._dio);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    // Endpoints that don't need a token
    final isPublic = options.path == ApiEndpoints.login ||
        options.path == ApiEndpoints.register ||
        options.path == ApiEndpoints.status ||
        options.path == ApiEndpoints.stats;

    if (!isPublic) {
      final token = await _storageService.getAccessToken();
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }

    options.headers['Accept'] = 'application/json';
    options.headers['Content-Type'] = 'application/json';

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Check if error is 401 Unauthorized and not already refreshing or logging in
    if (err.response?.statusCode == 401 &&
        err.requestOptions.path != ApiEndpoints.login &&
        err.requestOptions.path != ApiEndpoints.refreshToken) {
      final refreshToken = await _storageService.getRefreshToken();
      final currentAccessToken = await _storageService.getAccessToken();

      if (refreshToken != null && currentAccessToken != null) {
        try {
          // Attempt token refresh: Laravel Passport requires Authorization header even if expired
          final refreshResponse = await _dio.post(
            ApiEndpoints.refreshToken,
            data: {'refresh_token': refreshToken},
            options: Options(
              headers: {
                'Authorization': 'Bearer $currentAccessToken',
                'Accept': 'application/json',
              },
            ),
          );

          if (refreshResponse.statusCode == 200 && refreshResponse.data != null) {
            final newAccessToken = refreshResponse.data['access_token'] as String;
            final newRefreshToken = refreshResponse.data['refresh_token'] as String? ?? refreshToken;

            await _storageService.saveTokens(
              accessToken: newAccessToken,
              refreshToken: newRefreshToken,
            );

            // Retry the initial request with new access token
            final options = err.requestOptions;
            options.headers['Authorization'] = 'Bearer $newAccessToken';

            final cloneReq = await _dio.fetch(options);
            return handler.resolve(cloneReq);
          }
        } catch (_) {
          // Token refresh failed, purge credentials
          await _storageService.clearTokens();
        }
      } else {
        await _storageService.clearTokens();
      }
    }

    handler.next(err);
  }
}
