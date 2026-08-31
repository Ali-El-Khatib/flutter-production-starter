import 'package:app_core/app_core.dart';
import 'package:design_system/design_system.dart';
import 'package:feature_auth/feature_auth.dart';
import 'package:injectable/injectable.dart';
import 'package:mobile/app/config/app_config.dart';
import 'package:mobile/app/feedback/toastification_feedback.dart';
import 'package:mobile/app/router/app_router.dart';
import 'package:mobile/app/router/route_guards.dart';

@module
abstract class AppModule {
  @lazySingleton
  AppLogger logger(AppConfig config) =>
      config.enableLogging ? LoggerAppLogger() : const NoopAppLogger();

  @lazySingleton
  FailureMessageResolver get failureMessageResolver =>
      const FailureMessageResolver();

  @lazySingleton
  AppFeedback get feedback => const ToastificationFeedback();

  @lazySingleton
  AppRouter router(AuthBloc authBloc) => AppRouter(
        guards: [
          AuthRouteGuard(
            isAuthenticatedProvider: () => authBloc.state.value.isAuthenticated,
          ),
        ],
      );
}
