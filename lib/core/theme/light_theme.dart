import 'package:fandag/core/theme/app_colors.dart';
import 'package:fandag/core/theme/app_theme_data.dart';
import 'package:flutter/material.dart';

ThemeData lightTheme() {
  const AppThemeData themeData = AppThemeData.light;

  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.light,
    ),
    scaffoldBackgroundColor: themeData.colors.backgroundPrimary,
    appBarTheme: AppBarTheme(
      backgroundColor: themeData.colors.surfacePrimary,
      foregroundColor: themeData.colors.textPrimary,
      elevation: 0,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: themeData.colors.accent,
        foregroundColor: themeData.colors.textInverse,
        minimumSize: const Size.fromHeight(48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: themeData.colors.surfaceSecondary,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: themeData.colors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: themeData.colors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: themeData.colors.accent, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: themeData.colors.error),
      ),
    ),
    extensions: themeData.extensions,
  );
}
