import 'package:app_core/src/failures/failure.dart';

/// Contract for mapping technical errors/exceptions into domain [Failure]s.
abstract class ErrorMapper<E, F extends Failure> {
  const ErrorMapper();

  /// Maps an error [exception] to a strongly typed [Failure].
  F map(E exception, [StackTrace? stackTrace]);
}
