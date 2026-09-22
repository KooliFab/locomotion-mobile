import 'dart:convert';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mobile/core/network/api_client.dart';
import 'package:mobile/core/storage/secure_storage.dart';

class MockHttpClientAdapter implements HttpClientAdapter {
  final Future<ResponseBody> Function(RequestOptions options) handler;

  MockHttpClientAdapter(this.handler);

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) {
    return handler(options);
  }

  @override
  void close({bool force = false}) {}
}

class FakeSecureStorageService extends SecureStorageService {
  final Map<String, String> _storage = {};

  FakeSecureStorageService() : super(const FlutterSecureStorage());

  @override
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    _storage['access'] = accessToken;
    _storage['refresh'] = refreshToken;
  }

  @override
  Future<String?> getAccessToken() async => _storage['access'];

  @override
  Future<String?> getRefreshToken() async => _storage['refresh'];

  @override
  Future<void> clearTokens() async {
    _storage.clear();
  }

  @override
  Future<void> write(String key, String value) async {
    _storage[key] = value;
  }

  @override
  Future<String?> read(String key) async {
    return _storage[key];
  }

  @override
  Future<void> delete(String key) async {
    _storage.remove(key);
  }
}

ApiClient createMockApiClient(
  Future<ResponseBody> Function(RequestOptions options) handler,
) {
  final client = ApiClient.create(
    storageService: FakeSecureStorageService(),
    baseUrl: 'http://localhost:8000/api/v1',
  );
  client.dio.httpClientAdapter = MockHttpClientAdapter(handler);
  return client;
}

ResponseBody jsonResponse(dynamic data, {int statusCode = 200}) {
  final str = jsonEncode(data);
  return ResponseBody.fromString(
    str,
    statusCode,
    headers: {
      Headers.contentTypeHeader: [Headers.jsonContentType],
    },
  );
}
