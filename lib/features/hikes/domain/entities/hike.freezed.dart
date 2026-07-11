// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'hike.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Hike {

 int get id; String get title; DateTime get dateStart; String get sourceUrl; Organizer get organizer; List<String> get requirements; List<String> get includes; List<String> get images; DateTime? get dateEnd; int? get price; String? get difficulty; double? get distanceKm; int? get elevationGainM; String? get departureTime; String? get departurePlace; String? get description; int? get spotsLeft; String? get region; String? get contactPhone; String? get contactName;
/// Create a copy of Hike
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HikeCopyWith<Hike> get copyWith => _$HikeCopyWithImpl<Hike>(this as Hike, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Hike&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.dateStart, dateStart) || other.dateStart == dateStart)&&(identical(other.sourceUrl, sourceUrl) || other.sourceUrl == sourceUrl)&&(identical(other.organizer, organizer) || other.organizer == organizer)&&const DeepCollectionEquality().equals(other.requirements, requirements)&&const DeepCollectionEquality().equals(other.includes, includes)&&const DeepCollectionEquality().equals(other.images, images)&&(identical(other.dateEnd, dateEnd) || other.dateEnd == dateEnd)&&(identical(other.price, price) || other.price == price)&&(identical(other.difficulty, difficulty) || other.difficulty == difficulty)&&(identical(other.distanceKm, distanceKm) || other.distanceKm == distanceKm)&&(identical(other.elevationGainM, elevationGainM) || other.elevationGainM == elevationGainM)&&(identical(other.departureTime, departureTime) || other.departureTime == departureTime)&&(identical(other.departurePlace, departurePlace) || other.departurePlace == departurePlace)&&(identical(other.description, description) || other.description == description)&&(identical(other.spotsLeft, spotsLeft) || other.spotsLeft == spotsLeft)&&(identical(other.region, region) || other.region == region)&&(identical(other.contactPhone, contactPhone) || other.contactPhone == contactPhone)&&(identical(other.contactName, contactName) || other.contactName == contactName));
}


@override
int get hashCode => Object.hashAll([runtimeType,id,title,dateStart,sourceUrl,organizer,const DeepCollectionEquality().hash(requirements),const DeepCollectionEquality().hash(includes),const DeepCollectionEquality().hash(images),dateEnd,price,difficulty,distanceKm,elevationGainM,departureTime,departurePlace,description,spotsLeft,region,contactPhone,contactName]);

@override
String toString() {
  return 'Hike(id: $id, title: $title, dateStart: $dateStart, sourceUrl: $sourceUrl, organizer: $organizer, requirements: $requirements, includes: $includes, images: $images, dateEnd: $dateEnd, price: $price, difficulty: $difficulty, distanceKm: $distanceKm, elevationGainM: $elevationGainM, departureTime: $departureTime, departurePlace: $departurePlace, description: $description, spotsLeft: $spotsLeft, region: $region, contactPhone: $contactPhone, contactName: $contactName)';
}


}

