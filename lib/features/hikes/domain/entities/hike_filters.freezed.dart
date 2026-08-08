// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'hike_filters.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$HikeFilters {

 DateTime? get dateFrom; DateTime? get dateTo; Set<HikeDifficulty> get difficulties; int? get priceMax; String? get region; int? get organizerId;
/// Create a copy of HikeFilters
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HikeFiltersCopyWith<HikeFilters> get copyWith => _$HikeFiltersCopyWithImpl<HikeFilters>(this as HikeFilters, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HikeFilters&&(identical(other.dateFrom, dateFrom) || other.dateFrom == dateFrom)&&(identical(other.dateTo, dateTo) || other.dateTo == dateTo)&&const DeepCollectionEquality().equals(other.difficulties, difficulties)&&(identical(other.priceMax, priceMax) || other.priceMax == priceMax)&&(identical(other.region, region) || other.region == region)&&(identical(other.organizerId, organizerId) || other.organizerId == organizerId));
}


@override
int get hashCode => Object.hash(runtimeType,dateFrom,dateTo,const DeepCollectionEquality().hash(difficulties),priceMax,region,organizerId);

@override
String toString() {
  return 'HikeFilters(dateFrom: $dateFrom, dateTo: $dateTo, difficulties: $difficulties, priceMax: $priceMax, region: $region, organizerId: $organizerId)';
}


}

/// @nodoc
abstract mixin class $HikeFiltersCopyWith<$Res>  {
  factory $HikeFiltersCopyWith(HikeFilters value, $Res Function(HikeFilters) _then) = _$HikeFiltersCopyWithImpl;
@useResult
$Res call({
 DateTime? dateFrom, DateTime? dateTo, Set<HikeDifficulty> difficulties, int? priceMax, String? region, int? organizerId
});




}
/// @nodoc
class _$HikeFiltersCopyWithImpl<$Res>
    implements $HikeFiltersCopyWith<$Res> {
  _$HikeFiltersCopyWithImpl(this._self, this._then);

  final HikeFilters _self;
  final $Res Function(HikeFilters) _then;

/// Create a copy of HikeFilters
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? dateFrom = freezed,Object? dateTo = freezed,Object? difficulties = null,Object? priceMax = freezed,Object? region = freezed,Object? organizerId = freezed,}) {
  return _then(_self.copyWith(
dateFrom: freezed == dateFrom ? _self.dateFrom : dateFrom // ignore: cast_nullable_to_non_nullable
as DateTime?,dateTo: freezed == dateTo ? _self.dateTo : dateTo // ignore: cast_nullable_to_non_nullable
as DateTime?,difficulties: null == difficulties ? _self.difficulties : difficulties // ignore: cast_nullable_to_non_nullable
as Set<HikeDifficulty>,priceMax: freezed == priceMax ? _self.priceMax : priceMax // ignore: cast_nullable_to_non_nullable
as int?,region: freezed == region ? _self.region : region // ignore: cast_nullable_to_non_nullable
as String?,organizerId: freezed == organizerId ? _self.organizerId : organizerId // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [HikeFilters].
extension HikeFiltersPatterns on HikeFilters {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HikeFilters value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HikeFilters() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HikeFilters value)  $default,){
final _that = this;
switch (_that) {
case _HikeFilters():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HikeFilters value)?  $default,){
final _that = this;
switch (_that) {
case _HikeFilters() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime? dateFrom,  DateTime? dateTo,  Set<HikeDifficulty> difficulties,  int? priceMax,  String? region,  int? organizerId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HikeFilters() when $default != null:
return $default(_that.dateFrom,_that.dateTo,_that.difficulties,_that.priceMax,_that.region,_that.organizerId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime? dateFrom,  DateTime? dateTo,  Set<HikeDifficulty> difficulties,  int? priceMax,  String? region,  int? organizerId)  $default,) {final _that = this;
switch (_that) {
case _HikeFilters():
return $default(_that.dateFrom,_that.dateTo,_that.difficulties,_that.priceMax,_that.region,_that.organizerId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime? dateFrom,  DateTime? dateTo,  Set<HikeDifficulty> difficulties,  int? priceMax,  String? region,  int? organizerId)?  $default,) {final _that = this;
switch (_that) {
case _HikeFilters() when $default != null:
return $default(_that.dateFrom,_that.dateTo,_that.difficulties,_that.priceMax,_that.region,_that.organizerId);case _:
  return null;

}
}

}

/// @nodoc


class _HikeFilters extends HikeFilters {
  const _HikeFilters({this.dateFrom, this.dateTo, final  Set<HikeDifficulty> difficulties = const <HikeDifficulty>{}, this.priceMax, this.region, this.organizerId}): _difficulties = difficulties,super._();
  

@override final  DateTime? dateFrom;
@override final  DateTime? dateTo;
 final  Set<HikeDifficulty> _difficulties;
@override@JsonKey() Set<HikeDifficulty> get difficulties {
  if (_difficulties is EqualUnmodifiableSetView) return _difficulties;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_difficulties);
}

@override final  int? priceMax;
@override final  String? region;
@override final  int? organizerId;

/// Create a copy of HikeFilters
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HikeFiltersCopyWith<_HikeFilters> get copyWith => __$HikeFiltersCopyWithImpl<_HikeFilters>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HikeFilters&&(identical(other.dateFrom, dateFrom) || other.dateFrom == dateFrom)&&(identical(other.dateTo, dateTo) || other.dateTo == dateTo)&&const DeepCollectionEquality().equals(other._difficulties, _difficulties)&&(identical(other.priceMax, priceMax) || other.priceMax == priceMax)&&(identical(other.region, region) || other.region == region)&&(identical(other.organizerId, organizerId) || other.organizerId == organizerId));
}


@override
int get hashCode => Object.hash(runtimeType,dateFrom,dateTo,const DeepCollectionEquality().hash(_difficulties),priceMax,region,organizerId);

@override
String toString() {
  return 'HikeFilters(dateFrom: $dateFrom, dateTo: $dateTo, difficulties: $difficulties, priceMax: $priceMax, region: $region, organizerId: $organizerId)';
}


}

