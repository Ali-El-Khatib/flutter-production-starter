import 'dart:io';
import 'package:dio/dio.dart';

/// Interceptor that retries failed idempotent HTTP requests on connectivity or temporary network errors.
class RetryInterceptor extends Interceptor {
  RetryInterceptor({
    required this.dio,
    this.maxRetries = 2,
    this.retryDelay = const Duration(milliseconds: 500),
  });

  final Dio dio;
  final int maxRetries;
  final Duration retryDelay;

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final extra = err.requestOptions.extra;
    final retryCount = (extra['retry_count'] as int?) ?? 0;

    final isIdempotent = err.requestOptions.method == 'GET' ||
        err.requestOptions.method == 'HEAD' ||
        err.requestOptions.method == 'OPTIONS';

    final shouldRetry =
        isIdempotent && retryCount < maxRetries && _isRetryableError(err);

    if (shouldRetry) {
      await Future<void>.delayed(retryDelay * (retryCount + 1));
      final options = err.requestOptions;
      options.extra['retry_count'] = retryCount + 1;

      try {
        final response = await dio.fetch<dynamic>(options);
        return handler.resolve(response);
      } on DioException catch (retryErr) {
        return handler.next(retryErr);
      }
    }

    return handler.next(err);
  }

  bool _isRetryableError(DioException err) {
    return err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.connectionError ||
        (err.error != null && err.error is SocketException);
  }
}
