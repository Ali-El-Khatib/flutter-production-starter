import 'package:flutter/material.dart';

/// Presentation layer feedback abstraction for transient toasts, dialogs, and snackbars.
abstract class AppFeedback {
  const AppFeedback();

  void showSuccess(
    BuildContext context,
    String message, {
    String? title,
    Duration? duration,
  });

  void showError(
    BuildContext context,
    String message, {
    String? title,
    Duration? duration,
  });

  void showWarning(
    BuildContext context,
    String message, {
    String? title,
    Duration? duration,
  });

  void showInfo(
    BuildContext context,
    String message, {
    String? title,
    Duration? duration,
  });
}
