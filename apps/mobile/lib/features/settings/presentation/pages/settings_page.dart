import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:mobile/features/settings/presentation/state/settings_bloc.dart';
import 'package:signals_flutter/signals_flutter.dart';

/// Settings and preferences screen.
class SettingsPage extends StatelessWidget {
  const SettingsPage({
    super.key,
    required this.settingsBloc,
    this.onBack,
  });

  final SettingsBloc settingsBloc;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        leading: onBack != null
            ? IconButton(
                icon: const Icon(Icons.arrow_back_rounded),
                onPressed: onBack,
              )
            : null,
      ),
      body: SignalBuilder(
        builder: (context) {
          final state = settingsBloc.state();

          return ListView(
            padding: AppSpacing.paddingMd,
            children: [
              Text(
                'Appearance',
                style: theme.textTheme.labelLarge?.copyWith(
                  color: theme.colorScheme.primary,
                ),
              ),
              AppSpacing.gapV8,
              Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(
                        state.themeMode == ThemeMode.dark
                            ? Icons.radio_button_checked
                            : Icons.radio_button_unchecked,
                        color: state.themeMode == ThemeMode.dark
                            ? theme.colorScheme.primary
                            : null,
                      ),
                      title: const Text('Dark Theme'),
                      subtitle: const Text('Sleek dark interface'),
                      onTap: () => settingsBloc.setThemeMode(ThemeMode.dark),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: Icon(
                        state.themeMode == ThemeMode.light
                            ? Icons.radio_button_checked
                            : Icons.radio_button_unchecked,
                        color: state.themeMode == ThemeMode.light
                            ? theme.colorScheme.primary
                            : null,
                      ),
                      title: const Text('Light Theme'),
                      subtitle: const Text('Bright clean interface'),
                      onTap: () => settingsBloc.setThemeMode(ThemeMode.light),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: Icon(
                        state.themeMode == ThemeMode.system
                            ? Icons.radio_button_checked
                            : Icons.radio_button_unchecked,
                        color: state.themeMode == ThemeMode.system
                            ? theme.colorScheme.primary
                            : null,
                      ),
                      title: const Text('System Theme'),
                      subtitle: const Text('Matches device system appearance'),
                      onTap: () => settingsBloc.setThemeMode(ThemeMode.system),
                    ),
                  ],
                ),
              ),
              AppSpacing.gapV24,
              Text(
                'Preferences',
                style: theme.textTheme.labelLarge?.copyWith(
                  color: theme.colorScheme.primary,
                ),
              ),
              AppSpacing.gapV8,
              Card(
                child: Column(
                  children: [
                    SwitchListTile(
                      title: const Text('Push Notifications'),
                      subtitle: const Text('Receive alerts and updates'),
                      value: state.notificationsEnabled,
                      onChanged: (val) => settingsBloc.toggleNotifications(val),
                    ),
                    const Divider(height: 1),
                    SwitchListTile(
                      title: const Text('Anonymous Analytics'),
                      subtitle: const Text('Help us improve the application'),
                      value: state.analyticsEnabled,
                      onChanged: (val) => settingsBloc.toggleAnalytics(val),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
