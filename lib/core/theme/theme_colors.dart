import 'package:fandag/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class ThemeColors extends ThemeExtension<ThemeColors> {
  const ThemeColors({
    required this.textPrimary,
    required this.textSecondary,
    required this.textTertiary,
    required this.textInverse,
    required this.backgroundPrimary,
    required this.backgroundSecondary,
    required this.surfacePrimary,
    required this.surfaceSecondary,
    required this.border,
    required this.divider,
    required this.accent,
    required this.error,
    required this.success,
    required this.warning,
  });

  final Color textPrimary;
  final Color textSecondary;
  final Color textTertiary;
  final Color textInverse;
  final Color backgroundPrimary;
  final Color backgroundSecondary;
  final Color surfacePrimary;
  final Color surfaceSecondary;
  final Color border;
  final Color divider;
  final Color accent;
  final Color error;
  final Color success;
  final Color warning;

  static const ThemeColors light = ThemeColors(
    textPrimary: AppColors.grey900,
    textSecondary: AppColors.grey600,
    textTertiary: AppColors.grey400,
    textInverse: AppColors.white,
    backgroundPrimary: AppColors.backgroundLight,
    backgroundSecondary: AppColors.white,
    surfacePrimary: AppColors.surfaceLight,
    surfaceSecondary: AppColors.grey100,
    border: AppColors.grey300,
    divider: AppColors.grey200,
    accent: AppColors.primary,
    error: AppColors.error,
    success: AppColors.success,
    warning: AppColors.warning,
  );

  static const ThemeColors dark = ThemeColors(
    textPrimary: AppColors.white,
    textSecondary: AppColors.grey400,
    textTertiary: AppColors.grey600,
    textInverse: AppColors.grey900,
    backgroundPrimary: AppColors.backgroundDark,
    backgroundSecondary: AppColors.surfaceDark,
    surfacePrimary: AppColors.surfaceDark,
    surfaceSecondary: AppColors.grey800,
    border: AppColors.grey700,
    divider: AppColors.grey800,
    accent: AppColors.primaryLight,
    error: AppColors.errorLight,
    success: AppColors.success,
    warning: AppColors.warning,
  );

  @override
  ThemeColors copyWith({
    Color? textPrimary,
    Color? textSecondary,
    Color? textTertiary,
    Color? textInverse,
    Color? backgroundPrimary,
    Color? backgroundSecondary,
    Color? surfacePrimary,
    Color? surfaceSecondary,
    Color? border,
    Color? divider,
    Color? accent,
    Color? error,
    Color? success,
    Color? warning,
  }) {
    return ThemeColors(
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textTertiary: textTertiary ?? this.textTertiary,
      textInverse: textInverse ?? this.textInverse,
      backgroundPrimary: backgroundPrimary ?? this.backgroundPrimary,
      backgroundSecondary: backgroundSecondary ?? this.backgroundSecondary,
      surfacePrimary: surfacePrimary ?? this.surfacePrimary,
      surfaceSecondary: surfaceSecondary ?? this.surfaceSecondary,
      border: border ?? this.border,
      divider: divider ?? this.divider,
      accent: accent ?? this.accent,
      error: error ?? this.error,
      success: success ?? this.success,
      warning: warning ?? this.warning,
    );
  }

  @override
  ThemeColors lerp(ThemeColors? other, double t) {
    if (other is! ThemeColors) {
      return this;
    }

    return ThemeColors(
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textTertiary: Color.lerp(textTertiary, other.textTertiary, t)!,
      textInverse: Color.lerp(textInverse, other.textInverse, t)!,
      backgroundPrimary: Color.lerp(
        backgroundPrimary,
        other.backgroundPrimary,
        t,
      )!,
      backgroundSecondary: Color.lerp(
        backgroundSecondary,
        other.backgroundSecondary,
        t,
      )!,
      surfacePrimary: Color.lerp(surfacePrimary, other.surfacePrimary, t)!,
      surfaceSecondary: Color.lerp(
        surfaceSecondary,
        other.surfaceSecondary,
        t,
      )!,
      border: Color.lerp(border, other.border, t)!,
      divider: Color.lerp(divider, other.divider, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      error: Color.lerp(error, other.error, t)!,
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
    );
  }
}
