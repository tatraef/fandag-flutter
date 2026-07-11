import 'package:fandag/features/hikes/domain/entities/organizer.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'hike.freezed.dart';

@freezed
abstract class Hike with _$Hike {
  const factory Hike({
    required int id,
    required String title,
    required DateTime dateStart,
    required String sourceUrl,
    required Organizer organizer,
    @Default(<String>[]) List<String> requirements,
    @Default(<String>[]) List<String> includes,
    @Default(<String>[]) List<String> images,
    DateTime? dateEnd,
    int? price,
    String? difficulty,
    double? distanceKm,
    int? elevationGainM,
    String? departureTime,
    String? departurePlace,
    String? description,
    int? spotsLeft,
    String? region,
    String? contactPhone,
    String? contactName,
  }) = _Hike;
}
