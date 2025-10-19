import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../services/settings_service.dart';

/// Theme container housing both light and dark configurations.
class AppThemeData {
  const AppThemeData({required this.lightTheme, required this.darkTheme});

  final ThemeData lightTheme;
  final ThemeData darkTheme;
}

/// Provides color palettes and typography derived from the shared seed.
class AppTheme {
  static const Color seedColor = Color(0xFFB48CFF);

  /// Creates theme instances taking into account user settings.
  static AppThemeData buildTheme(SettingsService settings) {
    final textTheme = GoogleFonts.plusJakartaSansTextTheme();
    final baseLight = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: seedColor, brightness: Brightness.light),
      textTheme: textTheme,
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: FadeThroughPageTransitionsBuilder(),
          TargetPlatform.iOS: FadeThroughPageTransitionsBuilder(),
          TargetPlatform.macOS: FadeThroughPageTransitionsBuilder(),
        },
      ),
    );

    final baseDark = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: seedColor, brightness: Brightness.dark),
      textTheme: textTheme,
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: FadeThroughPageTransitionsBuilder(),
          TargetPlatform.iOS: FadeThroughPageTransitionsBuilder(),
          TargetPlatform.macOS: FadeThroughPageTransitionsBuilder(),
        },
      ),
    );

    final scaleFactor = settings.fontScale;

    ThemeData scaleTheme(ThemeData base) {
      return base.copyWith(
        textTheme: base.textTheme.apply(fontSizeFactor: scaleFactor),
        appBarTheme: base.appBarTheme.copyWith(
          backgroundColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
        ),
      );
    }

    return AppThemeData(
      lightTheme: scaleTheme(baseLight),
      darkTheme: scaleTheme(baseDark),
    );
  }
}
