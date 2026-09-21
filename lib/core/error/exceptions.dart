class AppException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic data;

  const AppException({
    required this.message,
    this.statusCode,
    this.data,
  });

  @override
  String toString() => 'AppException(statusCode: $statusCode, message: $message)';
}

class NetworkException extends AppException {
  const NetworkException({required super.message, super.statusCode, super.data});
}

class ServerException extends AppException {
  const ServerException({required super.message, super.statusCode, super.data});
}

class UnauthorizedException extends AppException {
  const UnauthorizedException({super.message = 'Non authentifié ou session expirée', super.statusCode = 401, super.data});
}

class CacheException extends AppException {
  const CacheException({required super.message});
}
