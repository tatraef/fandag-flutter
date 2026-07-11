// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'hike_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$HikeDto {

 int get id; String get title; DateTime get dateStart; String get sourceUrl; OrganizerDto get organizer; DateTime? get dateEnd; int? get price; String? get difficulty; double? get distanceKm; int? get elevationGainM; String? get departureTime; String? get departurePlace; String? get description; List<String>? get requirements; List<String>? get includes; List<String>? get images; int? get spotsLeft; String? get region; String? get contactPhone; String? get contactName;
/// Create a copy of HikeDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HikeDtoCopyWith<HikeDto> get copyWith => _$HikeDtoCopyWithImpl<HikeDto>(this as HikeDto, _$identity);

  /// Serializes this HikeDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HikeDto&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.dateStart, dateStart) || other.dateStart == dateStart)&&(identical(other.sourceUrl, sourceUrl) || other.sourceUrl == sourceUrl)&&(identical(other.organizer, organizer) || other.organizer == organizer)&&(identical(other.dateEnd, dateEnd) || other.dateEnd == dateEnd)&&(identical(other.price, price) || other.price == price)&&(identical(other.difficulty, difficulty) || other.difficulty == difficulty)&&(identical(other.distanceKm, distanceKm) || other.distanceKm == distanceKm)&&(identical(other.elevationGainM, elevationGainM) || other.elevationGainM == elevationGainM)&&(identical(other.departureTime, departureTime) || other.departureTime == departureTime)&&(identical(other.departurePlace, departurePlace) || other.departurePlace == departurePlace)&&(identical(other.description, description) || other.description == description)&&const DeepCollectionEquality().equals(other.requirements, requirements)&&const DeepCollectionEquality().equals(other.includes, includes)&&const DeepCollectionEquality().equals(other.images, images)&&(identical(other.spotsLeft, spotsLeft) || other.spotsLeft == spotsLeft)&&(identical(other.region, region) || other.region == region)&&(identical(other.contactPhone, contactPhone) || other.contactPhone == contactPhone)&&(identical(other.contactName, contactName) || other.contactName == contactName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,title,dateStart,sourceUrl,organizer,dateEnd,price,difficulty,distanceKm,elevationGainM,departureTime,departurePlace,description,const DeepCollectionEquality().hash(requirements),const DeepCollectionEquality().hash(includes),const DeepCollectionEquality().hash(images),spotsLeft,region,contactPhone,contactName]);

@override
String toString() {
  return 'HikeDto(id: $id, title: $title, dateStart: $dateStart, sourceUrl: $sourceUrl, organizer: $organizer, dateEnd: $dateEnd, price: $price, difficulty: $difficulty, distanceKm: $distanceKm, elevationGainM: $elevationGainM, departureTime: $departureTime, departurePlace: $departurePlace, description: $description, requirements: $requirements, includes: $includes, images: $images, spotsLeft: $spotsLeft, region: $region, contactPhone: $contactPhone, contactName: $contactName)';
}


}

