import 'package:app_core/app_core.dart';
import 'package:app_network/app_network.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:mobile/app/config/app_config.dart';

@module
abstract class NetworkModule {
  @lazySingleton
  NetworkErrorMapper get networkErrorMapper => const NetworkErrorMapper();

  @lazySingleton
  Dio dio(
    AppConfig config,
    AppLogger logger,
    TokenProvider tokenProvider,
  ) {
    return DioFactory.create(
      options: DioNetworkOptions(baseUrl: config.apiBaseUrl),
      logger: logger,
      tokenProvider: tokenProvider,
      enableLogging: config.enableNetworkLogging,
      enableRetry: true,
    );
  }

  @lazySingleton
  ApiClient apiClient(Dio dio, NetworkErrorMapper errorMapper) {
    return ApiClient(dio: dio, errorMapper: errorMapper);
  }
}
