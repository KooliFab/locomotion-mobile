import 'package:dio/dio.dart';
import '../config/env.dart';
import '../error/exceptions.dart';
import '../storage/secure_storage.dart';
import 'auth_interceptor.dart';

class ApiClient {
  final Dio dio;

  ApiClient._(this.dio);

  factory ApiClient.create({
    required SecureStorageService storageService,
    String? baseUrl,
  }) {
    final baseDio = Dio(
      BaseOptions(
        baseUrl: baseUrl ?? AppConfig.baseUrl,
        connectTimeout: AppConfig.connectTimeout,
        receiveTimeout: AppConfig.receiveTimeout,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    );

    baseDio.interceptors.add(AuthInterceptor(storageService, baseDio));
    baseDio.interceptors.add(
      LogInterceptor(
        requestHeader: false,
        requestBody: false, // Ne pas tracer les corps de requête pour protéger la confidentialité des messages privés
        responseBody: true,
        responseHeader: false,
        error: true,
      ),
    );

    return ApiClient._(baseDio);
  }

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await dio.get<T>(
        path,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw AppException(message: e.toString());
    }
  }

  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw AppException(message: e.toString());
    }
  }

  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await dio.put<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw AppException(message: e.toString());
    }
  }

  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await dio.delete<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw AppException(message: e.toString());
    }
  }

  AppException _handleDioError(DioException error) {
    final response = error.response;
    final statusCode = response?.statusCode;
    final data = response?.data;

    String extractMessage() {
      if (data is Map<String, dynamic>) {
        if (data['message'] != null) return data['message'].toString();
        if (data['error'] != null) return data['error'].toString();
      }
      return error.message ?? 'Une erreur réseau est survenue.';
    }

    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        error.type == DioExceptionType.connectionError) {
      return NetworkException(
        message:
            'Impossible de joindre le serveur LocoMotion. Vérifiez votre connexion.',
        statusCode: statusCode,
      );
    }

    if (statusCode == 401) {
      return UnauthorizedException(
        message: extractMessage(),
        statusCode: statusCode,
        data: data,
      );
    }

    if (statusCode == 403) {
      return ForbiddenException(
        message: extractMessage(),
        statusCode: statusCode,
        data: data,
      );
    }

    if (statusCode == 409) {
      return ConflictException(
        message: extractMessage(),
        statusCode: statusCode,
        data: data,
      );
    }

    if (statusCode == 422) {
      final errors = data is Map<String, dynamic>
          ? data['errors'] as Map<String, dynamic>?
          : null;
      return ValidationException(
        message: extractMessage(),
        statusCode: statusCode,
        data: data,
        errors: errors,
      );
    }

    return ServerException(
      message: extractMessage(),
      statusCode: statusCode,
      data: data,
    );
  }
}