/// @nodoc
abstract mixin class _$HikeFiltersCopyWith<$Res> implements $HikeFiltersCopyWith<$Res> {
  factory _$HikeFiltersCopyWith(_HikeFilters value, $Res Function(_HikeFilters) _then) = __$HikeFiltersCopyWithImpl;
@override @useResult
$Res call({
 DateTime? dateFrom, DateTime? dateTo, Set<HikeDifficulty> difficulties, int? priceMax, String? region, int? organizerId
});




}
/// @nodoc
class __$HikeFiltersCopyWithImpl<$Res>
    implements _$HikeFiltersCopyWith<$Res> {
  __$HikeFiltersCopyWithImpl(this._self, this._then);

  final _HikeFilters _self;
  final $Res Function(_HikeFilters) _then;

/// Create a copy of HikeFilters
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? dateFrom = freezed,Object? dateTo = freezed,Object? difficulties = null,Object? priceMax = freezed,Object? region = freezed,Object? organizerId = freezed,}) {
  return _then(_HikeFilters(
dateFrom: freezed == dateFrom ? _self.dateFrom : dateFrom // ignore: cast_nullable_to_non_nullable
as DateTime?,dateTo: freezed == dateTo ? _self.dateTo : dateTo // ignore: cast_nullable_to_non_nullable
as DateTime?,difficulties: null == difficulties ? _self._difficulties : difficulties // ignore: cast_nullable_to_non_nullable
as Set<HikeDifficulty>,priceMax: freezed == priceMax ? _self.priceMax : priceMax // ignore: cast_nullable_to_non_nullable
as int?,region: freezed == region ? _self.region : region // ignore: cast_nullable_to_non_nullable
as String?,organizerId: freezed == organizerId ? _self.organizerId : organizerId // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
