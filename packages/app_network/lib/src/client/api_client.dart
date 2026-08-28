import 'package:app_core/app_core.dart';
import 'package:app_network/src/errors/network_error_mapper.dart';
import 'package:dio/dio.dart';

/// HTTP Client abstraction wrapping [Dio] and returning standard [Result] types.
class ApiClient {
  ApiClient({
    required Dio dio,
    NetworkErrorMapper? errorMapper,
  })  : _dio = dio,
        _errorMapper = errorMapper ?? const NetworkErrorMapper();

  final Dio _dio;
  final NetworkErrorMapper _errorMapper;

  Dio get rawDio => _dio;

  Future<Result<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    T Function(dynamic data)? responseParser,
  }) async {
    return _execute(
      () => _dio.get<dynamic>(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      ),
      responseParser: responseParser,
    );
  }

  Future<Result<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    T Function(dynamic data)? responseParser,
  }) async {
    return _execute(
      () => _dio.post<dynamic>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      ),
      responseParser: responseParser,
    );
  }

  Future<Result<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    T Function(dynamic data)? responseParser,
  }) async {
    return _execute(
      () => _dio.put<dynamic>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      ),
      responseParser: responseParser,
    );
  }

  Future<Result<T>> patch<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    T Function(dynamic data)? responseParser,
  }) async {
    return _execute(
      () => _dio.patch<dynamic>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      ),
      responseParser: responseParser,
    );
  }

  Future<Result<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    T Function(dynamic data)? responseParser,
  }) async {
    return _execute(
      () => _dio.delete<dynamic>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      ),
      responseParser: responseParser,
    );
  }

  Future<Result<T>> _execute<T>(
    Future<Response<dynamic>> Function() request, {
    T Function(dynamic data)? responseParser,
  }) async {
    try {
      final response = await request();
      final data = response.data;
      if (responseParser != null) {
        final parsed = responseParser(data);
        return Result.success(parsed);
      }
      return Result.success(data as T);
    } on DioException catch (e, st) {
      final failure = _errorMapper.map(e, st);
      return Result.failure(failure);
    } catch (e, st) {
      return Result.failure(
        UnknownFailure(
          message: e.toString(),
          cause: e,
          stackTrace: st,
        ),
      );
    }
  }
}
