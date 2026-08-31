import 'package:mobile/app/config/environment.dart';

/// Global application environment configuration.
class AppConfig {
  const AppConfig({
    required this.environment,
    required this.appName,
    required this.apiBaseUrl,
    required this.enableDemoData,
    this.useInMemoryStorage = false,
    this.enableLogging = true,
    this.enableNetworkLogging = true,
  });

  final AppEnvironment environment;
  final String appName;
  final String apiBaseUrl;
  final bool enableDemoData;
  final bool useInMemoryStorage;
  final bool enableLogging;
  final bool enableNetworkLogging;

  factory AppConfig.development() {
    return const AppConfig(
      environment: AppEnvironment.development,
      appName: 'Flutter Starter (Dev)',
      apiBaseUrl: 'https://api.dev.example.com',
      enableDemoData: true,
      enableLogging: true,
      enableNetworkLogging: true,
    );
  }

  factory AppConfig.staging() {
    return const AppConfig(
      environment: AppEnvironment.staging,
      appName: 'Flutter Starter (Staging)',
      apiBaseUrl: 'https://api.staging.example.com',
      enableDemoData: false,
      enableLogging: true,
      enableNetworkLogging: true,
    );
  }

  factory AppConfig.production() {
    return const AppConfig(
      environment: AppEnvironment.production,
      appName: 'Flutter Starter',
      apiBaseUrl: 'https://api.example.com',
      enableDemoData: false,
      enableLogging: false,
      enableNetworkLogging: false,
    );
  }

  factory AppConfig.test() {
    return const AppConfig(
      environment: AppEnvironment.test,
      appName: 'Flutter Starter (Test)',
      apiBaseUrl: 'https://api.test.example.com',
      enableDemoData: true,
      useInMemoryStorage: true,
      enableLogging: false,
      enableNetworkLogging: false,
    );
  }
}
