import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppAnnotatedRegion extends StatelessWidget {
  const AppAnnotatedRegion({
    super.key,
    required this.child,
    this.statusBarColor,
    this.navigationBarColor,
    this.statusBarIconBrightness,
    this.navigationBarIconBrightness,
  });

  final Widget child;
  final Color? statusBarColor;
  final Color? navigationBarColor;
  final Brightness? statusBarIconBrightness;
  final Brightness? navigationBarIconBrightness;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = colorScheme.brightness == Brightness.dark;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        // Status bar
        statusBarColor: statusBarColor ?? 
            (isDark ? colorScheme.surface : Colors.white),
        statusBarIconBrightness: statusBarIconBrightness ?? 
            (isDark ? Brightness.light : Brightness.dark),
        statusBarBrightness: statusBarIconBrightness?.inverse ?? 
            (isDark ? Brightness.dark : Brightness.light),

        // Navigation bar
        systemNavigationBarColor: navigationBarColor ?? 
            (isDark ? colorScheme.surface : Colors.white),
        systemNavigationBarIconBrightness: navigationBarIconBrightness ?? 
            (isDark ? Brightness.light : Brightness.dark),
        systemNavigationBarDividerColor: Colors.transparent,
      ),
      child: child,
    );
  }
}

extension on Brightness {
  Brightness get inverse => 
      this == Brightness.light ? Brightness.dark : Brightness.light;
}