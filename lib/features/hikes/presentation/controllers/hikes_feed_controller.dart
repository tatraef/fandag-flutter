import 'package:fandag/features/hikes/domain/domain.dart';
import 'package:fandag/features/hikes/presentation/controllers/hikes_providers.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'hikes_feed_controller.freezed.dart';
part 'hikes_feed_controller.g.dart';

/// State of the hikes feed: the loaded page(s), active filters and paging info.
@freezed
abstract class HikesFeedState with _$HikesFeedState {
  const factory HikesFeedState({
    required List<Hike> hikes,
    required HikeFilters filters,
    @Default(0) int nextOffset,
    @Default(false) bool hasMore,
    @Default(false) bool isLoadingMore,
  }) = _HikesFeedState;
}

@riverpod
class HikesFeedController extends _$HikesFeedController {
  static const int pageSize = 20;

  @override
  Future<HikesFeedState> build() => _loadFirstPage(const HikeFilters());

  /// Reloads the first page with the current filters (pull-to-refresh).
  Future<void> refresh() async {
    final HikeFilters filters =
        state.value?.filters ?? const HikeFilters();
    state = await AsyncValue.guard(() => _loadFirstPage(filters));
  }

  /// Applies new filters and reloads from the first page.
  Future<void> applyFilters(HikeFilters filters) async {
    state = const AsyncLoading<HikesFeedState>();
    state = await AsyncValue.guard(() => _loadFirstPage(filters));
  }

  /// Loads the next page and appends it to the feed.
  Future<void> loadMore() async {
    final HikesFeedState? current = state.value;

    if (current == null || !current.hasMore || current.isLoadingMore) {
      return;
    }

    state = AsyncData<HikesFeedState>(current.copyWith(isLoadingMore: true));

    try {
      final List<Hike> raw = await ref
          .read(hikeRepositoryProvider)
          .getHikes(
            filters: current.filters,
            limit: pageSize,
            offset: current.nextOffset,
          );

      state = AsyncData<HikesFeedState>(
        current.copyWith(
          hikes: <Hike>[
            ...current.hikes,
            ..._narrow(raw, current.filters),
          ],
          nextOffset: current.nextOffset + raw.length,
          hasMore: raw.length == pageSize,
          isLoadingMore: false,
        ),
      );
    } on Exception {
      state = AsyncData<HikesFeedState>(current.copyWith(isLoadingMore: false));
    }
  }

  Future<HikesFeedState> _loadFirstPage(HikeFilters filters) async {
    final List<Hike> raw = await ref
        .read(hikeRepositoryProvider)
        .getHikes(filters: filters, limit: pageSize, offset: 0);

    return HikesFeedState(
      hikes: _narrow(raw, filters),
      filters: filters,
      nextOffset: raw.length,
      hasMore: raw.length == pageSize,
    );
  }

  /// Narrows the raw API page by the multi-select difficulty set.
  ///
  /// When a single difficulty is selected the server already filtered, so this
  /// is a no-op; for multiple selections we filter the page client-side.
  List<Hike> _narrow(List<Hike> hikes, HikeFilters filters) {
    if (filters.difficulties.isEmpty) {
      return hikes;
    }

    return hikes
        .where((Hike hike) => filters.difficulties.contains(hike.difficulty))
        .toList();
  }
}
