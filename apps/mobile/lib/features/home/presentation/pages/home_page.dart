import 'package:design_system/design_system.dart';
import 'package:feature_auth/feature_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobile/app/config/app_config.dart';
import 'package:mobile/features/settings/settings.dart';
import 'package:signals_flutter/signals_flutter.dart';

/// Main application home dashboard showcasing architecture and navigation.
class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
    required this.config,
    required this.authBloc,
    required this.settingsBloc,
    required this.onNavigateToProfile,
    required this.onNavigateToSettings,
    required this.onNavigateToLogin,
  });

  final AppConfig config;
  final AuthBloc authBloc;
  final SettingsBloc settingsBloc;
  final VoidCallback onNavigateToProfile;
  final VoidCallback onNavigateToSettings;
  final VoidCallback onNavigateToLogin;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(config.appName),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: 'Settings',
            onPressed: onNavigateToSettings,
          ),
          IconButton(
            icon: const Icon(Icons.person_outline_rounded),
            tooltip: 'Profile',
            onPressed: onNavigateToProfile,
          ),
        ],
      ),
      body: SignalBuilder(
        builder: (context) {
          final authState = authBloc.state();
          final settingsState = settingsBloc.state();

          return SingleChildScrollView(
            padding: AppSpacing.paddingMd,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Hero Banner
                Container(
                  padding: AppSpacing.paddingLg,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        theme.colorScheme.primary,
                        theme.colorScheme.secondary,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: AppRadius.radiusLg,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.sm,
                              vertical: AppSpacing.xxs,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: AppRadius.radiusSm,
                            ),
                            child: Text(
                              config.environment.name.toUpperCase(),
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const Spacer(),
                          if (authState.isAuthenticated)
                            TextButton.icon(
                              onPressed: () => authBloc.logout(),
                              icon: const Icon(Icons.logout,
                                  color: Colors.white, size: 16),
                              label: const Text(
                                'Sign Out',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                        ],
                      ),
                      AppSpacing.gapV16,
                      Text(
                        authState.isAuthenticated
                            ? 'Hello, ${authState.user?.name}!'
                            : 'Flutter Starter Architecture',
                        style: theme.textTheme.headlineLarge?.copyWith(
                          color: Colors.white,
                        ),
                      ),
                      AppSpacing.gapV8,
                      Text(
                        authState.isAuthenticated
                            ? 'Session active • ${authState.user?.email}'
                            : 'Monorepo • LEGO Modules • Pragmatic Clean Architecture',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.white.withValues(alpha: 0.85),
                        ),
                      ),
                    ],
                  ),
                ),
                AppSpacing.gapV24,

                // Quick Navigation Grid
                Text(
                  'Explore Modules',
                  style: theme.textTheme.titleMedium,
                ),
                AppSpacing.gapV12,
                Row(
                  children: [
                    Expanded(
                      child: _FeatureCard(
                        title: 'Profile',
                        subtitle:
                            'Medium feature with repository & DTO mapping',
                        icon: Icons.account_circle_outlined,
                        onTap: onNavigateToProfile,
                      ),
                    ),
                    AppSpacing.gapH12,
                    Expanded(
                      child: _FeatureCard(
                        title: 'Settings',
                        subtitle: 'Simple feature with state & preferences',
                        icon: Icons.tune_rounded,
                        onTap: onNavigateToSettings,
                      ),
                    ),
                  ],
                ),
                AppSpacing.gapV12,
                _FeatureCard(
                  title: 'Authentication',
                  subtitle: authState.isAuthenticated
                      ? 'Currently authenticated as ${authState.user?.name}'
                      : 'Complex feature with datasources, use cases, and token storage',
                  icon: Icons.security_rounded,
                  onTap: authState.isAuthenticated
                      ? onNavigateToProfile
                      : onNavigateToLogin,
                ),

                AppSpacing.gapV24,

                // Architecture Health Checklist
                Text(
                  'Architecture Verification',
                  style: theme.textTheme.titleMedium,
                ),
                AppSpacing.gapV12,
                Card(
                  child: Padding(
                    padding: AppSpacing.paddingMd,
                    child: Column(
                      children: [
                        const _CheckItem(
                          title: 'Kaisel Routing',
                          subtitle: 'Strongly typed route dispatching',
                          isPassed: true,
                        ),
                        const Divider(height: 1),
                        const _CheckItem(
                          title: 'bloc_signals State',
                          subtitle: 'Reactive signal states & hydration ready',
                          isPassed: true,
                        ),
                        const Divider(height: 1),
                        _CheckItem(
                          title: 'Centralized Dio & Logging',
                          subtitle: 'Base URL: ${config.apiBaseUrl}',
                          isPassed: true,
                        ),
                        const Divider(height: 1),
                        _CheckItem(
                          title: 'Theme Mode',
                          subtitle:
                              'Active: ${settingsState.themeMode.name.toUpperCase()}',
                          isPassed: true,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  const _FeatureCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: AppSpacing.paddingMd,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: theme.colorScheme.primary, size: 28),
              AppSpacing.gapV12,
              Text(title, style: theme.textTheme.titleMedium),
              AppSpacing.gapV4,
              Text(
                subtitle,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CheckItem extends StatelessWidget {
  const _CheckItem({
    required this.title,
    required this.subtitle,
    required this.isPassed,
  });

  final String title;
  final String subtitle;
  final bool isPassed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        children: [
          Icon(
            isPassed
                ? Icons.check_circle_rounded
                : Icons.radio_button_unchecked,
            color: isPassed ? AppColors.success : theme.colorScheme.error,
            size: 20,
          ),
          AppSpacing.gapH12,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: theme.textTheme.labelLarge),
                Text(
                  subtitle,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
