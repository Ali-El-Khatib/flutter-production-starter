import 'package:app_core/app_core.dart';
import 'package:app_network/app_network.dart';
import 'package:app_storage/app_storage.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:feature_auth/src/data/datasources/auth_remote_data_source.dart';
import 'package:feature_auth/src/data/datasources/demo_auth_remote_data_source.dart';
import 'package:feature_auth/src/data/repositories/auth_repository_impl.dart';

class _PayloadDataSource implements AuthRemoteDataSource {
  const _PayloadDataSource(this.payload);

  final Map<String, dynamic> payload;

  @override
  Future<Result<Map<String, dynamic>>> login({
    required String email,
    required String password,
  }) async =>
      Result.success(payload);

  @override
  Future<Result<void>> logout() async => const Result.success(null);

  @override
  Future<Result<Map<String, dynamic>>> getCurrentUser() async =>
      const Result.success({});
}

void main() {
  test('real remote source preserves connectivity failures', () async {
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
    final source = AuthRemoteDataSourceImpl(ApiClient(dio: dio));

    final result = await source.login(
      email: 'user@example.com',
      password: 'password123',
    );

    expect(result.failureOrNull, isA<ConnectivityFailure>());
  });

  test('development demo source is explicit and deterministic', () async {
    const source = DemoAuthRemoteDataSource();

    final result = await source.login(
      email: 'user@example.com',
      password: 'password123',
    );

    expect(result.dataOrNull?['token'], equals('demo_access_token'));
  });

  test('repository rejects incomplete authentication payloads', () async {
    final repository = AuthRepositoryImpl(
      remoteDataSource: const _PayloadDataSource({'user': <String, dynamic>{}}),
      secureStorage: InMemorySecureStorage(),
    );

    final result = await repository.login(
      email: 'user@example.com',
      password: 'password123',
    );

    expect(result.failureOrNull, isA<DataContractFailure>());
  });
}
