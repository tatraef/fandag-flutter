import 'package:fandag/features/hikes/data/models/organizer_dto.dart';
import 'package:fandag/features/hikes/domain/domain.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'hike_dto.freezed.dart';
part 'hike_dto.g.dart';

@freezed
abstract class HikeDto with _$HikeDto {
  const factory HikeDto({
    required int id,
    required String title,
    required DateTime dateStart,
    required String sourceUrl,
    required OrganizerDto organizer,
    DateTime? dateEnd,
    int? price,
    String? difficulty,
    double? distanceKm,
    int? elevationGainM,
    String? departureTime,
    String? departurePlace,
    String? description,
    List<String>? requirements,
    List<String>? includes,
    List<String>? images,
    int? spotsLeft,
    String? region,
    String? contactPhone,
    String? contactName,
  }) = _HikeDto;

  const HikeDto._();

  factory HikeDto.fromJson(Map<String, dynamic> json) =>
      _$HikeDtoFromJson(json);

  Hike toDomain() {
    return Hike(
      id: id,
      title: title,
      dateStart: dateStart,
      sourceUrl: sourceUrl,
      organizer: organizer.toDomain(),
      dateEnd: dateEnd,
      price: price,
      difficulty: difficulty,
      distanceKm: distanceKm,
      elevationGainM: elevationGainM,
      departureTime: departureTime,
      departurePlace: departurePlace,
      description: description,
      requirements: requirements ?? const <String>[],
      includes: includes ?? const <String>[],
      images: images ?? const <String>[],
      spotsLeft: spotsLeft,
      region: region,
      contactPhone: contactPhone,
      contactName: contactName,
    );
  }
}
