import 'package:app_core/src/logging/app_logger.dart';

/// Logger used when diagnostics are disabled by environment configuration.
class NoopAppLogger implements AppLogger {
  const NoopAppLogger();

  @override
  void debug(String message, [Object? error, StackTrace? stackTrace]) {}

  @override
  void info(String message, [Object? error, StackTrace? stackTrace]) {}

  @override
  void warning(String message, [Object? error, StackTrace? stackTrace]) {}

  @override
  void error(String message, [Object? error, StackTrace? stackTrace]) {}

  @override
  void fatal(String message, [Object? error, StackTrace? stackTrace]) {}
}
