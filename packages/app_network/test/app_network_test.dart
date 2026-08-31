import 'package:app_network/app_network.dart';
import 'package:test/test.dart';

void main() {
  test('DioFactory creates Dio instance with default options', () {
    final dio = DioFactory.create(
      options: const DioNetworkOptions(baseUrl: 'https://api.example.com'),
      enableLogging: false,
    );

    expect(dio.options.baseUrl, equals('https://api.example.com'));
    final apiClient = ApiClient(dio: dio);
    expect(apiClient, isNotNull);
  });

  test('DioFactory installs bearer authentication when provider is supplied',
      () async {
    final dio = DioFactory.create(
      options: const DioNetworkOptions(baseUrl: 'https://api.example.com'),
      tokenProvider: () async => 'access-token',
      enableLogging: false,
    );

    final interceptor = dio.interceptors.whereType<AuthInterceptor>().single;
    expect(await interceptor.tokenProvider(), equals('access-token'));
  });
}
