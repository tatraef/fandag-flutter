import 'package:fandag/features/hikes/data/data.dart';
import 'package:fandag/features/hikes/domain/domain.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('HikeRepositoryMock', () {
    test('loads the bundled snapshot sorted by date', () async {
      final HikeRepositoryMock repository = HikeRepositoryMock();

      final List<Hike> hikes = await repository.getHikes(
        filters: const HikeFilters(),
        limit: 20,
        offset: 0,
      );

      expect(hikes, isNotEmpty);
      expect(hikes.first.title, 'Ледник Тана');
      expect(hikes.first.organizer.name, 'Твоя Высота');
      expect(hikes.first.images, isNotEmpty);
      for (int i = 1; i < hikes.length; i++) {
        expect(
          hikes[i].dateStart.isBefore(hikes[i - 1].dateStart),
          isFalse,
        );
      }
    });

    test('applies filters and paging', () async {
      final HikeRepositoryMock repository = HikeRepositoryMock();

      final List<Hike> hard = await repository.getHikes(
        filters: const HikeFilters(
          difficulties: <String>{HikeDifficulty.hard},
        ),
        limit: 20,
        offset: 0,
      );
      final List<Hike> secondPage = await repository.getHikes(
        filters: const HikeFilters(),
        limit: 2,
        offset: 2,
      );

      expect(hard, isNotEmpty);
      expect(
        hard.every((Hike hike) => hike.difficulty == HikeDifficulty.hard),
        isTrue,
      );
      expect(secondPage.length, 2);
    });

    test('resolves a single hike and its organizer', () async {
      final HikeRepositoryMock repository = HikeRepositoryMock();

      final Hike hike = await repository.getHike(729);
      final Organizer organizer = await repository.getOrganizer(1);
      final List<Organizer> organizers = await repository.getOrganizers();

      expect(hike.title, 'Ледник Тана');
      expect(organizer.hikes, isNotEmpty);
      expect(organizers.length, 1);
    });
  });
}
