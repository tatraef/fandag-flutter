import 'package:fandag/core/extensions/extensions.dart';
import 'package:fandag/core/theme/theme.dart';
import 'package:flutter/material.dart';

/// Colored badge for a hike difficulty
/// (easy = green, medium = orange, high = red).
class DifficultyBadge extends StatelessWidget {
  const DifficultyBadge({required this.difficulty, super.key});

  final String difficulty;

  static const double _horizontalPadding = 8;
  static const double _verticalPadding = 4;
  static const double _radius = 8;
  static const double _backgroundOpacity = 0.15;

  Color _color(BuildContext context) {
    final String normalized = difficulty.toLowerCase().replaceAll('ё', 'е').trim();

    return switch (normalized) {
      'легкая' => context.colors.success,
      'средняя' => context.colors.warning,
      'высокая' => context.colors.error,
      _ => context.colors.textTertiary,
    };
  }

  @override
  Widget build(BuildContext context) {
    final Color color = _color(context);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: _horizontalPadding,
        vertical: _verticalPadding,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: _backgroundOpacity),
        borderRadius: BorderRadius.circular(_radius),
      ),
      child: Text(
        difficulty.capitalize(),
        style: context.primaryFonts.medium12.copyWith(color: color),
      ),
    );
  }
}
