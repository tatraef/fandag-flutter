// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hike_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_HikeDto _$HikeDtoFromJson(Map<String, dynamic> json) => _HikeDto(
  id: (json['id'] as num).toInt(),
  title: json['title'] as String,
  dateStart: DateTime.parse(json['date_start'] as String),
  sourceUrl: json['source_url'] as String,
  organizer: OrganizerDto.fromJson(json['organizer'] as Map<String, dynamic>),
  dateEnd: json['date_end'] == null
      ? null
      : DateTime.parse(json['date_end'] as String),
  price: (json['price'] as num?)?.toInt(),
  difficulty: json['difficulty'] as String?,
  distanceKm: (json['distance_km'] as num?)?.toDouble(),
  elevationGainM: (json['elevation_gain_m'] as num?)?.toInt(),
  departureTime: json['departure_time'] as String?,
  departurePlace: json['departure_place'] as String?,
  description: json['description'] as String?,
  requirements: (json['requirements'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  includes: (json['includes'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  images: (json['images'] as List<dynamic>?)?.map((e) => e as String).toList(),
  spotsLeft: (json['spots_left'] as num?)?.toInt(),
  region: json['region'] as String?,
  contactPhone: json['contact_phone'] as String?,
  contactName: json['contact_name'] as String?,
);

Map<String, dynamic> _$HikeDtoToJson(_HikeDto instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'date_start': instance.dateStart.toIso8601String(),
  'source_url': instance.sourceUrl,
  'organizer': instance.organizer.toJson(),
  'date_end': instance.dateEnd?.toIso8601String(),
  'price': instance.price,
  'difficulty': instance.difficulty,
  'distance_km': instance.distanceKm,
  'elevation_gain_m': instance.elevationGainM,
  'departure_time': instance.departureTime,
  'departure_place': instance.departurePlace,
  'description': instance.description,
  'requirements': instance.requirements,
  'includes': instance.includes,
  'images': instance.images,
  'spots_left': instance.spotsLeft,
  'region': instance.region,
  'contact_phone': instance.contactPhone,
  'contact_name': instance.contactName,
};
