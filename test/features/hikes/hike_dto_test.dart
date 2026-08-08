import 'package:fandag/features/hikes/data/models/models.dart';
import 'package:fandag/features/hikes/domain/domain.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('HikeDto.fromJson', () {
    test('parses a full hike from the API contract sample', () {
      final Map<String, dynamic> json = <String, dynamic>{
        'id': 1,
        'title': 'Гидрографские водопады',
        'date_start': '2025-06-11',
        'date_end': '2025-06-11',
        'price': 1500,
        'difficulty': 'below_medium',
        'distance_km': 6,
        'elevation_gain_m': 200,
        'departure_time': '09:00',
        'departure_place': 'ул.Кирова, 47',
        'description': 'Поход к водопадам',
        'requirements': <String>['дождевик', 'головной убор'],
        'includes': <String>['транспорт'],
        'images': <String>['https://cdn4.telesco.pe/file/abc'],
        'spots_left': null,
        'region': 'Северный Кавказ',
        'source_url': 'https://t.me/tvoyavisota/12727',
        'contact_phone': '+7 928 067 44 35',
        'contact_name': 'Марина',
        'organizer': <String, dynamic>{'id': 1, 'name': 'Твоя Высота'},
      };

      final Hike hike = HikeDto.fromJson(json).toDomain();

      expect(hike.id, 1);
      expect(hike.dateStart, DateTime(2025, 6, 11));
      expect(hike.difficulty, HikeDifficulty.belowMedium);
      expect(hike.distanceKm, 6.0); // int in JSON, double in model
      expect(hike.spotsLeft, isNull);
      expect(hike.requirements, hasLength(2));
      expect(hike.images, hasLength(1));
      expect(hike.organizer.name, 'Твоя Высота');
      expect(hike.organizer.city, isNull); // absent in /hikes
    });

    test('tolerates a sparse hike with missing optional fields', () {
      final Map<String, dynamic> json = <String, dynamic>{
        'id': 2,
        'title': 'Минимальный поход',
        'date_start': '2025-07-01',
        'source_url': 'https://t.me/x/1',
        'organizer': <String, dynamic>{'id': 3, 'name': 'Клуб'},
      };

      final Hike hike = HikeDto.fromJson(json).toDomain();

      expect(hike.dateEnd, isNull);
      expect(hike.price, isNull);
      expect(hike.difficulty, isNull);
      expect(hike.requirements, isEmpty);
      expect(hike.includes, isEmpty);
      expect(hike.images, isEmpty);
    });

    test('drops a difficulty the client does not know', () {
      final Map<String, dynamic> json = <String, dynamic>{
        'id': 3,
        'title': 'Поход с новой градацией',
        'date_start': '2025-07-01',
        'source_url': 'https://t.me/x/2',
        'organizer': <String, dynamic>{'id': 3, 'name': 'Клуб'},
        // Legacy Russian wording, or a grade added to the scale after release:
        // the badge is hidden rather than mislabelled.
        'difficulty': 'выше средней',
      };

      final Hike hike = HikeDto.fromJson(json).toDomain();

      expect(hike.difficulty, isNull);
    });
  });

  group('HikeDifficulty.tryParse', () {
    test('maps every API key and rejects anything else', () {
      expect(HikeDifficulty.tryParse('easy'), HikeDifficulty.easy);
      expect(
        HikeDifficulty.tryParse('below_medium'),
        HikeDifficulty.belowMedium,
      );
      expect(HikeDifficulty.tryParse('medium'), HikeDifficulty.medium);
      expect(
        HikeDifficulty.tryParse('above_medium'),
        HikeDifficulty.aboveMedium,
      );
      expect(HikeDifficulty.tryParse('hard'), HikeDifficulty.hard);
      expect(HikeDifficulty.tryParse('Easy'), isNull);
      expect(HikeDifficulty.tryParse(''), isNull);
      expect(HikeDifficulty.tryParse(null), isNull);
    });

    test('keeps the grades in ascending order', () {
      expect(
        HikeDifficulty.values.map((HikeDifficulty d) => d.apiValue),
        <String>['easy', 'below_medium', 'medium', 'above_medium', 'hard'],
      );
    });
  });

  test('OrganizerDto.fromJson parses nested hikes', () {
    final Map<String, dynamic> json = <String, dynamic>{
      'id': 1,
      'name': 'Твоя Высота',
      'city': 'Владикавказ',
      'hikes': <Map<String, dynamic>>[
        <String, dynamic>{
          'id': 1,
          'title': 'Поход',
          'date_start': '2025-06-11',
          'source_url': 'https://t.me/x/1',
          'organizer': <String, dynamic>{'id': 1, 'name': 'Твоя Высота'},
        },
      ],
    };

    final Organizer organizer = OrganizerDto.fromJson(json).toDomain();

    expect(organizer.city, 'Владикавказ');
    expect(organizer.hikes, hasLength(1));
    expect(organizer.hikes!.first.title, 'Поход');
  });
}