/// @nodoc
abstract mixin class $HikeCopyWith<$Res>  {
  factory $HikeCopyWith(Hike value, $Res Function(Hike) _then) = _$HikeCopyWithImpl;
@useResult
$Res call({
 int id, String title, DateTime dateStart, String sourceUrl, Organizer organizer, List<String> requirements, List<String> includes, List<String> images, DateTime? dateEnd, int? price, String? difficulty, double? distanceKm, int? elevationGainM, String? departureTime, String? departurePlace, String? description, int? spotsLeft, String? region, String? contactPhone, String? contactName
});


$OrganizerCopyWith<$Res> get organizer;

}
/// @nodoc
class _$HikeCopyWithImpl<$Res>
    implements $HikeCopyWith<$Res> {
  _$HikeCopyWithImpl(this._self, this._then);

  final Hike _self;
  final $Res Function(Hike) _then;

/// Create a copy of Hike
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? dateStart = null,Object? sourceUrl = null,Object? organizer = null,Object? requirements = null,Object? includes = null,Object? images = null,Object? dateEnd = freezed,Object? price = freezed,Object? difficulty = freezed,Object? distanceKm = freezed,Object? elevationGainM = freezed,Object? departureTime = freezed,Object? departurePlace = freezed,Object? description = freezed,Object? spotsLeft = freezed,Object? region = freezed,Object? contactPhone = freezed,Object? contactName = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,dateStart: null == dateStart ? _self.dateStart : dateStart // ignore: cast_nullable_to_non_nullable
as DateTime,sourceUrl: null == sourceUrl ? _self.sourceUrl : sourceUrl // ignore: cast_nullable_to_non_nullable
as String,organizer: null == organizer ? _self.organizer : organizer // ignore: cast_nullable_to_non_nullable
as Organizer,requirements: null == requirements ? _self.requirements : requirements // ignore: cast_nullable_to_non_nullable
as List<String>,includes: null == includes ? _self.includes : includes // ignore: cast_nullable_to_non_nullable
as List<String>,images: null == images ? _self.images : images // ignore: cast_nullable_to_non_nullable
as List<String>,dateEnd: freezed == dateEnd ? _self.dateEnd : dateEnd // ignore: cast_nullable_to_non_nullable
as DateTime?,price: freezed == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as int?,difficulty: freezed == difficulty ? _self.difficulty : difficulty // ignore: cast_nullable_to_non_nullable
as String?,distanceKm: freezed == distanceKm ? _self.distanceKm : distanceKm // ignore: cast_nullable_to_non_nullable
as double?,elevationGainM: freezed == elevationGainM ? _self.elevationGainM : elevationGainM // ignore: cast_nullable_to_non_nullable
as int?,departureTime: freezed == departureTime ? _self.departureTime : departureTime // ignore: cast_nullable_to_non_nullable
as String?,departurePlace: freezed == departurePlace ? _self.departurePlace : departurePlace // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,spotsLeft: freezed == spotsLeft ? _self.spotsLeft : spotsLeft // ignore: cast_nullable_to_non_nullable
as int?,region: freezed == region ? _self.region : region // ignore: cast_nullable_to_non_nullable
as String?,contactPhone: freezed == contactPhone ? _self.contactPhone : contactPhone // ignore: cast_nullable_to_non_nullable
as String?,contactName: freezed == contactName ? _self.contactName : contactName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of Hike
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OrganizerCopyWith<$Res> get organizer {
  
  return $OrganizerCopyWith<$Res>(_self.organizer, (value) {
    return _then(_self.copyWith(organizer: value));
  });
}
}


/// Adds pattern-matching-related methods to [Hike].
extension HikePatterns on Hike {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Hike value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Hike() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Hike value)  $default,){
final _that = this;
switch (_that) {
case _Hike():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Hike value)?  $default,){
final _that = this;
switch (_that) {
case _Hike() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String title,  DateTime dateStart,  String sourceUrl,  Organizer organizer,  List<String> requirements,  List<String> includes,  List<String> images,  DateTime? dateEnd,  int? price,  String? difficulty,  double? distanceKm,  int? elevationGainM,  String? departureTime,  String? departurePlace,  String? description,  int? spotsLeft,  String? region,  String? contactPhone,  String? contactName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Hike() when $default != null:
return $default(_that.id,_that.title,_that.dateStart,_that.sourceUrl,_that.organizer,_that.requirements,_that.includes,_that.images,_that.dateEnd,_that.price,_that.difficulty,_that.distanceKm,_that.elevationGainM,_that.departureTime,_that.departurePlace,_that.description,_that.spotsLeft,_that.region,_that.contactPhone,_that.contactName);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String title,  DateTime dateStart,  String sourceUrl,  Organizer organizer,  List<String> requirements,  List<String> includes,  List<String> images,  DateTime? dateEnd,  int? price,  String? difficulty,  double? distanceKm,  int? elevationGainM,  String? departureTime,  String? departurePlace,  String? description,  int? spotsLeft,  String? region,  String? contactPhone,  String? contactName)  $default,) {final _that = this;
switch (_that) {
case _Hike():
return $default(_that.id,_that.title,_that.dateStart,_that.sourceUrl,_that.organizer,_that.requirements,_that.includes,_that.images,_that.dateEnd,_that.price,_that.difficulty,_that.distanceKm,_that.elevationGainM,_that.departureTime,_that.departurePlace,_that.description,_that.spotsLeft,_that.region,_that.contactPhone,_that.contactName);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String title,  DateTime dateStart,  String sourceUrl,  Organizer organizer,  List<String> requirements,  List<String> includes,  List<String> images,  DateTime? dateEnd,  int? price,  String? difficulty,  double? distanceKm,  int? elevationGainM,  String? departureTime,  String? departurePlace,  String? description,  int? spotsLeft,  String? region,  String? contactPhone,  String? contactName)?  $default,) {final _that = this;
switch (_that) {
case _Hike() when $default != null:
return $default(_that.id,_that.title,_that.dateStart,_that.sourceUrl,_that.organizer,_that.requirements,_that.includes,_that.images,_that.dateEnd,_that.price,_that.difficulty,_that.distanceKm,_that.elevationGainM,_that.departureTime,_that.departurePlace,_that.description,_that.spotsLeft,_that.region,_that.contactPhone,_that.contactName);case _:
  return null;

}
}

}

