/// Base class for all technical exceptions in the application.
abstract class AppException implements Exception {
  const AppException({
    this.message,
    this.code,
    this.cause,
    this.stackTrace,
  });

  final String? message;
  final String? code;
  final Object? cause;
  final StackTrace? stackTrace;

  @override
  String toString() =>
      '$runtimeType(message: $message, code: $code, cause: $cause)';
}

/// Technical exception for network failures (Dio, connectivity, timeouts).
class NetworkException extends AppException {
  const NetworkException({
    super.message,
    super.code,
    this.statusCode,
    super.cause,
    super.stackTrace,
  });

  final int? statusCode;
}

/// Technical exception for local storage/database errors.
class StorageException extends AppException {
  const StorageException({
    super.message,
    super.code,
    super.cause,
    super.stackTrace,
  });
}

/// Technical exception for JSON parsing or serialization errors.
class SerializationException extends AppException {
  const SerializationException({
    super.message,
    super.code,
    super.cause,
    super.stackTrace,
  });
}

/// Technical exception for platform channels or native plugin failures.
class PlatformIntegrationException extends AppException {
  const PlatformIntegrationException({
    super.message,
    super.code,
    super.cause,
    super.stackTrace,
  });
}