/// @nodoc
abstract mixin class $HikeDtoCopyWith<$Res>  {
  factory $HikeDtoCopyWith(HikeDto value, $Res Function(HikeDto) _then) = _$HikeDtoCopyWithImpl;
@useResult
$Res call({
 int id, String title, DateTime dateStart, String sourceUrl, OrganizerDto organizer, DateTime? dateEnd, int? price, String? difficulty, double? distanceKm, int? elevationGainM, String? departureTime, String? departurePlace, String? description, List<String>? requirements, List<String>? includes, List<String>? images, int? spotsLeft, String? region, String? contactPhone, String? contactName
});


$OrganizerDtoCopyWith<$Res> get organizer;

}
/// @nodoc
class _$HikeDtoCopyWithImpl<$Res>
    implements $HikeDtoCopyWith<$Res> {
  _$HikeDtoCopyWithImpl(this._self, this._then);

  final HikeDto _self;
  final $Res Function(HikeDto) _then;

/// Create a copy of HikeDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? dateStart = null,Object? sourceUrl = null,Object? organizer = null,Object? dateEnd = freezed,Object? price = freezed,Object? difficulty = freezed,Object? distanceKm = freezed,Object? elevationGainM = freezed,Object? departureTime = freezed,Object? departurePlace = freezed,Object? description = freezed,Object? requirements = freezed,Object? includes = freezed,Object? images = freezed,Object? spotsLeft = freezed,Object? region = freezed,Object? contactPhone = freezed,Object? contactName = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,dateStart: null == dateStart ? _self.dateStart : dateStart // ignore: cast_nullable_to_non_nullable
as DateTime,sourceUrl: null == sourceUrl ? _self.sourceUrl : sourceUrl // ignore: cast_nullable_to_non_nullable
as String,organizer: null == organizer ? _self.organizer : organizer // ignore: cast_nullable_to_non_nullable
as OrganizerDto,dateEnd: freezed == dateEnd ? _self.dateEnd : dateEnd // ignore: cast_nullable_to_non_nullable
as DateTime?,price: freezed == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as int?,difficulty: freezed == difficulty ? _self.difficulty : difficulty // ignore: cast_nullable_to_non_nullable
as String?,distanceKm: freezed == distanceKm ? _self.distanceKm : distanceKm // ignore: cast_nullable_to_non_nullable
as double?,elevationGainM: freezed == elevationGainM ? _self.elevationGainM : elevationGainM // ignore: cast_nullable_to_non_nullable
as int?,departureTime: freezed == departureTime ? _self.departureTime : departureTime // ignore: cast_nullable_to_non_nullable
as String?,departurePlace: freezed == departurePlace ? _self.departurePlace : departurePlace // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,requirements: freezed == requirements ? _self.requirements : requirements // ignore: cast_nullable_to_non_nullable
as List<String>?,includes: freezed == includes ? _self.includes : includes // ignore: cast_nullable_to_non_nullable
as List<String>?,images: freezed == images ? _self.images : images // ignore: cast_nullable_to_non_nullable
as List<String>?,spotsLeft: freezed == spotsLeft ? _self.spotsLeft : spotsLeft // ignore: cast_nullable_to_non_nullable
as int?,region: freezed == region ? _self.region : region // ignore: cast_nullable_to_non_nullable
as String?,contactPhone: freezed == contactPhone ? _self.contactPhone : contactPhone // ignore: cast_nullable_to_non_nullable
as String?,contactName: freezed == contactName ? _self.contactName : contactName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of HikeDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OrganizerDtoCopyWith<$Res> get organizer {
  
  return $OrganizerDtoCopyWith<$Res>(_self.organizer, (value) {
    return _then(_self.copyWith(organizer: value));
  });
}
}


