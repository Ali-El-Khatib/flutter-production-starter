import 'package:meta/meta.dart';

/// Base class for all domain/application failures.
@immutable
abstract class Failure {
  const Failure({
    this.message,
    this.code,
    this.cause,
    this.stackTrace,
  });

  /// Optional human-readable or developer diagnostic message.
  final String? message;

  /// Optional machine-readable error code.
  final String? code;

  /// Underlying cause if any.
  final Object? cause;

  /// Associated stack trace if available.
  final StackTrace? stackTrace;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Failure &&
          runtimeType == other.runtimeType &&
          message == other.message &&
          code == other.code;

  @override
  int get hashCode => Object.hash(runtimeType, message, code);

  @override
  String toString() => '$runtimeType(message: $message, code: $code)';
}
