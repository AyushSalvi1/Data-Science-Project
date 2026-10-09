import 'package:flex_seed_scheme/flex_seed_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

// Modern color scheme for ShopWave
const Color primarySeedColor = Color(0xFF6200EE); // Deep purple for primary
const Color secondarySeedColor =
    Color(0xFF03DAC6); // Teal for secondary accents
const Color tertiarySeedColor = Color(0xFFFF4081); // Pink for tertiary elements

final ColorScheme schemeLight = SeedColorScheme.fromSeeds(
  brightness: Brightness.light,
  primaryKey: primarySeedColor,
  secondaryKey: secondarySeedColor,
  tertiaryKey: tertiarySeedColor,
  tones: FlexTones.vivid(Brightness.light),
);

final ColorScheme schemeDark = SeedColorScheme.fromSeeds(
  brightness: Brightness.dark,
  primaryKey: primarySeedColor,
  secondaryKey: secondarySeedColor,
  tertiaryKey: tertiarySeedColor,
  tones: FlexTones.highContrast(Brightness.dark),
);

ThemeData lightTheme(BuildContext context) => ThemeData(
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: AppBarTheme(
        systemOverlayStyle: SystemUiOverlayStyle.light.copyWith(
          statusBarColor: Colors.white,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
          systemNavigationBarColor: Colors.white,
          systemNavigationBarIconBrightness: Brightness.dark,
          systemNavigationBarDividerColor: Colors.transparent,
        ),
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.white,
      ),
      colorScheme: schemeLight,
      textTheme: GoogleFonts.latoTextTheme(Theme.of(context).textTheme),
    );

ThemeData darkTheme(BuildContext context) => ThemeData(
      colorScheme: schemeDark,
      textTheme: GoogleFonts.latoTextTheme().apply(
          bodyColor: schemeDark.onSurface, displayColor: schemeDark.onSurface),
    );
