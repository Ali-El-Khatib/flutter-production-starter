import 'package:bloc_signals/bloc_signals.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:mobile/features/settings/presentation/state/settings_state.dart';

sealed class SettingsEvent {}

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
  SettingsBloc() : super(initialState: const SettingsState()) {
    on<SetThemeModeEvent>((event, emit) {
      emit(state.value.copyWith(themeMode: event.themeMode));
    });

    on<ToggleNotificationsEvent>((event, emit) {
      emit(state.value.copyWith(notificationsEnabled: event.enabled));
    });

    on<ToggleAnalyticsEvent>((event, emit) {
      emit(state.value.copyWith(analyticsEnabled: event.enabled));
    });
  }

  void setThemeMode(ThemeMode mode) => add(SetThemeModeEvent(mode));
  void toggleNotifications(bool enabled) =>
      add(ToggleNotificationsEvent(enabled));
  void toggleAnalytics(bool enabled) => add(ToggleAnalyticsEvent(enabled));
}
