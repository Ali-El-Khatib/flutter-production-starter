import 'package:app_core/app_core.dart';
import 'package:app_storage/app_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/settings/settings.dart';

class _NoopLogger implements AppLogger {
  const _NoopLogger();

  @override
  void debug(String message, [Object? error, StackTrace? stackTrace]) {}

  @override
  void error(String message, [Object? error, StackTrace? stackTrace]) {}

  @override
  void fatal(String message, [Object? error, StackTrace? stackTrace]) {}

  @override
  void info(String message, [Object? error, StackTrace? stackTrace]) {}

  @override
  void warning(String message, [Object? error, StackTrace? stackTrace]) {}
}

void main() {
  group('SettingsBloc', () {
    late SettingsBloc settingsBloc;
    late InMemoryKeyValueStorage storage;

    setUp(() {
      storage = InMemoryKeyValueStorage();
      settingsBloc = SettingsBloc(storage, const _NoopLogger());
    });

    test('initial state defaults to dark theme', () {
      expect(settingsBloc.state.value.themeMode, equals(ThemeMode.dark));
    });

    test('changes theme mode to light and persists it', () async {
      settingsBloc.setThemeMode(ThemeMode.light);
      expect(settingsBloc.state.value.themeMode, equals(ThemeMode.light));
      await Future<void>.delayed(Duration.zero);
      expect(await storage.getString('settings.theme_mode'), equals('light'));
    });

    test('toggles notifications', () {
      settingsBloc.toggleNotifications(false);
      expect(settingsBloc.state.value.notificationsEnabled, isFalse);
    });

    test('toggles analytics', () {
      settingsBloc.toggleAnalytics(true);
      expect(settingsBloc.state.value.analyticsEnabled, isTrue);
    });

    test('restores persisted settings during initialization', () async {
      await storage.setString('settings.theme_mode', 'system');
      await storage.setBool('settings.notifications_enabled', false);
      await storage.setBool('settings.analytics_enabled', true);

      await settingsBloc.initialize();

      expect(settingsBloc.state.value.themeMode, ThemeMode.system);
      expect(settingsBloc.state.value.notificationsEnabled, isFalse);
      expect(settingsBloc.state.value.analyticsEnabled, isTrue);
    });
  });
}
