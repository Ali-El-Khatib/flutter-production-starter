import 'package:app_core/app_core.dart';
import 'package:dio/dio.dart';

/// Interceptor that logs network requests and responses using [AppLogger].
/// Ensures authorization headers and sensitive information are not logged in plain text.
class NetworkLoggingInterceptor extends Interceptor {
  NetworkLoggingInterceptor({
    required AppLogger logger,
    this.logRequestBody = false,
    this.logResponseBody = false,
  }) : _logger = logger;

  final AppLogger _logger;
  final bool logRequestBody;
  final bool logResponseBody;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final sanitizedHeaders = Map<String, dynamic>.from(options.headers);
    if (sanitizedHeaders.containsKey('Authorization')) {
      sanitizedHeaders['Authorization'] = 'Bearer ***REDACTED***';
    }

    _logger.debug(
      '--> [HTTP ${options.method.toUpperCase()}] ${options.uri}\n'
      'Headers: $sanitizedHeaders'
      '${logRequestBody && options.data != null ? '\nBody: ${options.data}' : ''}',
    );

    return handler.next(options);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    _logger.debug(
      '<-- [HTTP ${response.statusCode}] ${response.requestOptions.uri}'
      '${logResponseBody && response.data != null ? '\nResponse: ${response.data}' : ''}',
    );

    return handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    _logger.error(
      '<-- [HTTP ERROR ${err.response?.statusCode ?? 'NO_STATUS'}] ${err.requestOptions.uri}\n'
      'Type: ${err.type}\n'
      'Message: ${err.message}',
      err,
      err.stackTrace,
    );

    return handler.next(err);
  }
}