/// Adds pattern-matching-related methods to [HikeDto].
extension HikeDtoPatterns on HikeDto {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HikeDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HikeDto() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HikeDto value)  $default,){
final _that = this;
switch (_that) {
case _HikeDto():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HikeDto value)?  $default,){
final _that = this;
switch (_that) {
case _HikeDto() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String title,  DateTime dateStart,  String sourceUrl,  OrganizerDto organizer,  DateTime? dateEnd,  int? price,  String? difficulty,  double? distanceKm,  int? elevationGainM,  String? departureTime,  String? departurePlace,  String? description,  List<String>? requirements,  List<String>? includes,  List<String>? images,  int? spotsLeft,  String? region,  String? contactPhone,  String? contactName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HikeDto() when $default != null:
return $default(_that.id,_that.title,_that.dateStart,_that.sourceUrl,_that.organizer,_that.dateEnd,_that.price,_that.difficulty,_that.distanceKm,_that.elevationGainM,_that.departureTime,_that.departurePlace,_that.description,_that.requirements,_that.includes,_that.images,_that.spotsLeft,_that.region,_that.contactPhone,_that.contactName);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String title,  DateTime dateStart,  String sourceUrl,  OrganizerDto organizer,  DateTime? dateEnd,  int? price,  String? difficulty,  double? distanceKm,  int? elevationGainM,  String? departureTime,  String? departurePlace,  String? description,  List<String>? requirements,  List<String>? includes,  List<String>? images,  int? spotsLeft,  String? region,  String? contactPhone,  String? contactName)  $default,) {final _that = this;
switch (_that) {
case _HikeDto():
return $default(_that.id,_that.title,_that.dateStart,_that.sourceUrl,_that.organizer,_that.dateEnd,_that.price,_that.difficulty,_that.distanceKm,_that.elevationGainM,_that.departureTime,_that.departurePlace,_that.description,_that.requirements,_that.includes,_that.images,_that.spotsLeft,_that.region,_that.contactPhone,_that.contactName);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String title,  DateTime dateStart,  String sourceUrl,  OrganizerDto organizer,  DateTime? dateEnd,  int? price,  String? difficulty,  double? distanceKm,  int? elevationGainM,  String? departureTime,  String? departurePlace,  String? description,  List<String>? requirements,  List<String>? includes,  List<String>? images,  int? spotsLeft,  String? region,  String? contactPhone,  String? contactName)?  $default,) {final _that = this;
switch (_that) {
case _HikeDto() when $default != null:
return $default(_that.id,_that.title,_that.dateStart,_that.sourceUrl,_that.organizer,_that.dateEnd,_that.price,_that.difficulty,_that.distanceKm,_that.elevationGainM,_that.departureTime,_that.departurePlace,_that.description,_that.requirements,_that.includes,_that.images,_that.spotsLeft,_that.region,_that.contactPhone,_that.contactName);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HikeDto extends HikeDto {
  const _HikeDto({required this.id, required this.title, required this.dateStart, required this.sourceUrl, required this.organizer, this.dateEnd, this.price, this.difficulty, this.distanceKm, this.elevationGainM, this.departureTime, this.departurePlace, this.description, final  List<String>? requirements, final  List<String>? includes, final  List<String>? images, this.spotsLeft, this.region, this.contactPhone, this.contactName}): _requirements = requirements,_includes = includes,_images = images,super._();
  factory _HikeDto.fromJson(Map<String, dynamic> json) => _$HikeDtoFromJson(json);

@override final  int id;
@override final  String title;
@override final  DateTime dateStart;
@override final  String sourceUrl;
@override final  OrganizerDto organizer;
@override final  DateTime? dateEnd;
@override final  int? price;
@override final  String? difficulty;
@override final  double? distanceKm;
@override final  int? elevationGainM;
@override final  String? departureTime;
@override final  String? departurePlace;
@override final  String? description;
 final  List<String>? _requirements;
@override List<String>? get requirements {
  final value = _requirements;
  if (value == null) return null;
  if (_requirements is EqualUnmodifiableListView) return _requirements;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<String>? _includes;
@override List<String>? get includes {
  final value = _includes;
  if (value == null) return null;
  if (_includes is EqualUnmodifiableListView) return _includes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<String>? _images;
@override List<String>? get images {
  final value = _images;
  if (value == null) return null;
  if (_images is EqualUnmodifiableListView) return _images;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override final  int? spotsLeft;
@override final  String? region;
@override final  String? contactPhone;
@override final  String? contactName;

/// Create a copy of HikeDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HikeDtoCopyWith<_HikeDto> get copyWith => __$HikeDtoCopyWithImpl<_HikeDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HikeDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HikeDto&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.dateStart, dateStart) || other.dateStart == dateStart)&&(identical(other.sourceUrl, sourceUrl) || other.sourceUrl == sourceUrl)&&(identical(other.organizer, organizer) || other.organizer == organizer)&&(identical(other.dateEnd, dateEnd) || other.dateEnd == dateEnd)&&(identical(other.price, price) || other.price == price)&&(identical(other.difficulty, difficulty) || other.difficulty == difficulty)&&(identical(other.distanceKm, distanceKm) || other.distanceKm == distanceKm)&&(identical(other.elevationGainM, elevationGainM) || other.elevationGainM == elevationGainM)&&(identical(other.departureTime, departureTime) || other.departureTime == departureTime)&&(identical(other.departurePlace, departurePlace) || other.departurePlace == departurePlace)&&(identical(other.description, description) || other.description == description)&&const DeepCollectionEquality().equals(other._requirements, _requirements)&&const DeepCollectionEquality().equals(other._includes, _includes)&&const DeepCollectionEquality().equals(other._images, _images)&&(identical(other.spotsLeft, spotsLeft) || other.spotsLeft == spotsLeft)&&(identical(other.region, region) || other.region == region)&&(identical(other.contactPhone, contactPhone) || other.contactPhone == contactPhone)&&(identical(other.contactName, contactName) || other.contactName == contactName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,title,dateStart,sourceUrl,organizer,dateEnd,price,difficulty,distanceKm,elevationGainM,departureTime,departurePlace,description,const DeepCollectionEquality().hash(_requirements),const DeepCollectionEquality().hash(_includes),const DeepCollectionEquality().hash(_images),spotsLeft,region,contactPhone,contactName]);

@override
String toString() {
  return 'HikeDto(id: $id, title: $title, dateStart: $dateStart, sourceUrl: $sourceUrl, organizer: $organizer, dateEnd: $dateEnd, price: $price, difficulty: $difficulty, distanceKm: $distanceKm, elevationGainM: $elevationGainM, departureTime: $departureTime, departurePlace: $departurePlace, description: $description, requirements: $requirements, includes: $includes, images: $images, spotsLeft: $spotsLeft, region: $region, contactPhone: $contactPhone, contactName: $contactName)';
}


}

/// @nodoc
abstract mixin class _$HikeDtoCopyWith<$Res> implements $HikeDtoCopyWith<$Res> {
  factory _$HikeDtoCopyWith(_HikeDto value, $Res Function(_HikeDto) _then) = __$HikeDtoCopyWithImpl;
@override @useResult
$Res call({
 int id, String title, DateTime dateStart, String sourceUrl, OrganizerDto organizer, DateTime? dateEnd, int? price, String? difficulty, double? distanceKm, int? elevationGainM, String? departureTime, String? departurePlace, String? description, List<String>? requirements, List<String>? includes, List<String>? images, int? spotsLeft, String? region, String? contactPhone, String? contactName
});


@override $OrganizerDtoCopyWith<$Res> get organizer;

}
/// @nodoc
class __$HikeDtoCopyWithImpl<$Res>
    implements _$HikeDtoCopyWith<$Res> {
  __$HikeDtoCopyWithImpl(this._self, this._then);

  final _HikeDto _self;
  final $Res Function(_HikeDto) _then;

/// Create a copy of HikeDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? dateStart = null,Object? sourceUrl = null,Object? organizer = null,Object? dateEnd = freezed,Object? price = freezed,Object? difficulty = freezed,Object? distanceKm = freezed,Object? elevationGainM = freezed,Object? departureTime = freezed,Object? departurePlace = freezed,Object? description = freezed,Object? requirements = freezed,Object? includes = freezed,Object? images = freezed,Object? spotsLeft = freezed,Object? region = freezed,Object? contactPhone = freezed,Object? contactName = freezed,}) {
  return _then(_HikeDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,dateStart: null == dateStart ? _self.dateStart : dateStart // ignore: cast_nullable_to_non_nullable
as DateTime,sourceUrl: null == sourceUrl ? _self.sourceUrl : sourceUrl // ignore: cast_nullable_to_non_nullable
as String,organizer: null == organizer ? _self.organizer : organizer // ignore: cast_nullable_to_non_nullable
as OrganizerDto,dateEnd: freezed == dateEnd ? _self.dateEnd : dateEnd // ignore: cast_nullable_to_non_nullable
as DateTime?,price: freezed == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as int?,difficulty: freezed == difficulty ? _self.difficulty : difficulty // ignore: cast_nullable_to_non_nullable
as String?,distanceKm: freezed == distanceKm ? _self.distanceKm : distanceKm // ignore: cast_nullable_to_non_nullable
as double?,elevationGainM: freezed == elevationGainM ? _self.elevationGainM : elevationGainM // ignore: cast_nullable_to_non_nullable
as int?,departureTime: freezed == departureTime ? _self.departureTime : departureTime // ignore: cast_nullable_to_non_nullable
as String?,departurePlace: freezed == departurePlace ? _self.departurePlace : departurePlace // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,requirements: freezed == requirements ? _self._requirements : requirements // ignore: cast_nullable_to_non_nullable
as List<String>?,includes: freezed == includes ? _self._includes : includes // ignore: cast_nullable_to_non_nullable
as List<String>?,images: freezed == images ? _self._images : images // ignore: cast_nullable_to_non_nullable
as List<String>?,spotsLeft: freezed == spotsLeft ? _self.spotsLeft : spotsLeft // ignore: cast_nullable_to_non_nullable
as int?,region: freezed == region ? _self.region : region // ignore: cast_nullable_to_non_nullable
as String?,contactPhone: freezed == contactPhone ? _self.contactPhone : contactPhone // ignore: cast_nullable_to_non_nullable
as String?,contactName: freezed == contactName ? _self.contactName : contactName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of HikeDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OrganizerDtoCopyWith<$Res> get organizer {
  
  return $OrganizerDtoCopyWith<$Res>(_self.organizer, (value) {
    return _then(_self.copyWith(organizer: value));
  });
}
}

// dart format on
