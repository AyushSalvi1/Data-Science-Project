import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppProgressIndicator {
  static bool _isLoading = false;
  static void hide(BuildContext context) {
    if (_isLoading) {
      _isLoading = false;
      context.pop();
    }
  }

  static Future<void> show(BuildContext context) async {
    _isLoading = true;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Center(
          child: CircularProgressIndicator(
            color: ColorScheme.of(context).primary,
          ),
        );
      },
    );
  }

  ///This loading shows the loading with container on it
  static Future<void> showWithContainer(BuildContext context) async {
    _isLoading = true;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Center(
          child: Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainer,
                boxShadow: const [
                  BoxShadow(
                      color: Colors.black54,
                      blurRadius: 1,
                      offset: Offset(1, 1))
                ],
                borderRadius: BorderRadius.circular(15)),
            child: Center(
              child: CircularProgressIndicator(
                color: ColorScheme.of(context).primary,
              ),
            ),
          ),
        );
      },
    );
  }
}
