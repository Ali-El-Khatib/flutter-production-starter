import 'package:flutter/material.dart';

/// State representing user settings and preferences.
class SettingsState {
  const SettingsState({
    this.themeMode = ThemeMode.dark,
    this.notificationsEnabled = true,
    this.analyticsEnabled = false,
  });

  final ThemeMode themeMode;
  final bool notificationsEnabled;
  final bool analyticsEnabled;

  SettingsState copyWith({
    ThemeMode? themeMode,
    bool? notificationsEnabled,
    bool? analyticsEnabled,
  }) {
    return SettingsState(
      themeMode: themeMode ?? this.themeMode,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      analyticsEnabled: analyticsEnabled ?? this.analyticsEnabled,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SettingsState &&
          runtimeType == other.runtimeType &&
          themeMode == other.themeMode &&
          notificationsEnabled == other.notificationsEnabled &&
          analyticsEnabled == other.analyticsEnabled;

  @override
  int get hashCode =>
      Object.hash(themeMode, notificationsEnabled, analyticsEnabled);
}
