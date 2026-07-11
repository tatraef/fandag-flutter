import 'dart:async';

import 'package:fandag/core/network/network.dart';
import 'package:fandag/features/favorites/presentation/controllers/favorite_ids_controller.dart';
import 'package:fandag/features/hikes/domain/domain.dart';
import 'package:fandag/features/hikes/presentation/controllers/controllers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'favorite_hikes_controller.g.dart';

/// Loads the hikes behind the saved favorite ids.
///
/// Ids that 404 (the hike passed and was cleaned up on the backend) are
/// silently dropped from local storage.
@riverpod
Future<List<Hike>> favoriteHikes(Ref ref) async {
  final Set<int> ids = ref.watch(favoriteIdsProvider);

  if (ids.isEmpty) {
    return const <Hike>[];
  }

  final HikeRepository repository = ref.watch(hikeRepositoryProvider);
  final List<Hike> hikes = <Hike>[];
  final List<int> staleIds = <int>[];

  for (final int id in ids) {
    try {
      hikes.add(await repository.getHike(id));
    } on NotFoundException {
      staleIds.add(id);
    }
  }

  if (staleIds.isNotEmpty) {
    // Defer storage mutation so we don't change a watched provider mid-build.
    unawaited(
      Future<void>.microtask(() {
        for (final int id in staleIds) {
          ref.read(favoriteIdsProvider.notifier).forget(id);
        }
      }),
    );
  }

  return hikes;
}
