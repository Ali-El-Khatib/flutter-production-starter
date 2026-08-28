import 'package:flutter/material.dart';
import 'package:kaisel/kaisel.dart';
import 'package:mobile/app/router/app_routes.dart';
import 'package:mobile/app/router/route_guards.dart';

/// Central application router orchestrating [KaiselRouter] navigation and route guards.
class AppRouter extends ChangeNotifier {
  AppRouter({
    AppRoute initialRoute = const HomeRoute(),
    List<RouteGuard>? guards,
  })  : _kaiselRouter = KaiselRouter<AppRoute>(initial: initialRoute),
        _guards = guards ?? const [];

  final KaiselRouter<AppRoute> _kaiselRouter;
  final List<RouteGuard> _guards;

  AppRoute get current => _kaiselRouter.current;
  List<AppRoute> get stack => List.unmodifiable(_kaiselRouter.stack);
  bool get canPop => _kaiselRouter.stack.length > 1;

  Future<void> push(AppRoute route) async {
    final effectiveRoute = await _applyGuards(route);
    await _kaiselRouter.push(effectiveRoute);
    notifyListeners();
  }

  Future<void> replace(AppRoute route) async {
    final effectiveRoute = await _applyGuards(route);
    if (canPop) {
      await _kaiselRouter.pop();
    }
    await _kaiselRouter.push(effectiveRoute);
    notifyListeners();
  }

  Future<void> pop() async {
    if (canPop) {
      await _kaiselRouter.pop();
      notifyListeners();
    }
  }

  Future<void> toHome() => push(const HomeRoute());
  Future<void> toSettings() => push(const SettingsRoute());
  Future<void> toProfile() => push(const ProfileRoute());
  Future<void> toLogin() => push(const LoginRoute());

  Future<AppRoute> _applyGuards(AppRoute target) async {
    for (final guard in _guards) {
      final redirect = await guard.canNavigate(target);
      if (redirect != null) {
        return redirect;
      }
    }
    return target;
  }
}
