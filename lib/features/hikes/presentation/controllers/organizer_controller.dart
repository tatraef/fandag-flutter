import 'package:fandag/features/hikes/domain/domain.dart';
import 'package:fandag/features/hikes/presentation/controllers/hikes_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'organizer_controller.g.dart';

/// An organizer profile with their upcoming hikes.
@riverpod
Future<Organizer> organizerProfile(Ref ref, int id) {
  return ref.watch(hikeRepositoryProvider).getOrganizer(id);
}
