import 'dart:async';

import 'package:fandag/features/favorites/domain/domain.dart';
import 'package:fandag/features/favorites/presentation/controllers/favorites_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'favorite_ids_controller.g.dart';

/// The set of favorite hike ids, kept in memory and mirrored to local storage.
@Riverpod(keepAlive: true)
class FavoriteIds extends _$FavoriteIds {
  @override
  Set<int> build() {
    return ref.read(favoritesRepositoryProvider).getFavoriteIds().toSet();
  }

  bool isFavorite(int hikeId) => state.contains(hikeId);

  Future<void> toggle(int hikeId) async {
    final FavoritesRepository repository = ref.read(favoritesRepositoryProvider);

    if (state.contains(hikeId)) {
      state = <int>{...state}..remove(hikeId);
      await repository.remove(hikeId);
    } else {
      state = <int>{hikeId, ...state};
      await repository.add(hikeId);
    }
  }

  /// Drops an id without touching storage order — used when a hike 404s.
  void forget(int hikeId) {
    if (state.contains(hikeId)) {
      state = <int>{...state}..remove(hikeId);
      unawaited(ref.read(favoritesRepositoryProvider).remove(hikeId));
    }
  }
}
