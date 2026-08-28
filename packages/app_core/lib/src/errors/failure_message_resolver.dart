import 'package:app_core/src/failures/app_failures.dart';
import 'package:app_core/src/failures/failure.dart';

/// Resolves user-friendly error messages from [Failure] instances.
/// UI and presentation layers use this resolver rather than exposing raw error details.
class FailureMessageResolver {
  const FailureMessageResolver();

  /// Converts a [Failure] into a friendly user-facing description.
  String resolve(Failure failure) {
    if (failure is ConnectivityFailure) {
      return "You're offline. Please check your internet connection and try again.";
    }

    if (failure is TimeoutFailure) {
      return 'The request took too long to complete. Please try again.';
    }

    if (failure is UnauthorizedFailure) {
      return 'Your session has expired. Please log in again.';
    }

    if (failure is ForbiddenFailure) {
      return 'You do not have permission to perform this action.';
    }

    if (failure is ValidationFailure) {
      if (failure.fieldErrors.isNotEmpty) {
        final firstField = failure.fieldErrors.entries.first;
        if (firstField.value.isNotEmpty) {
          return firstField.value.first;
        }
      }
      return failure.message ?? 'Please check the entered information.';
    }

    if (failure is NotFoundFailure) {
      return failure.message ?? 'The requested item was not found.';
    }

    if (failure is ConflictFailure) {
      return failure.message ?? 'A conflict occurred with the existing data.';
    }

    if (failure is RateLimitFailure) {
      return 'Too many requests. Please slow down and try again later.';
    }

    if (failure is ServerFailure) {
      return 'We encountered a problem on our servers. Please try again later.';
    }

    if (failure is CacheFailure) {
      return 'Unable to load local data. Please try again.';
    }

    if (failure is CancelledFailure) {
      return 'The operation was cancelled.';
    }

    return 'Something went wrong. Please try again.';
  }
}
