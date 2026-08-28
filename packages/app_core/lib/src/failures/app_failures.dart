import 'package:app_core/src/failures/failure.dart';

/// Failure when there is no internet connection.
class ConnectivityFailure extends Failure {
  const ConnectivityFailure({
    super.message = 'No internet connection',
    super.code = 'CONNECTIVITY_ERROR',
    super.cause,
    super.stackTrace,
  });
}

/// Failure when a request times out.
class TimeoutFailure extends Failure {
  const TimeoutFailure({
    super.message = 'The operation timed out',
    super.code = 'TIMEOUT_ERROR',
    super.cause,
    super.stackTrace,
  });
}

/// Failure when authentication is missing or token has expired (HTTP 401).
class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure({
    super.message = 'Unauthorized access',
    super.code = 'UNAUTHORIZED',
    super.cause,
    super.stackTrace,
  });
}

/// Failure when permission is denied (HTTP 403).
class ForbiddenFailure extends Failure {
  const ForbiddenFailure({
    super.message = 'Access forbidden',
    super.code = 'FORBIDDEN',
    super.cause,
    super.stackTrace,
  });
}

/// Failure when input validation fails (HTTP 422 or local form validation).
class ValidationFailure extends Failure {
  const ValidationFailure({
    super.message = 'Validation failed',
    super.code = 'VALIDATION_ERROR',
    this.fieldErrors = const {},
    super.cause,
    super.stackTrace,
  });

  /// Specific errors mapped per field (e.g. {'email': ['Invalid email format']}).
  final Map<String, List<String>> fieldErrors;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      super == other &&
          other is ValidationFailure &&
          _mapsEqual(fieldErrors, other.fieldErrors);

  @override
  int get hashCode => Object.hash(super.hashCode, fieldErrors.toString());

  static bool _mapsEqual(
    Map<String, List<String>> a,
    Map<String, List<String>> b,
  ) {
    if (a.length != b.length) return false;
    for (final key in a.keys) {
      if (!b.containsKey(key)) return false;
      final listA = a[key]!;
      final listB = b[key]!;
      if (listA.length != listB.length) return false;
      for (int i = 0; i < listA.length; i++) {
        if (listA[i] != listB[i]) return false;
      }
    }
    return true;
  }
}

/// Failure when a requested resource is not found (HTTP 404).
class NotFoundFailure extends Failure {
  const NotFoundFailure({
    super.message = 'Resource not found',
    super.code = 'NOT_FOUND',
    super.cause,
    super.stackTrace,
  });
}

/// Failure when a conflict occurs (HTTP 409).
class ConflictFailure extends Failure {
  const ConflictFailure({
    super.message = 'Resource conflict',
    super.code = 'CONFLICT',
    super.cause,
    super.stackTrace,
  });
}

/// Failure when rate limit is exceeded (HTTP 429).
class RateLimitFailure extends Failure {
  const RateLimitFailure({
    super.message = 'Too many requests. Please try again later.',
    super.code = 'RATE_LIMITED',
    this.retryAfter,
    super.cause,
    super.stackTrace,
  });

  final Duration? retryAfter;
}

/// Failure when server encounters an error (HTTP 500+).
class ServerFailure extends Failure {
  const ServerFailure({
    super.message = 'Server encountered an error',
    super.code = 'SERVER_ERROR',
    this.statusCode,
    super.cause,
    super.stackTrace,
  });

  final int? statusCode;
}

/// Failure when local cache/storage read or write fails.
class CacheFailure extends Failure {
  const CacheFailure({
    super.message = 'Storage or cache failure',
    super.code = 'CACHE_ERROR',
    super.cause,
    super.stackTrace,
  });
}

/// Failure when an operation was intentionally cancelled.
class CancelledFailure extends Failure {
  const CancelledFailure({
    super.message = 'Operation was cancelled',
    super.code = 'CANCELLED',
    super.cause,
    super.stackTrace,
  });
}

/// Failure for unexpected or unmapped errors.
class UnknownFailure extends Failure {
  const UnknownFailure({
    super.message = 'An unexpected error occurred',
    super.code = 'UNKNOWN_ERROR',
    super.cause,
    super.stackTrace,
  });
}
