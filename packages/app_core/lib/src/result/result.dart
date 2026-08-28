import 'package:app_core/src/failures/failure.dart';
import 'package:meta/meta.dart';

/// A sealed class representing the outcome of an operation: either [Success] or [FailureResult].
@sealed
abstract class Result<T> {
  const Result();

  /// Creates a successful result holding [data].
  const factory Result.success(T data) = Success<T>;

  /// Creates a failure result holding [failure].
  const factory Result.failure(Failure failure) = FailureResult<T>;

  /// Returns `true` if this is a [Success].
  bool get isSuccess => this is Success<T>;

  /// Returns `true` if this is a [FailureResult].
  bool get isFailure => this is FailureResult<T>;

  /// Returns the encapsulated data if [Success], otherwise `null`.
  T? get dataOrNull => when(
        success: (data) => data,
        failure: (_) => null,
      );

  /// Returns the encapsulated [Failure] if [FailureResult], otherwise `null`.
  Failure? get failureOrNull => when(
        success: (_) => null,
        failure: (failure) => failure,
      );

  /// Pattern-matches over [Success] and [FailureResult].
  R when<R>({
    required R Function(T data) success,
    required R Function(Failure failure) failure,
  }) {
    final self = this;
    if (self is Success<T>) {
      return success(self.data);
    } else if (self is FailureResult<T>) {
      return failure(self.failure);
    }
    throw StateError('Unknown Result subclass: $self');
  }

  /// Maps the success data using [transform].
  Result<R> map<R>(R Function(T data) transform) {
    return when(
      success: (data) => Result.success(transform(data)),
      failure: (failure) => Result.failure(failure),
    );
  }

  /// Chains another operation returning a [Result].
  Result<R> flatMap<R>(Result<R> Function(T data) transform) {
    return when(
      success: (data) => transform(data),
      failure: (failure) => Result.failure(failure),
    );
  }

  /// Folds the result into a single value [R].
  R fold<R>({
    required R Function(Failure failure) onFailure,
    required R Function(T data) onSuccess,
  }) {
    return when(
      success: onSuccess,
      failure: onFailure,
    );
  }

  /// Executes an action with error catching, returning a [Result].
  static Future<Result<T>> guard<T>(
    Future<T> Function() action, {
    required Failure Function(Object error, StackTrace stackTrace) onError,
  }) async {
    try {
      final result = await action();
      return Result.success(result);
    } catch (e, st) {
      return Result.failure(onError(e, st));
    }
  }

  /// Synchronous version of [guard].
  static Result<T> guardSync<T>(
    T Function() action, {
    required Failure Function(Object error, StackTrace stackTrace) onError,
  }) {
    try {
      final result = action();
      return Result.success(result);
    } catch (e, st) {
      return Result.failure(onError(e, st));
    }
  }
}

/// A successful [Result] containing [data].
class Success<T> extends Result<T> {
  const Success(this.data);

  final T data;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Success<T> &&
          runtimeType == other.runtimeType &&
          data == other.data;

  @override
  int get hashCode => data.hashCode;

  @override
  String toString() => 'Result.success($data)';
}

/// A failed [Result] containing a [Failure].
class FailureResult<T> extends Result<T> {
  const FailureResult(this.failure);

  final Failure failure;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FailureResult<T> &&
          runtimeType == other.runtimeType &&
          failure == other.failure;

  @override
  int get hashCode => failure.hashCode;

  @override
  String toString() => 'Result.failure($failure)';
}
