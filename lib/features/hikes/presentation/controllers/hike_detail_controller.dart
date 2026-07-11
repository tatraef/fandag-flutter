import 'package:fandag/features/hikes/domain/domain.dart';
import 'package:fandag/features/hikes/presentation/controllers/hikes_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'hike_detail_controller.g.dart';

/// Full details of a single hike (includes the organizer's city).
@riverpod
Future<Hike> hikeDetail(Ref ref, int id) {
  return ref.watch(hikeRepositoryProvider).getHike(id);
}
