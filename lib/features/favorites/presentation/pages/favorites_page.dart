import 'package:fandag/core/theme/theme.dart';
import 'package:fandag/core/translations/generated/translations.g.dart';
import 'package:fandag/features/favorites/presentation/controllers/controllers.dart';
import 'package:fandag/features/hikes/domain/domain.dart';
import 'package:fandag/features/hikes/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Favorites tab — saved hikes loaded by their locally stored ids.
class FavoritesPage extends ConsumerWidget {
  const FavoritesPage({super.key});

  static const double _padding = 16;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<Hike>> hikesAsync = ref.watch(favoriteHikesProvider);

    return Scaffold(
      appBar: AppBar(title: Text(context.t.navigation.favorites)),
      body: hikesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (Object error, StackTrace _) => _FavoritesError(
          onRetry: () => ref.invalidate(favoriteHikesProvider),
        ),
        data: (List<Hike> hikes) {
          if (hikes.isEmpty) {
            return const _FavoritesEmpty();
          }

          return ListView.builder(
            padding: const EdgeInsets.all(_padding),
            itemCount: hikes.length,
            itemBuilder: (BuildContext context, int index) {
              final Hike hike = hikes[index];

              return HikeCard(
                hike: hike,
                onTap: () => context.push('/hike/${hike.id}'),
              );
            },
          );
        },
      ),
    );
  }
}

class _FavoritesEmpty extends StatelessWidget {
  const _FavoritesEmpty();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.favorite_outline,
            size: 96,
            color: context.colors.textTertiary,
          ),
          const SizedBox(height: 16),
          Text(context.t.favorites.emptyMessage, style: context.primaryFonts.regular16),
        ],
      ),
    );
  }
}

class _FavoritesError extends StatelessWidget {
  const _FavoritesError({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              context.t.favorites.loadError,
              textAlign: TextAlign.center,
              style: context.primaryFonts.regular16,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onRetry,
              child: Text(context.t.common.retry),
            ),
          ],
        ),
      ),
    );
  }
}
