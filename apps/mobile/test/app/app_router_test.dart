import 'package:app_network/app_network.dart';
import 'package:auth_contract/auth_contract.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/app/config/app_config.dart';
import 'package:mobile/app/di/injection.dart';
import 'package:mobile/app/router/app_router.dart';
import 'package:mobile/app/router/app_routes.dart';
import 'package:mobile/app/router/route_guards.dart';

void main() {
  group('AppRouter & RouteGuards', () {
    test('navigates to settings and pops back', () async {
      final router = AppRouter(initialRoute: const HomeRoute());

      expect(router.current, isA<HomeRoute>());

      await router.toSettings();
      expect(router.current, isA<SettingsRoute>());

      await router.pop();
      expect(router.current, isA<HomeRoute>());
    });

    test(
        'AuthRouteGuard redirects unauthenticated users trying to access ProfileRoute',
        () async {
      bool isAuthenticated = false;

      final guard = AuthRouteGuard(
        isAuthenticatedProvider: () => isAuthenticated,
      );

      final router = AppRouter(
        initialRoute: const HomeRoute(),
        guards: [guard],
      );

      // Attempt to navigate to ProfileRoute while unauthenticated
      await router.toProfile();
      expect(router.current, isA<LoginRoute>());

      // Authenticate and navigate to LoginRoute -> redirects to HomeRoute
      isAuthenticated = true;
      await router.toLogin();
      expect(router.current, isA<HomeRoute>());
    });

    test('application composition installs auth guard and token provider',
        () async {
      await configureDependencies(AppConfig.test());

      final router = getIt<AppRouter>();
      await router.toProfile();
      expect(router.current, isA<LoginRoute>());

      final login = await getIt<AuthRepository>().login(
        email: 'developer@example.com',
        password: 'password123',
      );
      expect(login.isSuccess, isTrue);
      expect(await getIt<TokenProvider>()(), equals('demo_access_token'));
    });
  });
}
