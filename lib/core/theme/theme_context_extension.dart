import 'package:fandag/core/theme/primary_fonts.dart';
import 'package:fandag/core/theme/theme_colors.dart';
import 'package:flutter/material.dart';

extension ThemeContextExtension on BuildContext {
  ThemeColors get colors => Theme.of(this).extension<ThemeColors>()!;

  PrimaryThemeFonts get primaryFonts =>
      Theme.of(this).extension<PrimaryThemeFonts>()!;
}
