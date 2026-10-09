import 'package:flutter/material.dart';

class AppLoading extends StatelessWidget {
  const AppLoading({super.key}) : _isCenter = false;
  const AppLoading.center({super.key}) : _isCenter = true;
  final bool _isCenter;
  @override
  Widget build(BuildContext context) {
    return _isCenter
        ? Center(
            child: CircularProgressIndicator(),
          )
        : CircularProgressIndicator();
  }
}
