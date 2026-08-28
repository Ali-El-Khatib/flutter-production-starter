import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/settings/settings.dart';

void main() {
  group('SettingsBloc', () {
    late SettingsBloc settingsBloc;

    setUp(() {
      settingsBloc = SettingsBloc();
    });

    test('initial state defaults to dark theme', () {
      expect(settingsBloc.state.value.themeMode, equals(ThemeMode.dark));
    });

    test('changes theme mode to light', () {
      settingsBloc.setThemeMode(ThemeMode.light);
      expect(settingsBloc.state.value.themeMode, equals(ThemeMode.light));
    });

    test('toggles notifications', () {
      settingsBloc.toggleNotifications(false);
      expect(settingsBloc.state.value.notificationsEnabled, isFalse);
    });

    test('toggles analytics', () {
      settingsBloc.toggleAnalytics(true);
      expect(settingsBloc.state.value.analyticsEnabled, isTrue);
    });
  });
}
