import 'package:app_core/src/logging/app_logger.dart';
import 'package:logger/logger.dart';

/// Implementation of [AppLogger] wrapping `package:logger`.
/// Automatically filters and sanitizes sensitive data (passwords, tokens).
class LoggerAppLogger implements AppLogger {
  LoggerAppLogger({Logger? logger})
      : _logger = logger ??
            Logger(
              printer: PrettyPrinter(
                methodCount: 2,
                errorMethodCount: 8,
                lineLength: 100,
                colors: true,
                printEmojis: true,
                dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
              ),
            );

  final Logger _logger;

  static final RegExp _sensitivePattern = RegExp(
    r'(password|token|access_token|refresh_token|secret|authorization|bearer)\s*[:=]\s*([^,\s]+)',
    caseSensitive: false,
  );

  /// Sanitizes sensitive patterns in log messages.
  String _sanitize(String message) {
    return message.replaceAllMapped(_sensitivePattern, (match) {
      final key = match.group(1);
      return '$key=***REDACTED***';
    });
  }

  Object? _sanitizeError(Object? error) =>
      error == null ? null : _sanitize(error.toString());

  StackTrace? _sanitizeStackTrace(StackTrace? stackTrace) => stackTrace == null
      ? null
      : StackTrace.fromString(_sanitize(stackTrace.toString()));

  @override
  void debug(String message, [Object? error, StackTrace? stackTrace]) {
    _logger.d(
      _sanitize(message),
      error: _sanitizeError(error),
      stackTrace: _sanitizeStackTrace(stackTrace),
    );
  }

  @override
  void info(String message, [Object? error, StackTrace? stackTrace]) {
    _logger.i(
      _sanitize(message),
      error: _sanitizeError(error),
      stackTrace: _sanitizeStackTrace(stackTrace),
    );
  }

  @override
  void warning(String message, [Object? error, StackTrace? stackTrace]) {
    _logger.w(
      _sanitize(message),
      error: _sanitizeError(error),
      stackTrace: _sanitizeStackTrace(stackTrace),
    );
  }

  @override
  void error(String message, [Object? error, StackTrace? stackTrace]) {
    _logger.e(
      _sanitize(message),
      error: _sanitizeError(error),
      stackTrace: _sanitizeStackTrace(stackTrace),
    );
  }

  @override
  void fatal(String message, [Object? error, StackTrace? stackTrace]) {
    _logger.f(
      _sanitize(message),
      error: _sanitizeError(error),
      stackTrace: _sanitizeStackTrace(stackTrace),
    );
  }
}
