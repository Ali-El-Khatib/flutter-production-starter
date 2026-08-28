import 'package:kaisel/kaisel.dart';

/// Base class for all strongly-typed application routes.
sealed class AppRoute extends KaiselRoute {
  const AppRoute();
}

/// Home dashboard route.
class HomeRoute extends AppRoute {
  const HomeRoute();

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is HomeRoute;

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() => 'HomeRoute()';
}

/// Settings page route.
class SettingsRoute extends AppRoute {
  const SettingsRoute();

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is SettingsRoute;

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() => 'SettingsRoute()';
}

/// Profile page route.
class ProfileRoute extends AppRoute {
  const ProfileRoute();

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is ProfileRoute;

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() => 'ProfileRoute()';
}

/// Authentication login route.
class LoginRoute extends AppRoute {
  const LoginRoute();

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is LoginRoute;

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() => 'LoginRoute()';
}
