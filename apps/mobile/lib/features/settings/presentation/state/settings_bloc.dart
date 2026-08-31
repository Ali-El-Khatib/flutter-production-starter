import 'dart:async';

import 'package:app_core/app_core.dart';
import 'package:app_storage/app_storage.dart';
import 'package:bloc_signals/bloc_signals.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'settings_state.dart';

export 'settings_state.dart';

sealed class SettingsEvent {}

class LoadSettingsEvent extends SettingsEvent {
  LoadSettingsEvent(this.completer);

  final Completer<void> completer;
}

class SetThemeModeEvent extends SettingsEvent {
  SetThemeModeEvent(this.themeMode);
  final ThemeMode themeMode;
}

class ToggleNotificationsEvent extends SettingsEvent {
  ToggleNotificationsEvent(this.enabled);
  final bool enabled;
}

class ToggleAnalyticsEvent extends SettingsEvent {
  ToggleAnalyticsEvent(this.enabled);
  final bool enabled;
}

/// Simple feature BLoC managing theme and user preferences.
@lazySingleton
class SettingsBloc extends BlocSignal<SettingsEvent, SettingsState> {
  SettingsBloc(this._storage, this._logger)
      : super(initialState: const SettingsState()) {
    on<LoadSettingsEvent>((event, emit) async {
      try {
        final themeName = await _storage.getString(_themeModeKey);
        final notificationsEnabled = await _storage.getBool(_notificationsKey);
        final analyticsEnabled = await _storage.getBool(_analyticsKey);
        emit(
          state.value.copyWith(
            themeMode: _themeModeFromName(themeName),
            notificationsEnabled: notificationsEnabled,
            analyticsEnabled: analyticsEnabled,
          ),
        );
      } catch (error, stackTrace) {
        _logger.warning(
          'Unable to restore user preferences; defaults remain active.',
          error,
          stackTrace,
        );
      } finally {
        if (!event.completer.isCompleted) {
          event.completer.complete();
        }
      }
    });

    on<SetThemeModeEvent>((event, emit) async {
      emit(state.value.copyWith(themeMode: event.themeMode));
      await _persist(
        () => _storage.setString(_themeModeKey, event.themeMode.name),
      );
    });

    on<ToggleNotificationsEvent>((event, emit) async {
      emit(state.value.copyWith(notificationsEnabled: event.enabled));
      await _persist(
        () => _storage.setBool(_notificationsKey, event.enabled),
      );
    });

    on<ToggleAnalyticsEvent>((event, emit) async {
      emit(state.value.copyWith(analyticsEnabled: event.enabled));
      await _persist(() => _storage.setBool(_analyticsKey, event.enabled));
    });
  }

  static const _themeModeKey = 'settings.theme_mode';
  static const _notificationsKey = 'settings.notifications_enabled';
  static const _analyticsKey = 'settings.analytics_enabled';

  final KeyValueStorage _storage;
  final AppLogger _logger;

  Future<void> initialize() {
    final completer = Completer<void>();
    add(LoadSettingsEvent(completer));
    return completer.future;
  }

  void setThemeMode(ThemeMode mode) => add(SetThemeModeEvent(mode));
  void toggleNotifications(bool enabled) =>
      add(ToggleNotificationsEvent(enabled));
  void toggleAnalytics(bool enabled) => add(ToggleAnalyticsEvent(enabled));

  ThemeMode? _themeModeFromName(String? name) {
    return switch (name) {
      'system' => ThemeMode.system,
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => null,
    };
  }

  Future<void> _persist(Future<void> Function() operation) async {
    try {
      await operation();
    } catch (error, stackTrace) {
      _logger.warning(
        'Unable to persist user preference.',
        error,
        stackTrace,
      );
    }
  }
}
