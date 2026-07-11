import 'package:fandag/features/hikes/data/models/hike_dto.dart';
import 'package:fandag/features/hikes/domain/domain.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'organizer_dto.freezed.dart';
part 'organizer_dto.g.dart';

@freezed
abstract class OrganizerDto with _$OrganizerDto {
  const factory OrganizerDto({
    required int id,
    required String name,
    String? city,
    List<HikeDto>? hikes,
  }) = _OrganizerDto;

  const OrganizerDto._();

  factory OrganizerDto.fromJson(Map<String, dynamic> json) =>
      _$OrganizerDtoFromJson(json);

  Organizer toDomain() {
    return Organizer(
      id: id,
      name: name,
      city: city,
      hikes: hikes?.map((HikeDto dto) => dto.toDomain()).toList(),
    );
  }
}
