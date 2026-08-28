import 'package:app_core/app_core.dart';
import 'package:dio/dio.dart';

/// Maps [DioException] to strongly typed domain [Failure]s from `app_core`.
class NetworkErrorMapper implements ErrorMapper<DioException, Failure> {
  const NetworkErrorMapper();

  @override
  Failure map(DioException exception, [StackTrace? stackTrace]) {
    final trace = stackTrace ?? exception.stackTrace;

    switch (exception.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.transformTimeout:
        return TimeoutFailure(
          message: 'Network timeout occurred',
          cause: exception,
          stackTrace: trace,
        );

      case DioExceptionType.connectionError:
        return ConnectivityFailure(
          message: 'Unable to connect to the server',
          cause: exception,
          stackTrace: trace,
        );

      case DioExceptionType.cancel:
        return CancelledFailure(
          message: 'Request was cancelled',
          cause: exception,
          stackTrace: trace,
        );

      case DioExceptionType.badResponse:
        return _mapStatusCode(exception, trace);

      case DioExceptionType.badCertificate:
      case DioExceptionType.unknown:
        return UnknownFailure(
          message: exception.message ?? 'An unknown network error occurred',
          cause: exception,
          stackTrace: trace,
        );
    }
  }

  Failure _mapStatusCode(DioException exception, StackTrace stackTrace) {
    final response = exception.response;
    final statusCode = response?.statusCode ?? 0;
    final data = response?.data;

    String? extractMessage() {
      if (data is Map<String, dynamic>) {
        return (data['message'] as String?) ?? (data['error'] as String?);
      }
      return null;
    }

    final message = extractMessage() ?? exception.message;

    switch (statusCode) {
      case 400:
        return ValidationFailure(
          message: message ?? 'Bad request',
          fieldErrors: _extractFieldErrors(data),
          cause: exception,
          stackTrace: stackTrace,
        );

      case 401:
        return UnauthorizedFailure(
          message: message ?? 'Unauthorized access',
          cause: exception,
          stackTrace: stackTrace,
        );

      case 403:
        return ForbiddenFailure(
          message: message ?? 'Access forbidden',
          cause: exception,
          stackTrace: stackTrace,
        );

      case 404:
        return NotFoundFailure(
          message: message ?? 'Resource not found',
          cause: exception,
          stackTrace: stackTrace,
        );

      case 409:
        return ConflictFailure(
          message: message ?? 'Resource conflict',
          cause: exception,
          stackTrace: stackTrace,
        );

      case 422:
        return ValidationFailure(
          message: message ?? 'Validation failed',
          fieldErrors: _extractFieldErrors(data),
          cause: exception,
          stackTrace: stackTrace,
        );

      case 429:
        return RateLimitFailure(
          message: message ?? 'Rate limit exceeded',
          cause: exception,
          stackTrace: stackTrace,
        );

      default:
        if (statusCode >= 500) {
          return ServerFailure(
            message: message ?? 'Internal server error',
            statusCode: statusCode,
            cause: exception,
            stackTrace: stackTrace,
          );
        }
        return UnknownFailure(
          message: message ?? 'HTTP error $statusCode',
          cause: exception,
          stackTrace: stackTrace,
        );
    }
  }

  Map<String, List<String>> _extractFieldErrors(dynamic data) {
    if (data is! Map<String, dynamic>) return const {};

    final errors = data['errors'] ?? data['field_errors'];
    if (errors is! Map<String, dynamic>) return const {};

    final result = <String, List<String>>{};
    errors.forEach((key, value) {
      if (value is List) {
        result[key] = value.map((e) => e.toString()).toList();
      } else if (value is String) {
        result[key] = [value];
      }
    });

    return result;
  }
}
