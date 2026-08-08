import 'package:fandag/core/theme/theme.dart';
import 'package:fandag/features/hikes/domain/domain.dart';
import 'package:fandag/features/hikes/presentation/extensions/extensions.dart';
import 'package:flutter/material.dart';

/// Colored badge for a hike difficulty, tinted along the green-to-red ramp of
/// the five-step scale.
class DifficultyBadge extends StatelessWidget {
  const DifficultyBadge({required this.difficulty, super.key});

  final HikeDifficulty difficulty;

  static const double _horizontalPadding = 8;
  static const double _verticalPadding = 4;
  static const double _radius = 8;
  static const double _backgroundOpacity = 0.15;

  @override
  Widget build(BuildContext context) {
    final Color color = difficulty.color(context);

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
        difficulty.label(context),
        style: context.primaryFonts.medium12.copyWith(color: color),
      ),
    );
  }
}