/// @nodoc


class _Hike implements Hike {
  const _Hike({required this.id, required this.title, required this.dateStart, required this.sourceUrl, required this.organizer, final  List<String> requirements = const <String>[], final  List<String> includes = const <String>[], final  List<String> images = const <String>[], this.dateEnd, this.price, this.difficulty, this.distanceKm, this.elevationGainM, this.departureTime, this.departurePlace, this.description, this.spotsLeft, this.region, this.contactPhone, this.contactName}): _requirements = requirements,_includes = includes,_images = images;
  

@override final  int id;
@override final  String title;
@override final  DateTime dateStart;
@override final  String sourceUrl;
@override final  Organizer organizer;
 final  List<String> _requirements;
@override@JsonKey() List<String> get requirements {
  if (_requirements is EqualUnmodifiableListView) return _requirements;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_requirements);
}

 final  List<String> _includes;
@override@JsonKey() List<String> get includes {
  if (_includes is EqualUnmodifiableListView) return _includes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_includes);
}

 final  List<String> _images;
@override@JsonKey() List<String> get images {
  if (_images is EqualUnmodifiableListView) return _images;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_images);
}

@override final  DateTime? dateEnd;
@override final  int? price;
@override final  String? difficulty;
@override final  double? distanceKm;
@override final  int? elevationGainM;
@override final  String? departureTime;
@override final  String? departurePlace;
@override final  String? description;
@override final  int? spotsLeft;
@override final  String? region;
@override final  String? contactPhone;
@override final  String? contactName;

/// Create a copy of Hike
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HikeCopyWith<_Hike> get copyWith => __$HikeCopyWithImpl<_Hike>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Hike&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.dateStart, dateStart) || other.dateStart == dateStart)&&(identical(other.sourceUrl, sourceUrl) || other.sourceUrl == sourceUrl)&&(identical(other.organizer, organizer) || other.organizer == organizer)&&const DeepCollectionEquality().equals(other._requirements, _requirements)&&const DeepCollectionEquality().equals(other._includes, _includes)&&const DeepCollectionEquality().equals(other._images, _images)&&(identical(other.dateEnd, dateEnd) || other.dateEnd == dateEnd)&&(identical(other.price, price) || other.price == price)&&(identical(other.difficulty, difficulty) || other.difficulty == difficulty)&&(identical(other.distanceKm, distanceKm) || other.distanceKm == distanceKm)&&(identical(other.elevationGainM, elevationGainM) || other.elevationGainM == elevationGainM)&&(identical(other.departureTime, departureTime) || other.departureTime == departureTime)&&(identical(other.departurePlace, departurePlace) || other.departurePlace == departurePlace)&&(identical(other.description, description) || other.description == description)&&(identical(other.spotsLeft, spotsLeft) || other.spotsLeft == spotsLeft)&&(identical(other.region, region) || other.region == region)&&(identical(other.contactPhone, contactPhone) || other.contactPhone == contactPhone)&&(identical(other.contactName, contactName) || other.contactName == contactName));
}


@override
int get hashCode => Object.hashAll([runtimeType,id,title,dateStart,sourceUrl,organizer,const DeepCollectionEquality().hash(_requirements),const DeepCollectionEquality().hash(_includes),const DeepCollectionEquality().hash(_images),dateEnd,price,difficulty,distanceKm,elevationGainM,departureTime,departurePlace,description,spotsLeft,region,contactPhone,contactName]);

