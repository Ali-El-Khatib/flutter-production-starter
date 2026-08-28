import 'package:mobile/app/config/environment.dart';

/// Global application environment configuration.
class AppConfig {
  const AppConfig({
    required this.environment,
    required this.appName,
    required this.apiBaseUrl,
    this.enableLogging = true,
    this.enableNetworkLogging = true,
  });

  final AppEnvironment environment;
  final String appName;
  final String apiBaseUrl;
  final bool enableLogging;
  final bool enableNetworkLogging;

  factory AppConfig.development() {
    return const AppConfig(
      environment: AppEnvironment.development,
      appName: 'Flutter Starter (Dev)',
      apiBaseUrl: 'https://api.dev.example.com',
      enableLogging: true,
      enableNetworkLogging: true,
    );
  }

  factory AppConfig.staging() {
    return const AppConfig(
      environment: AppEnvironment.staging,
      appName: 'Flutter Starter (Staging)',
      apiBaseUrl: 'https://api.staging.example.com',
      enableLogging: true,
      enableNetworkLogging: true,
    );
  }

  factory AppConfig.production() {
    return const AppConfig(
      environment: AppEnvironment.production,
      appName: 'Flutter Starter',
      apiBaseUrl: 'https://api.example.com',
      enableLogging: false,
      enableNetworkLogging: false,
    );
  }
}
