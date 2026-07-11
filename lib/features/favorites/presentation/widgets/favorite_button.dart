import 'package:fandag/core/theme/theme.dart';
import 'package:fandag/features/favorites/presentation/controllers/controllers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Heart toggle that reflects and mutates the favorite state of a hike.
class FavoriteButton extends ConsumerWidget {
  const FavoriteButton({
    required this.hikeId,
    this.filledColor,
    this.unfilledColor,
    super.key,
  });

  final int hikeId;

  /// Color for the filled heart; defaults to the theme accent.
  final Color? filledColor;

  /// Color for the empty heart; defaults to [ThemeColors.textInverse]
  /// (white, for placement over images).
  final Color? unfilledColor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isFavorite = ref.watch(
      favoriteIdsProvider.select((Set<int> ids) => ids.contains(hikeId)),
    );

    return IconButton(
      icon: Icon(
        isFavorite ? Icons.favorite : Icons.favorite_border,
        color: isFavorite
            ? (filledColor ?? context.colors.accent)
            : (unfilledColor ?? context.colors.textInverse),
      ),
      onPressed: () => ref.read(favoriteIdsProvider.notifier).toggle(hikeId),
    );
  }
}
