import 'package:mobile/app/router/app_routes.dart';

/// Contract for intercepting and guarding route navigation.
abstract class RouteGuard {
  const RouteGuard();

  /// Returns a redirected [AppRoute] if access is denied, or `null` to allow.
  Future<AppRoute?> canNavigate(AppRoute target);
}

/// Authentication route guard that redirects to [LoginRoute] for protected routes if unauthenticated.
class AuthRouteGuard extends RouteGuard {
  AuthRouteGuard({required this.isAuthenticatedProvider});

  final bool Function() isAuthenticatedProvider;

  @override
  Future<AppRoute?> canNavigate(AppRoute target) async {
    final isAuthenticated = isAuthenticatedProvider();

    if (!isAuthenticated && target is ProfileRoute) {
      return const LoginRoute();
    }

    if (isAuthenticated && target is LoginRoute) {
      return const HomeRoute();
    }

    return null;
  }
}
