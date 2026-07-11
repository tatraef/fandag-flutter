import 'package:flutter/material.dart';

class PrimaryThemeFonts extends ThemeExtension<PrimaryThemeFonts> {
  const PrimaryThemeFonts({
    required this.regular12,
    required this.regular14,
    required this.regular16,
    required this.medium12,
    required this.medium14,
    required this.medium16,
    required this.semibold14,
    required this.semibold16,
    required this.semibold18,
    required this.semibold20,
    required this.semibold24,
    required this.bold16,
    required this.bold20,
    required this.bold24,
    required this.bold28,
    required this.bold32,
  });

  final TextStyle regular12;
  final TextStyle regular14;
  final TextStyle regular16;
  final TextStyle medium12;
  final TextStyle medium14;
  final TextStyle medium16;
  final TextStyle semibold14;
  final TextStyle semibold16;
  final TextStyle semibold18;
  final TextStyle semibold20;
  final TextStyle semibold24;
  final TextStyle bold16;
  final TextStyle bold20;
  final TextStyle bold24;
  final TextStyle bold28;
  final TextStyle bold32;

  static const double _fontSize12 = 12;
  static const double _fontSize14 = 14;
  static const double _fontSize16 = 16;
  static const double _fontSize18 = 18;
  static const double _fontSize20 = 20;
  static const double _fontSize24 = 24;
  static const double _fontSize28 = 28;
  static const double _fontSize32 = 32;

  static const PrimaryThemeFonts instance = PrimaryThemeFonts(
    regular12: TextStyle(fontSize: _fontSize12, fontWeight: FontWeight.w400),
    regular14: TextStyle(fontSize: _fontSize14, fontWeight: FontWeight.w400),
    regular16: TextStyle(fontSize: _fontSize16, fontWeight: FontWeight.w400),
    medium12: TextStyle(fontSize: _fontSize12, fontWeight: FontWeight.w500),
    medium14: TextStyle(fontSize: _fontSize14, fontWeight: FontWeight.w500),
    medium16: TextStyle(fontSize: _fontSize16, fontWeight: FontWeight.w500),
    semibold14: TextStyle(fontSize: _fontSize14, fontWeight: FontWeight.w600),
    semibold16: TextStyle(fontSize: _fontSize16, fontWeight: FontWeight.w600),
    semibold18: TextStyle(fontSize: _fontSize18, fontWeight: FontWeight.w600),
    semibold20: TextStyle(fontSize: _fontSize20, fontWeight: FontWeight.w600),
    semibold24: TextStyle(fontSize: _fontSize24, fontWeight: FontWeight.w600),
    bold16: TextStyle(fontSize: _fontSize16, fontWeight: FontWeight.w700),
    bold20: TextStyle(fontSize: _fontSize20, fontWeight: FontWeight.w700),
    bold24: TextStyle(fontSize: _fontSize24, fontWeight: FontWeight.w700),
    bold28: TextStyle(fontSize: _fontSize28, fontWeight: FontWeight.w700),
    bold32: TextStyle(fontSize: _fontSize32, fontWeight: FontWeight.w700),
  );

  @override
  PrimaryThemeFonts copyWith({
    TextStyle? regular12,
    TextStyle? regular14,
    TextStyle? regular16,
    TextStyle? medium12,
    TextStyle? medium14,
    TextStyle? medium16,
    TextStyle? semibold14,
    TextStyle? semibold16,
    TextStyle? semibold18,
    TextStyle? semibold20,
    TextStyle? semibold24,
    TextStyle? bold16,
    TextStyle? bold20,
    TextStyle? bold24,
    TextStyle? bold28,
    TextStyle? bold32,
  }) {
    return PrimaryThemeFonts(
      regular12: regular12 ?? this.regular12,
      regular14: regular14 ?? this.regular14,
      regular16: regular16 ?? this.regular16,
      medium12: medium12 ?? this.medium12,
      medium14: medium14 ?? this.medium14,
      medium16: medium16 ?? this.medium16,
      semibold14: semibold14 ?? this.semibold14,
      semibold16: semibold16 ?? this.semibold16,
      semibold18: semibold18 ?? this.semibold18,
      semibold20: semibold20 ?? this.semibold20,
      semibold24: semibold24 ?? this.semibold24,
      bold16: bold16 ?? this.bold16,
      bold20: bold20 ?? this.bold20,
      bold24: bold24 ?? this.bold24,
      bold28: bold28 ?? this.bold28,
      bold32: bold32 ?? this.bold32,
    );
  }

  @override
  PrimaryThemeFonts lerp(PrimaryThemeFonts? other, double t) {
    if (other is! PrimaryThemeFonts) {
      return this;
    }

    return PrimaryThemeFonts(
      regular12: TextStyle.lerp(regular12, other.regular12, t)!,
      regular14: TextStyle.lerp(regular14, other.regular14, t)!,
      regular16: TextStyle.lerp(regular16, other.regular16, t)!,
      medium12: TextStyle.lerp(medium12, other.medium12, t)!,
      medium14: TextStyle.lerp(medium14, other.medium14, t)!,
      medium16: TextStyle.lerp(medium16, other.medium16, t)!,
      semibold14: TextStyle.lerp(semibold14, other.semibold14, t)!,
      semibold16: TextStyle.lerp(semibold16, other.semibold16, t)!,
      semibold18: TextStyle.lerp(semibold18, other.semibold18, t)!,
      semibold20: TextStyle.lerp(semibold20, other.semibold20, t)!,
      semibold24: TextStyle.lerp(semibold24, other.semibold24, t)!,
      bold16: TextStyle.lerp(bold16, other.bold16, t)!,
      bold20: TextStyle.lerp(bold20, other.bold20, t)!,
      bold24: TextStyle.lerp(bold24, other.bold24, t)!,
      bold28: TextStyle.lerp(bold28, other.bold28, t)!,
      bold32: TextStyle.lerp(bold32, other.bold32, t)!,
    );
  }
}
