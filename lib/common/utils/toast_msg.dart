import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

class AppToast {
  // Show success toast
  static void success(BuildContext context, String message) {
    toastification.show(
      context: context,
      type: ToastificationType.success,
      style: ToastificationStyle.flat,
      autoCloseDuration: const Duration(seconds: 3),
      title: Text('Success'),
      description: Text(message),
      alignment: Alignment.bottomCenter,
      backgroundColor: Colors.green,
      foregroundColor: Colors.white,
      icon: const Icon(Icons.check_circle),
      showIcon: true,
    );
  }

  // Show error toast
  static void error(BuildContext context, String message) {
    toastification.show(
      context: context,
      type: ToastificationType.error,
      style: ToastificationStyle.flat,
      autoCloseDuration: const Duration(seconds: 3),
      title: Text('Error'),
      description: Text(message),
      alignment: Alignment.bottomCenter,
      backgroundColor: Colors.red,
      foregroundColor: Colors.white,
      icon: const Icon(Icons.error),
      showIcon: true,
    );
  }

  // Show info toast
  static void info(BuildContext context, String message) {
    toastification.show(
      context: context,
      type: ToastificationType.info,
      style: ToastificationStyle.flat,
      autoCloseDuration: const Duration(seconds: 3),
      title: Text('Info'),
      description: Text(message),
      alignment: Alignment.bottomCenter,
      backgroundColor: Colors.blue,
      foregroundColor: Colors.white,
      icon: const Icon(Icons.info),
      showIcon: true,
    );
  }

}
