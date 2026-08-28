import 'package:feature_auth/feature_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobile/app/app.dart';
import 'package:mobile/app/config/app_config.dart';
import 'package:mobile/app/di/injection.dart';

/// Central composition bootstrap procedure for the Flutter starter application.
Future<void> bootstrap({required AppConfig config}) async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Dependency Injection with environment
  await configureDependencies(config);

  // Restore authenticated session state
  getIt<AuthBloc>().checkSession();

  runApp(const App());
}
