import 'package:dio/dio.dart';
import '../constants/app_constants.dart';
import '../storage/secure_storage.dart';

class AuthInterceptor extends QueuedInterceptor {
  final SecureStorageService _storageService;
  final Dio _dio;
  final Dio _refreshDio;

  static const String retryKey = '_auth_retry';

  /// Shared in-flight refresh future to coalesce concurrent 401 errors
  Future<String?>? _ongoingRefresh;

  AuthInterceptor(
    this._storageService,
    this._dio, {
    Dio? refreshDio,
  }) : _refreshDio = refreshDio ??
            Dio(
              BaseOptions(
                baseUrl: _dio.options.baseUrl,
                connectTimeout: _dio.options.connectTimeout,
                receiveTimeout: _dio.options.receiveTimeout,
                headers: {
                  'Accept': 'application/json',
                  'Content-Type': 'application/json',
                },
              ),
            );

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Endpoints that don't need a token
    final isPublic =
        options.path == ApiEndpoints.login ||
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
    final statusCode = err.response?.statusCode;
    final path = err.requestOptions.path;
    final isAlreadyRetry = err.requestOptions.extra[retryKey] == true;

    // Check if error is 401 Unauthorized and eligible for token refresh:
    // - Must not be a retried request (bounded retry to avoid infinite recursion)
    // - Must not be login or register
    // - Must not be the refresh token endpoint itself
    final isRefreshEligible = statusCode == 401 &&
        !isAlreadyRetry &&
        path != ApiEndpoints.login &&
        path != ApiEndpoints.register &&
        path != ApiEndpoints.refreshToken;

    if (!isRefreshEligible) {
      if (statusCode == 401 && isAlreadyRetry) {
        // Retry also failed with 401: purge credentials to avoid stuck session
        await _storageService.clearTokens();
      }
      return handler.next(err);
    }

    try {
      final authHeader = err.requestOptions.headers['Authorization'] as String?;
      final requestToken = authHeader?.replaceFirst('Bearer ', '');
      final currentToken = await _storageService.getAccessToken();

      String? targetAccessToken;

      // If another concurrent request has already refreshed the token in storage,
      // reuse the newly stored token directly without triggering another refresh call.
      if (currentToken != null &&
          currentToken.isNotEmpty &&
          requestToken != null &&
          currentToken != requestToken) {
        targetAccessToken = currentToken;
      } else {
        targetAccessToken = await _executeSharedRefresh();
      }

      if (targetAccessToken != null && targetAccessToken.isNotEmpty) {
        final requestOptions = err.requestOptions;
        requestOptions.headers['Authorization'] = 'Bearer $targetAccessToken';
        requestOptions.extra = Map<String, dynamic>.from(requestOptions.extra)
          ..[retryKey] = true;

        // Perform retry via _refreshDio to avoid deadlocking with QueuedInterceptor's queue
        final response = await _retryRequest(requestOptions);
        return handler.resolve(response);
      } else {
        await _storageService.clearTokens();
        return handler.next(err);
      }
    } on DioException catch (retryErr) {
      if (retryErr.response?.statusCode == 401) {
        await _storageService.clearTokens();
      }
      return handler.reject(retryErr);
    } catch (_) {
      await _storageService.clearTokens();
      return handler.next(err);
    }
  }

  /// Retries the request using a clean Dio instance sharing the main adapter
  /// to bypass QueuedInterceptor's lock and prevent deadlocks.
  Future<Response<dynamic>> _retryRequest(RequestOptions options) {
    final retryDio = Dio(
      BaseOptions(
        baseUrl: _dio.options.baseUrl,
        connectTimeout: _dio.options.connectTimeout,
        receiveTimeout: _dio.options.receiveTimeout,
        sendTimeout: _dio.options.sendTimeout,
      ),
    )..httpClientAdapter = _dio.httpClientAdapter;

    return retryDio.fetch(options);
  }

  Future<String?> _executeSharedRefresh() {
    if (_ongoingRefresh != null) {
      return _ongoingRefresh!;
    }

    final future = _performTokenRefresh();
    _ongoingRefresh = future;
    return future.whenComplete(() {
      _ongoingRefresh = null;
    });
  }

  Future<String?> _performTokenRefresh() async {
    final refreshToken = await _storageService.getRefreshToken();
    final currentAccessToken = await _storageService.getAccessToken();

    if (refreshToken == null || refreshToken.isEmpty) {
      await _storageService.clearTokens();
      return null;
    }

    try {
      final headers = <String, dynamic>{
        'Accept': 'application/json',
      };
      if (currentAccessToken != null && currentAccessToken.isNotEmpty) {
        headers['Authorization'] = 'Bearer $currentAccessToken';
      }

      final response = await _refreshDio.post(
        ApiEndpoints.refreshToken,
        data: {'refresh_token': refreshToken},
        options: Options(headers: headers),
      );

      if (response.statusCode == 200 && response.data is Map<String, dynamic>) {
        final data = response.data as Map<String, dynamic>;
        final newAccessToken = data['access_token'] as String?;
        final newRefreshToken =
            data['refresh_token'] as String? ?? refreshToken;

        if (newAccessToken != null && newAccessToken.isNotEmpty) {
          await _storageService.saveTokens(
            accessToken: newAccessToken,
            refreshToken: newRefreshToken,
          );
          return newAccessToken;
        }
      }

      await _storageService.clearTokens();
      return null;
    } catch (_) {
      await _storageService.clearTokens();
      return null;
    }
  }
}
