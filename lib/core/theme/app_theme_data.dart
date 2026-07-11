import 'package:fandag/core/theme/primary_fonts.dart';
import 'package:fandag/core/theme/theme_colors.dart';
import 'package:flutter/material.dart';

class AppThemeData {
  const AppThemeData({required this.colors, required this.fonts});

  final ThemeColors colors;
  final PrimaryThemeFonts fonts;

  static const AppThemeData light = AppThemeData(
    colors: ThemeColors.light,
    fonts: PrimaryThemeFonts.instance,
  );

  static const AppThemeData dark = AppThemeData(
    colors: ThemeColors.dark,
    fonts: PrimaryThemeFonts.instance,
  );

  List<ThemeExtension<dynamic>> get extensions => <ThemeExtension<dynamic>>[
    colors,
    fonts,
  ];
}
