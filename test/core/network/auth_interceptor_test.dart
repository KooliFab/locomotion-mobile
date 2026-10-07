import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/network/auth_interceptor.dart';
import '../../helpers/mock_api_client.dart';

void main() {
  late FakeSecureStorageService fakeStorage;
  late Dio mainDio;
  late Dio refreshDio;
  late AuthInterceptor interceptor;

  setUp(() {
    fakeStorage = FakeSecureStorageService();
    mainDio = Dio(
      BaseOptions(
        baseUrl: 'http://test.api',
        connectTimeout: const Duration(seconds: 1),
        receiveTimeout: const Duration(seconds: 1),
      ),
    );
    refreshDio = Dio(
      BaseOptions(
        baseUrl: 'http://test.api',
        connectTimeout: const Duration(seconds: 1),
        receiveTimeout: const Duration(seconds: 1),
      ),
    );

    interceptor = AuthInterceptor(fakeStorage, mainDio, refreshDio: refreshDio);
    mainDio.interceptors.add(interceptor);
  });

  group('R02 - AuthInterceptor resilience and deadlock prevention', () {
    test(
      '1. Refresh refusé: purge tokens and propagate 401 without deadlock',
      () async {
        await fakeStorage.saveTokens(
          accessToken: 'expired_access_token',
          refreshToken: 'revoked_refresh_token',
        );

        // Main request returns 401
        mainDio.httpClientAdapter = MockHttpClientAdapter((options) async {
          return ResponseBody.fromString(
            '{"error": "Unauthorized"}',
            401,
            headers: {
              Headers.contentTypeHeader: [Headers.jsonContentType],
            },
          );
        });

        // Refresh request returns 401 (refresh refused)
        refreshDio.httpClientAdapter = MockHttpClientAdapter((options) async {
          return ResponseBody.fromString(
            '{"error": "Invalid refresh token"}',
            401,
            headers: {
              Headers.contentTypeHeader: [Headers.jsonContentType],
            },
          );
        });

        // The request should throw DioException(401) promptly without hanging
        DioException? caughtError;
        try {
          await mainDio.get('/some/protected/resource');
        } on DioException catch (e) {
          caughtError = e;
        }

        expect(caughtError, isNotNull);
        expect(caughtError!.response?.statusCode, equals(401));

        // Tokens must be purged
        expect(await fakeStorage.getAccessToken(), isNull);
        expect(await fakeStorage.getRefreshToken(), isNull);
      },
    );

    test(
      '2. Timeout on refresh: keep tokens and propagate without queue deadlock',
      () async {
        await fakeStorage.saveTokens(
          accessToken: 'expired_access_token',
          refreshToken: 'valid_refresh_token',
        );

        mainDio.httpClientAdapter = MockHttpClientAdapter((options) async {
          return ResponseBody.fromString(
            '{"error": "Unauthorized"}',
            401,
            headers: {
              Headers.contentTypeHeader: [Headers.jsonContentType],
            },
          );
        });

        // Refresh request times out
        refreshDio.httpClientAdapter = MockHttpClientAdapter((options) async {
          throw DioException(
            requestOptions: options,
            type: DioExceptionType.connectionTimeout,
            message: 'Connection timed out',
          );
        });

        DioException? caughtError;
        try {
          await mainDio.get('/some/protected/resource');
        } on DioException catch (e) {
          caughtError = e;
        }

        expect(caughtError, isNotNull);
        expect(caughtError!.response?.statusCode, 401);
        // A network failure must not log the user out
        expect(await fakeStorage.getAccessToken(), 'expired_access_token');
        expect(await fakeStorage.getRefreshToken(), 'valid_refresh_token');
      },
    );

    test(
      '3. Reprise encore en 401: bounded retry stops recursion and purges tokens',
      () async {
        await fakeStorage.saveTokens(
          accessToken: 'expired_access_token',
          refreshToken: 'valid_refresh_token',
        );

        int mainRequestAttempts = 0;
        mainDio.httpClientAdapter = MockHttpClientAdapter((options) async {
          mainRequestAttempts++;
          // Always return 401 even after retry with new token
          return ResponseBody.fromString(
            '{"error": "Unauthorized"}',
            401,
            headers: {
              Headers.contentTypeHeader: [Headers.jsonContentType],
            },
          );
        });

        int refreshCalls = 0;
        refreshDio.httpClientAdapter = MockHttpClientAdapter((options) async {
          refreshCalls++;
          return ResponseBody.fromString(
            '{"access_token": "new_access_123", "refresh_token": "new_refresh_123"}',
            200,
            headers: {
              Headers.contentTypeHeader: [Headers.jsonContentType],
            },
          );
        });

        DioException? caughtError;
        try {
          await mainDio.get('/some/protected/resource');
        } on DioException catch (e) {
          caughtError = e;
        }

        expect(caughtError, isNotNull);
        expect(caughtError!.response?.statusCode, equals(401));

        // Exactly 2 attempts: original + 1 retry (bounded, no infinite loop)
        expect(mainRequestAttempts, equals(2));
        // Exactly 1 refresh call
        expect(refreshCalls, equals(1));

        // When retry fails, credentials are cleared
        expect(await fakeStorage.getAccessToken(), isNull);
      },
    );

    test(
      '4. Plusieurs 401 simultanés: shared refresh coalesces calls into a single refresh POST',
      () async {
        await fakeStorage.saveTokens(
          accessToken: 'expired_access_token',
          refreshToken: 'valid_refresh_token',
        );

        int refreshCalls = 0;
        final refreshCompleter = Completer<void>();

        refreshDio.httpClientAdapter = MockHttpClientAdapter((options) async {
          refreshCalls++;
          await refreshCompleter.future;
          return ResponseBody.fromString(
            '{"access_token": "shared_access_token", "refresh_token": "shared_refresh_token"}',
            200,
            headers: {
              Headers.contentTypeHeader: [Headers.jsonContentType],
            },
          );
        });

        final retriedTokens = <String?>[];
        mainDio.httpClientAdapter = MockHttpClientAdapter((options) async {
          final authHeader = options.headers['Authorization'] as String?;
          if (authHeader == 'Bearer shared_access_token') {
            retriedTokens.add(authHeader);
            return ResponseBody.fromString(
              '{"success": true}',
              200,
              headers: {
                Headers.contentTypeHeader: [Headers.jsonContentType],
              },
            );
          } else {
            return ResponseBody.fromString(
              '{"error": "Unauthorized"}',
              401,
              headers: {
                Headers.contentTypeHeader: [Headers.jsonContentType],
              },
            );
          }
        });

        // Fire 3 simultaneous requests that all receive 401
        final future1 = mainDio.get('/resource/1');
        final future2 = mainDio.get('/resource/2');
        final future3 = mainDio.get('/resource/3');

        // Allow refresh to proceed
        await Future<void>.delayed(const Duration(milliseconds: 20));
        refreshCompleter.complete();

        final results = await Future.wait([future1, future2, future3]);

        // All 3 requests succeed
        for (final res in results) {
          expect(res.statusCode, equals(200));
        }

        // Only ONE refresh request was made to backend
        expect(refreshCalls, equals(1));
        // All 3 retries used the new shared access token
        expect(retriedTokens.length, equals(3));
        expect(
          retriedTokens.every((t) => t == 'Bearer shared_access_token'),
          isTrue,
        );
      },
    );
  });
}
