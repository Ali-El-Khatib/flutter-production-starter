import 'package:app_core/app_core.dart';
import 'package:app_network/app_network.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/profile/data/repositories/profile_repository_impl.dart';

void main() {
  test('production profile repository preserves connectivity failures',
      () async {
    final dio = Dio(BaseOptions(baseUrl: 'https://api.example.com'));
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) => handler.reject(
          DioException(
            requestOptions: options,
            type: DioExceptionType.connectionError,
          ),
        ),
      ),
    );
    final repository = ProfileRepositoryImpl(ApiClient(dio: dio));

    final result = await repository.getProfile();

    expect(result.failureOrNull, isA<ConnectivityFailure>());
  });

  test('production profile repository rejects incomplete payloads', () async {
    final dio = Dio(BaseOptions(baseUrl: 'https://api.example.com'));
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) => handler.resolve(
          Response<Map<String, dynamic>>(
            requestOptions: options,
            data: const {},
            statusCode: 200,
          ),
        ),
      ),
    );
    final repository = ProfileRepositoryImpl(ApiClient(dio: dio));

    final result = await repository.getProfile();

    expect(result.failureOrNull, isA<DataContractFailure>());
  });
}
