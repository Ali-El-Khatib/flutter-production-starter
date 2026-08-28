import 'package:app_core/app_core.dart';
import 'package:injectable/injectable.dart';
import 'package:mobile/app/feedback/app_feedback.dart';
import 'package:mobile/app/feedback/toastification_feedback.dart';
import 'package:mobile/app/router/app_router.dart';

@module
abstract class AppModule {
  @lazySingleton
  AppLogger get logger => LoggerAppLogger();

  @lazySingleton
  FailureMessageResolver get failureMessageResolver =>
      const FailureMessageResolver();

  @lazySingleton
  AppFeedback get feedback => const ToastificationFeedback();

  @lazySingleton
  AppRouter get router => AppRouter();
}
