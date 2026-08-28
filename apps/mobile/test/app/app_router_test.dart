import 'package:flutter_test/flutter_test.dart';
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
  });
}
