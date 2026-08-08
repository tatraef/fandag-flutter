import 'package:fandag/core/theme/theme.dart';
import 'package:fandag/core/translations/generated/translations.g.dart';
import 'package:fandag/features/hikes/domain/domain.dart';
import 'package:flutter/material.dart';

/// UI representation of a difficulty grade: the localized wording and its place
/// on the green-to-red ramp.
///
/// Both switches are exhaustive, so a new grade in [HikeDifficulty] does not
/// compile until it is given a label and a color — the old string-keyed badge
/// silently painted unknown grades grey instead.
extension HikeDifficultyUi on HikeDifficulty {
  String label(BuildContext context) => switch (this) {
    HikeDifficulty.easy => context.t.difficulty.easy,
    HikeDifficulty.belowMedium => context.t.difficulty.belowMedium,
    HikeDifficulty.medium => context.t.difficulty.medium,
    HikeDifficulty.aboveMedium => context.t.difficulty.aboveMedium,
    HikeDifficulty.hard => context.t.difficulty.hard,
  };

  Color color(BuildContext context) => switch (this) {
    HikeDifficulty.easy => context.colors.difficultyEasy,
    HikeDifficulty.belowMedium => context.colors.difficultyBelowMedium,
    HikeDifficulty.medium => context.colors.difficultyMedium,
    HikeDifficulty.aboveMedium => context.colors.difficultyAboveMedium,
    HikeDifficulty.hard => context.colors.difficultyHard,
  };
}
