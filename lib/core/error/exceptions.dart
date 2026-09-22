class AppException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic data;

  const AppException({required this.message, this.statusCode, this.data});

  @override
  String toString() =>
      'AppException(statusCode: $statusCode, message: $message)';
}

class NetworkException extends AppException {
  const NetworkException({
    required super.message,
    super.statusCode,
    super.data,
  });
}

class ServerException extends AppException {
  const ServerException({required super.message, super.statusCode, super.data});
}

class UnauthorizedException extends AppException {
  const UnauthorizedException({
    super.message = 'Non authentifié ou session expirée',
    super.statusCode = 401,
    super.data,
  });
}

class ForbiddenException extends AppException {
  const ForbiddenException({
    super.message = 'Action non autorisée',
    super.statusCode = 403,
    super.data,
  });
}

/// Thrown on HTTP 422 Unprocessable Entity.
/// [errors] contains field-level validation errors from the backend.
class ValidationException extends ServerException {
  final Map<String, dynamic>? errors;

  const ValidationException({
    required super.message,
    super.statusCode = 422,
    super.data,
    this.errors,
  });
}

class CacheException extends AppException {
  const CacheException({required super.message});
}
