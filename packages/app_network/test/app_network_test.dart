import 'package:app_network/app_network.dart';
import 'package:flutter_test/flutter_test.dart';

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
}
