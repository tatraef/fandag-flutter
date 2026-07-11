import 'package:fandag/features/hikes/domain/entities/entities.dart';

abstract class HikeRepository {
  /// Returns a page of hikes sorted by `date_start` ascending.
  Future<List<Hike>> getHikes({
    required HikeFilters filters,
    required int limit,
    required int offset,
  });

  /// Returns a single hike by [id]. Throws [NotFoundException] on 404.
  Future<Hike> getHike(int id);

  /// Returns all organizers (used to populate the filter dropdown).
  Future<List<Organizer>> getOrganizers();

  /// Returns an organizer with their upcoming hikes. Throws on 404.
  Future<Organizer> getOrganizer(int id);
}
