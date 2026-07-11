import 'package:fandag/core/theme/theme.dart';
import 'package:fandag/core/translations/generated/translations.g.dart';
import 'package:fandag/features/hikes/domain/domain.dart';
import 'package:fandag/features/hikes/presentation/controllers/controllers.dart';
import 'package:fandag/features/hikes/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class HikesFeedPage extends StatelessWidget {
  const HikesFeedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fændag'),
        actions: const <Widget>[_FilterAction()],
      ),
      body: const _FeedBody(),
    );
  }
}

class _FilterAction extends ConsumerWidget {
  const _FilterAction();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final HikeFilters filters = ref.watch(
      hikesFeedControllerProvider.select(
        (AsyncValue<HikesFeedState> s) =>
            s.value?.filters ?? const HikeFilters(),
      ),
    );

    Future<void> openFilters() async {
      final HikeFilters? result = await FiltersSheet.show(context, filters);

      if (result != null) {
        await ref
            .read(hikesFeedControllerProvider.notifier)
            .applyFilters(result);
      }
    }

    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        IconButton(
          icon: const Icon(Icons.tune),
          onPressed: openFilters,
        ),
        if (filters.isActive)
          Positioned(
            top: 12,
            right: 12,
            child: Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: context.colors.accent,
                shape: BoxShape.circle,
              ),
            ),
          ),
      ],
    );
  }
}

class _FeedBody extends ConsumerWidget {
  const _FeedBody();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<HikesFeedState> state = ref.watch(
      hikesFeedControllerProvider,
    );

    return state.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (Object error, StackTrace _) => _FeedError(
        onRetry: () => ref.read(hikesFeedControllerProvider.notifier).refresh(),
      ),
      data: (HikesFeedState data) {
        return RefreshIndicator(
          onRefresh: () =>
              ref.read(hikesFeedControllerProvider.notifier).refresh(),
          child: data.hikes.isEmpty
              ? const _FeedEmpty()
              : _FeedList(state: data),
        );
      },
    );
  }
}

class _FeedList extends ConsumerWidget {
  const _FeedList({required this.state});

  final HikesFeedState state;

  static const double _padding = 16;
  static const double _loadMoreThreshold = 300;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool showFooter = state.hasMore || state.isLoadingMore;

    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification notification) {
        final bool nearBottom = notification.metrics.pixels >=
            notification.metrics.maxScrollExtent - _loadMoreThreshold;

        if (nearBottom && state.hasMore && !state.isLoadingMore) {
          ref.read(hikesFeedControllerProvider.notifier).loadMore();
        }

        return false;
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(_padding),
        itemCount: state.hikes.length + (showFooter ? 1 : 0),
        itemBuilder: (BuildContext context, int index) {
          if (index >= state.hikes.length) {
            return const Padding(
              padding: EdgeInsets.all(_padding),
              child: Center(child: CircularProgressIndicator()),
            );
          }

          final Hike hike = state.hikes[index];

          return HikeCard(
            hike: hike,
            onTap: () => context.push('/hike/${hike.id}'),
          );
        },
      ),
    );
  }
}

class _FeedEmpty extends StatelessWidget {
  const _FeedEmpty();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight,
              minWidth: constraints.maxWidth,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.terrain_outlined,
                  size: 96,
                  color: context.colors.textTertiary,
                ),
                const SizedBox(height: 16),
                Text(
                  context.t.feed.empty,
                  style: context.primaryFonts.regular16,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _FeedError extends StatelessWidget {
  const _FeedError({required this.onRetry});

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
              context.t.feed.loadError,
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
