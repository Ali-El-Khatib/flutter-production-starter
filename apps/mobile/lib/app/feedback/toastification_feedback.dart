import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

/// Toastification implementation of [AppFeedback].
class ToastificationFeedback implements AppFeedback {
  const ToastificationFeedback();

  @override
  void showSuccess(
    BuildContext context,
    String message, {
    String? title,
    Duration? duration = const Duration(seconds: 4),
  }) {
    toastification.show(
      context: context,
      type: ToastificationType.success,
      style: ToastificationStyle.flatColored,
      title: title != null ? Text(title) : null,
      description: Text(message),
      autoCloseDuration: duration,
      alignment: Alignment.topRight,
      showProgressBar: false,
    );
  }

  @override
  void showError(
    BuildContext context,
    String message, {
    String? title,
    Duration? duration = const Duration(seconds: 5),
  }) {
    toastification.show(
      context: context,
      type: ToastificationType.error,
      style: ToastificationStyle.flatColored,
      title: title != null ? Text(title) : null,
      description: Text(message),
      autoCloseDuration: duration,
      alignment: Alignment.topRight,
      showProgressBar: false,
    );
  }

  @override
  void showWarning(
    BuildContext context,
    String message, {
    String? title,
    Duration? duration = const Duration(seconds: 4),
  }) {
    toastification.show(
      context: context,
      type: ToastificationType.warning,
      style: ToastificationStyle.flatColored,
      title: title != null ? Text(title) : null,
      description: Text(message),
      autoCloseDuration: duration,
      alignment: Alignment.topRight,
      showProgressBar: false,
    );
  }

  @override
  void showInfo(
    BuildContext context,
    String message, {
    String? title,
    Duration? duration = const Duration(seconds: 4),
  }) {
    toastification.show(
      context: context,
      type: ToastificationType.info,
      style: ToastificationStyle.flatColored,
      title: title != null ? Text(title) : null,
      description: Text(message),
      autoCloseDuration: duration,
      alignment: Alignment.topRight,
      showProgressBar: false,
    );
  }
}
