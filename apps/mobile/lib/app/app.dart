import 'package:app_core/app_core.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:mobile/app/config/app_config.dart';
import 'package:mobile/app/di/injection.dart';
import 'package:mobile/app/feedback/app_feedback.dart';
import 'package:mobile/app/router/app_router.dart';
import 'package:mobile/app/router/app_routes.dart';
import 'package:mobile/features/auth/auth.dart';
import 'package:mobile/features/home/home.dart';
import 'package:mobile/features/profile/profile.dart';
import 'package:mobile/features/settings/settings.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:toastification/toastification.dart';

/// Root application widget.
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final config = getIt<AppConfig>();
    final router = getIt<AppRouter>();
    final authBloc = getIt<AuthBloc>();
    final settingsBloc = getIt<SettingsBloc>();
    final profileBloc = getIt<ProfileBloc>();
    final failureResolver = getIt<FailureMessageResolver>();
    final feedback = getIt<AppFeedback>();

    return ToastificationWrapper(
      child: SignalBuilder(
        builder: (context) {
          final settingsState = settingsBloc.state();

          return MaterialApp(
            title: config.appName,
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: settingsState.themeMode,
            home: AnimatedBuilder(
              animation: router,
              builder: (context, _) {
                final currentRoute = router.current;

                return PopScope(
                  canPop: !router.canPop,
                  onPopInvokedWithResult: (didPop, _) {
                    if (!didPop && router.canPop) {
                      router.pop();
                    }
                  },
                  child: AnimatedSwitcher(
                    duration: AppDurations.normal,
                    child: KeyedSubtree(
                      key: ValueKey(currentRoute.runtimeType),
                      child: switch (currentRoute) {
                        HomeRoute() => HomePage(
                            config: config,
                            authBloc: authBloc,
                            settingsBloc: settingsBloc,
                            onNavigateToProfile: () => router.toProfile(),
                            onNavigateToSettings: () => router.toSettings(),
                            onNavigateToLogin: () => router.toLogin(),
                          ),
                        SettingsRoute() => SettingsPage(
                            settingsBloc: settingsBloc,
                            onBack: () => router.pop(),
                          ),
                        ProfileRoute() => ProfilePage(
                            profileBloc: profileBloc,
                            messageResolver: failureResolver,
                            onBack: () => router.pop(),
                          ),
                        LoginRoute() => LoginPage(
                            authBloc: authBloc,
                            messageResolver: failureResolver,
                            feedback: feedback,
                            onLoginSuccess: () => router.toHome(),
                            onBack: () => router.pop(),
                          ),
                      },
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
