// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'organizer_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_OrganizerDto _$OrganizerDtoFromJson(Map<String, dynamic> json) =>
    _OrganizerDto(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      city: json['city'] as String?,
      hikes: (json['hikes'] as List<dynamic>?)
          ?.map((e) => HikeDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$OrganizerDtoToJson(_OrganizerDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'city': instance.city,
      'hikes': instance.hikes?.map((e) => e.toJson()).toList(),
    };
