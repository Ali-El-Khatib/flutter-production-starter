/// Logging interface for the application.
abstract class AppLogger {
  const AppLogger();

  void debug(String message, [Object? error, StackTrace? stackTrace]);
  void info(String message, [Object? error, StackTrace? stackTrace]);
  void warning(String message, [Object? error, StackTrace? stackTrace]);
  void error(String message, [Object? error, StackTrace? stackTrace]);
  void fatal(String message, [Object? error, StackTrace? stackTrace]);
}
