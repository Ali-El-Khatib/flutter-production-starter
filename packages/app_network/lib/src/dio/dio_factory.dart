import 'package:app_core/app_core.dart';
import 'package:app_network/src/dio/dio_options.dart';
import 'package:app_network/src/interceptors/auth_interceptor.dart';
import 'package:app_network/src/interceptors/logging_interceptor.dart';
import 'package:app_network/src/interceptors/retry_interceptor.dart';
import 'package:dio/dio.dart';

/// Central factory for creating configured [Dio] instances.
class DioFactory {
  const DioFactory();

  static Dio create({
    required DioNetworkOptions options,
    AppLogger? logger,
    TokenProvider? tokenProvider,
    List<Interceptor>? customInterceptors,
    bool enableLogging = true,
    bool enableRetry = true,
  }) {
    final dio = Dio(
      BaseOptions(
        baseUrl: options.baseUrl,
        connectTimeout: options.connectTimeout,
        receiveTimeout: options.receiveTimeout,
        sendTimeout: options.sendTimeout,
        headers: options.defaultHeaders,
        responseType: ResponseType.json,
      ),
    );

    // Attach Auth Interceptor if token provider is given
    if (tokenProvider != null) {
      dio.interceptors.add(AuthInterceptor(tokenProvider: tokenProvider));
    }

    // Attach Retry Interceptor
    if (enableRetry) {
      dio.interceptors.add(RetryInterceptor(dio: dio));
    }

    // Attach Custom Interceptors
    if (customInterceptors != null) {
      dio.interceptors.addAll(customInterceptors);
    }

    // Attach Logging Interceptor
    if (enableLogging && logger != null) {
      dio.interceptors.add(NetworkLoggingInterceptor(logger: logger));
    }

    return dio;
  }
}
