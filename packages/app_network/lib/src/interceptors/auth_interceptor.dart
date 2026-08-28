import 'package:dio/dio.dart';

/// Contract or callback type for fetching the current active authentication token.
typedef TokenProvider = Future<String?> Function();

/// Dio Interceptor that automatically attaches Bearer authentication tokens.
class AuthInterceptor extends QueuedInterceptor {
  AuthInterceptor({required this.tokenProvider});

  final TokenProvider tokenProvider;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
      final token = await tokenProvider();
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    } catch (_) {
      // If token retrieval fails, continue request unauthenticated or let server return 401
    }
    return handler.next(options);
  }
}
