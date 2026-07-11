// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'organizer_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$OrganizerDto {

 int get id; String get name; String? get city; List<HikeDto>? get hikes;
/// Create a copy of OrganizerDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrganizerDtoCopyWith<OrganizerDto> get copyWith => _$OrganizerDtoCopyWithImpl<OrganizerDto>(this as OrganizerDto, _$identity);

  /// Serializes this OrganizerDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrganizerDto&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.city, city) || other.city == city)&&const DeepCollectionEquality().equals(other.hikes, hikes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,city,const DeepCollectionEquality().hash(hikes));

@override
String toString() {
  return 'OrganizerDto(id: $id, name: $name, city: $city, hikes: $hikes)';
}


}

/// @nodoc
abstract mixin class $OrganizerDtoCopyWith<$Res>  {
  factory $OrganizerDtoCopyWith(OrganizerDto value, $Res Function(OrganizerDto) _then) = _$OrganizerDtoCopyWithImpl;
@useResult
$Res call({
 int id, String name, String? city, List<HikeDto>? hikes
});




}
/// @nodoc
class _$OrganizerDtoCopyWithImpl<$Res>
    implements $OrganizerDtoCopyWith<$Res> {
  _$OrganizerDtoCopyWithImpl(this._self, this._then);

  final OrganizerDto _self;
  final $Res Function(OrganizerDto) _then;

/// Create a copy of OrganizerDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? city = freezed,Object? hikes = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,city: freezed == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String?,hikes: freezed == hikes ? _self.hikes : hikes // ignore: cast_nullable_to_non_nullable
as List<HikeDto>?,
  ));
}

}


/// Adds pattern-matching-related methods to [OrganizerDto].
extension OrganizerDtoPatterns on OrganizerDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OrganizerDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OrganizerDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OrganizerDto value)  $default,){
final _that = this;
switch (_that) {
case _OrganizerDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OrganizerDto value)?  $default,){
final _that = this;
switch (_that) {
case _OrganizerDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  String? city,  List<HikeDto>? hikes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OrganizerDto() when $default != null:
return $default(_that.id,_that.name,_that.city,_that.hikes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  String? city,  List<HikeDto>? hikes)  $default,) {final _that = this;
switch (_that) {
case _OrganizerDto():
return $default(_that.id,_that.name,_that.city,_that.hikes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  String? city,  List<HikeDto>? hikes)?  $default,) {final _that = this;
switch (_that) {
case _OrganizerDto() when $default != null:
return $default(_that.id,_that.name,_that.city,_that.hikes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OrganizerDto extends OrganizerDto {
  const _OrganizerDto({required this.id, required this.name, this.city, final  List<HikeDto>? hikes}): _hikes = hikes,super._();
  factory _OrganizerDto.fromJson(Map<String, dynamic> json) => _$OrganizerDtoFromJson(json);

@override final  int id;
@override final  String name;
@override final  String? city;
 final  List<HikeDto>? _hikes;
@override List<HikeDto>? get hikes {
  final value = _hikes;
  if (value == null) return null;
  if (_hikes is EqualUnmodifiableListView) return _hikes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of OrganizerDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OrganizerDtoCopyWith<_OrganizerDto> get copyWith => __$OrganizerDtoCopyWithImpl<_OrganizerDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OrganizerDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OrganizerDto&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.city, city) || other.city == city)&&const DeepCollectionEquality().equals(other._hikes, _hikes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,city,const DeepCollectionEquality().hash(_hikes));

@override
String toString() {
  return 'OrganizerDto(id: $id, name: $name, city: $city, hikes: $hikes)';
}


}

/// @nodoc
abstract mixin class _$OrganizerDtoCopyWith<$Res> implements $OrganizerDtoCopyWith<$Res> {
  factory _$OrganizerDtoCopyWith(_OrganizerDto value, $Res Function(_OrganizerDto) _then) = __$OrganizerDtoCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, String? city, List<HikeDto>? hikes
});




}
/// @nodoc
class __$OrganizerDtoCopyWithImpl<$Res>
    implements _$OrganizerDtoCopyWith<$Res> {
  __$OrganizerDtoCopyWithImpl(this._self, this._then);

  final _OrganizerDto _self;
  final $Res Function(_OrganizerDto) _then;

/// Create a copy of OrganizerDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? city = freezed,Object? hikes = freezed,}) {
  return _then(_OrganizerDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,city: freezed == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String?,hikes: freezed == hikes ? _self._hikes : hikes // ignore: cast_nullable_to_non_nullable
as List<HikeDto>?,
  ));
}


}

// dart format on