@override
String toString() {
  return 'Hike(id: $id, title: $title, dateStart: $dateStart, sourceUrl: $sourceUrl, organizer: $organizer, requirements: $requirements, includes: $includes, images: $images, dateEnd: $dateEnd, price: $price, difficulty: $difficulty, distanceKm: $distanceKm, elevationGainM: $elevationGainM, departureTime: $departureTime, departurePlace: $departurePlace, description: $description, spotsLeft: $spotsLeft, region: $region, contactPhone: $contactPhone, contactName: $contactName)';
}


}

/// @nodoc
abstract mixin class _$HikeCopyWith<$Res> implements $HikeCopyWith<$Res> {
  factory _$HikeCopyWith(_Hike value, $Res Function(_Hike) _then) = __$HikeCopyWithImpl;
@override @useResult
$Res call({
 int id, String title, DateTime dateStart, String sourceUrl, Organizer organizer, List<String> requirements, List<String> includes, List<String> images, DateTime? dateEnd, int? price, String? difficulty, double? distanceKm, int? elevationGainM, String? departureTime, String? departurePlace, String? description, int? spotsLeft, String? region, String? contactPhone, String? contactName
});


@override $OrganizerCopyWith<$Res> get organizer;

}
/// @nodoc
class __$HikeCopyWithImpl<$Res>
    implements _$HikeCopyWith<$Res> {
  __$HikeCopyWithImpl(this._self, this._then);

  final _Hike _self;
  final $Res Function(_Hike) _then;

/// Create a copy of Hike
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? dateStart = null,Object? sourceUrl = null,Object? organizer = null,Object? requirements = null,Object? includes = null,Object? images = null,Object? dateEnd = freezed,Object? price = freezed,Object? difficulty = freezed,Object? distanceKm = freezed,Object? elevationGainM = freezed,Object? departureTime = freezed,Object? departurePlace = freezed,Object? description = freezed,Object? spotsLeft = freezed,Object? region = freezed,Object? contactPhone = freezed,Object? contactName = freezed,}) {
  return _then(_Hike(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,dateStart: null == dateStart ? _self.dateStart : dateStart // ignore: cast_nullable_to_non_nullable
as DateTime,sourceUrl: null == sourceUrl ? _self.sourceUrl : sourceUrl // ignore: cast_nullable_to_non_nullable
as String,organizer: null == organizer ? _self.organizer : organizer // ignore: cast_nullable_to_non_nullable
as Organizer,requirements: null == requirements ? _self._requirements : requirements // ignore: cast_nullable_to_non_nullable
as List<String>,includes: null == includes ? _self._includes : includes // ignore: cast_nullable_to_non_nullable
as List<String>,images: null == images ? _self._images : images // ignore: cast_nullable_to_non_nullable
as List<String>,dateEnd: freezed == dateEnd ? _self.dateEnd : dateEnd // ignore: cast_nullable_to_non_nullable
as DateTime?,price: freezed == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as int?,difficulty: freezed == difficulty ? _self.difficulty : difficulty // ignore: cast_nullable_to_non_nullable
as String?,distanceKm: freezed == distanceKm ? _self.distanceKm : distanceKm // ignore: cast_nullable_to_non_nullable
as double?,elevationGainM: freezed == elevationGainM ? _self.elevationGainM : elevationGainM // ignore: cast_nullable_to_non_nullable
as int?,departureTime: freezed == departureTime ? _self.departureTime : departureTime // ignore: cast_nullable_to_non_nullable
as String?,departurePlace: freezed == departurePlace ? _self.departurePlace : departurePlace // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,spotsLeft: freezed == spotsLeft ? _self.spotsLeft : spotsLeft // ignore: cast_nullable_to_non_nullable
as int?,region: freezed == region ? _self.region : region // ignore: cast_nullable_to_non_nullable
as String?,contactPhone: freezed == contactPhone ? _self.contactPhone : contactPhone // ignore: cast_nullable_to_non_nullable
as String?,contactName: freezed == contactName ? _self.contactName : contactName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of Hike
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OrganizerCopyWith<$Res> get organizer {
  
  return $OrganizerCopyWith<$Res>(_self.organizer, (value) {
    return _then(_self.copyWith(organizer: value));
  });
}
}

// dart format on
