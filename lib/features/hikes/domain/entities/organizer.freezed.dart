// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'organizer.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Organizer {

 int get id; String get name; String? get city; List<Hike>? get hikes;
/// Create a copy of Organizer
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrganizerCopyWith<Organizer> get copyWith => _$OrganizerCopyWithImpl<Organizer>(this as Organizer, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Organizer&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.city, city) || other.city == city)&&const DeepCollectionEquality().equals(other.hikes, hikes));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,city,const DeepCollectionEquality().hash(hikes));

@override
String toString() {
  return 'Organizer(id: $id, name: $name, city: $city, hikes: $hikes)';
}


}

/// @nodoc
abstract mixin class $OrganizerCopyWith<$Res>  {
  factory $OrganizerCopyWith(Organizer value, $Res Function(Organizer) _then) = _$OrganizerCopyWithImpl;
@useResult
$Res call({
 int id, String name, String? city, List<Hike>? hikes
});




}
/// @nodoc
class _$OrganizerCopyWithImpl<$Res>
    implements $OrganizerCopyWith<$Res> {
  _$OrganizerCopyWithImpl(this._self, this._then);

  final Organizer _self;
  final $Res Function(Organizer) _then;

/// Create a copy of Organizer
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? city = freezed,Object? hikes = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,city: freezed == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String?,hikes: freezed == hikes ? _self.hikes : hikes // ignore: cast_nullable_to_non_nullable
as List<Hike>?,
  ));
}

}


/// Adds pattern-matching-related methods to [Organizer].
extension OrganizerPatterns on Organizer {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Organizer value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Organizer() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Organizer value)  $default,){
final _that = this;
switch (_that) {
case _Organizer():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Organizer value)?  $default,){
final _that = this;
switch (_that) {
case _Organizer() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  String? city,  List<Hike>? hikes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Organizer() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  String? city,  List<Hike>? hikes)  $default,) {final _that = this;
switch (_that) {
case _Organizer():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  String? city,  List<Hike>? hikes)?  $default,) {final _that = this;
switch (_that) {
case _Organizer() when $default != null:
return $default(_that.id,_that.name,_that.city,_that.hikes);case _:
  return null;

}
}

}

/// @nodoc


class _Organizer implements Organizer {
  const _Organizer({required this.id, required this.name, this.city, final  List<Hike>? hikes}): _hikes = hikes;
  

@override final  int id;
@override final  String name;
@override final  String? city;
 final  List<Hike>? _hikes;
@override List<Hike>? get hikes {
  final value = _hikes;
  if (value == null) return null;
  if (_hikes is EqualUnmodifiableListView) return _hikes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of Organizer
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OrganizerCopyWith<_Organizer> get copyWith => __$OrganizerCopyWithImpl<_Organizer>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Organizer&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.city, city) || other.city == city)&&const DeepCollectionEquality().equals(other._hikes, _hikes));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,city,const DeepCollectionEquality().hash(_hikes));

@override
String toString() {
  return 'Organizer(id: $id, name: $name, city: $city, hikes: $hikes)';
}


}

/// @nodoc
abstract mixin class _$OrganizerCopyWith<$Res> implements $OrganizerCopyWith<$Res> {
  factory _$OrganizerCopyWith(_Organizer value, $Res Function(_Organizer) _then) = __$OrganizerCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, String? city, List<Hike>? hikes
});




}
/// @nodoc
class __$OrganizerCopyWithImpl<$Res>
    implements _$OrganizerCopyWith<$Res> {
  __$OrganizerCopyWithImpl(this._self, this._then);

  final _Organizer _self;
  final $Res Function(_Organizer) _then;

/// Create a copy of Organizer
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? city = freezed,Object? hikes = freezed,}) {
  return _then(_Organizer(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,city: freezed == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String?,hikes: freezed == hikes ? _self._hikes : hikes // ignore: cast_nullable_to_non_nullable
as List<Hike>?,
  ));
}


}

// dart format on
