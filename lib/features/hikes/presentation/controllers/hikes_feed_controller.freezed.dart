// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'hikes_feed_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$HikesFeedState {

 List<Hike> get hikes; HikeFilters get filters; int get nextOffset; bool get hasMore; bool get isLoadingMore;
/// Create a copy of HikesFeedState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HikesFeedStateCopyWith<HikesFeedState> get copyWith => _$HikesFeedStateCopyWithImpl<HikesFeedState>(this as HikesFeedState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HikesFeedState&&const DeepCollectionEquality().equals(other.hikes, hikes)&&(identical(other.filters, filters) || other.filters == filters)&&(identical(other.nextOffset, nextOffset) || other.nextOffset == nextOffset)&&(identical(other.hasMore, hasMore) || other.hasMore == hasMore)&&(identical(other.isLoadingMore, isLoadingMore) || other.isLoadingMore == isLoadingMore));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(hikes),filters,nextOffset,hasMore,isLoadingMore);

@override
String toString() {
  return 'HikesFeedState(hikes: $hikes, filters: $filters, nextOffset: $nextOffset, hasMore: $hasMore, isLoadingMore: $isLoadingMore)';
}


}

/// @nodoc
abstract mixin class $HikesFeedStateCopyWith<$Res>  {
  factory $HikesFeedStateCopyWith(HikesFeedState value, $Res Function(HikesFeedState) _then) = _$HikesFeedStateCopyWithImpl;
@useResult
$Res call({
 List<Hike> hikes, HikeFilters filters, int nextOffset, bool hasMore, bool isLoadingMore
});


$HikeFiltersCopyWith<$Res> get filters;

}
/// @nodoc
class _$HikesFeedStateCopyWithImpl<$Res>
    implements $HikesFeedStateCopyWith<$Res> {
  _$HikesFeedStateCopyWithImpl(this._self, this._then);

  final HikesFeedState _self;
  final $Res Function(HikesFeedState) _then;

/// Create a copy of HikesFeedState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? hikes = null,Object? filters = null,Object? nextOffset = null,Object? hasMore = null,Object? isLoadingMore = null,}) {
  return _then(_self.copyWith(
hikes: null == hikes ? _self.hikes : hikes // ignore: cast_nullable_to_non_nullable
as List<Hike>,filters: null == filters ? _self.filters : filters // ignore: cast_nullable_to_non_nullable
as HikeFilters,nextOffset: null == nextOffset ? _self.nextOffset : nextOffset // ignore: cast_nullable_to_non_nullable
as int,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,isLoadingMore: null == isLoadingMore ? _self.isLoadingMore : isLoadingMore // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of HikesFeedState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$HikeFiltersCopyWith<$Res> get filters {
  
  return $HikeFiltersCopyWith<$Res>(_self.filters, (value) {
    return _then(_self.copyWith(filters: value));
  });
}
}


/// Adds pattern-matching-related methods to [HikesFeedState].
extension HikesFeedStatePatterns on HikesFeedState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HikesFeedState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HikesFeedState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HikesFeedState value)  $default,){
final _that = this;
switch (_that) {
case _HikesFeedState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HikesFeedState value)?  $default,){
final _that = this;
switch (_that) {
case _HikesFeedState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<Hike> hikes,  HikeFilters filters,  int nextOffset,  bool hasMore,  bool isLoadingMore)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HikesFeedState() when $default != null:
return $default(_that.hikes,_that.filters,_that.nextOffset,_that.hasMore,_that.isLoadingMore);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<Hike> hikes,  HikeFilters filters,  int nextOffset,  bool hasMore,  bool isLoadingMore)  $default,) {final _that = this;
switch (_that) {
case _HikesFeedState():
return $default(_that.hikes,_that.filters,_that.nextOffset,_that.hasMore,_that.isLoadingMore);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<Hike> hikes,  HikeFilters filters,  int nextOffset,  bool hasMore,  bool isLoadingMore)?  $default,) {final _that = this;
switch (_that) {
case _HikesFeedState() when $default != null:
return $default(_that.hikes,_that.filters,_that.nextOffset,_that.hasMore,_that.isLoadingMore);case _:
  return null;

}
}

}

/// @nodoc


class _HikesFeedState implements HikesFeedState {
  const _HikesFeedState({required final  List<Hike> hikes, required this.filters, this.nextOffset = 0, this.hasMore = false, this.isLoadingMore = false}): _hikes = hikes;
  

 final  List<Hike> _hikes;
@override List<Hike> get hikes {
  if (_hikes is EqualUnmodifiableListView) return _hikes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_hikes);
}

@override final  HikeFilters filters;
@override@JsonKey() final  int nextOffset;
@override@JsonKey() final  bool hasMore;
@override@JsonKey() final  bool isLoadingMore;

/// Create a copy of HikesFeedState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HikesFeedStateCopyWith<_HikesFeedState> get copyWith => __$HikesFeedStateCopyWithImpl<_HikesFeedState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HikesFeedState&&const DeepCollectionEquality().equals(other._hikes, _hikes)&&(identical(other.filters, filters) || other.filters == filters)&&(identical(other.nextOffset, nextOffset) || other.nextOffset == nextOffset)&&(identical(other.hasMore, hasMore) || other.hasMore == hasMore)&&(identical(other.isLoadingMore, isLoadingMore) || other.isLoadingMore == isLoadingMore));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_hikes),filters,nextOffset,hasMore,isLoadingMore);

@override
String toString() {
  return 'HikesFeedState(hikes: $hikes, filters: $filters, nextOffset: $nextOffset, hasMore: $hasMore, isLoadingMore: $isLoadingMore)';
}


}

/// @nodoc
abstract mixin class _$HikesFeedStateCopyWith<$Res> implements $HikesFeedStateCopyWith<$Res> {
  factory _$HikesFeedStateCopyWith(_HikesFeedState value, $Res Function(_HikesFeedState) _then) = __$HikesFeedStateCopyWithImpl;
@override @useResult
$Res call({
 List<Hike> hikes, HikeFilters filters, int nextOffset, bool hasMore, bool isLoadingMore
});


@override $HikeFiltersCopyWith<$Res> get filters;

}
/// @nodoc
class __$HikesFeedStateCopyWithImpl<$Res>
    implements _$HikesFeedStateCopyWith<$Res> {
  __$HikesFeedStateCopyWithImpl(this._self, this._then);

  final _HikesFeedState _self;
  final $Res Function(_HikesFeedState) _then;

/// Create a copy of HikesFeedState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? hikes = null,Object? filters = null,Object? nextOffset = null,Object? hasMore = null,Object? isLoadingMore = null,}) {
  return _then(_HikesFeedState(
hikes: null == hikes ? _self._hikes : hikes // ignore: cast_nullable_to_non_nullable
as List<Hike>,filters: null == filters ? _self.filters : filters // ignore: cast_nullable_to_non_nullable
as HikeFilters,nextOffset: null == nextOffset ? _self.nextOffset : nextOffset // ignore: cast_nullable_to_non_nullable
as int,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,isLoadingMore: null == isLoadingMore ? _self.isLoadingMore : isLoadingMore // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of HikesFeedState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$HikeFiltersCopyWith<$Res> get filters {
  
  return $HikeFiltersCopyWith<$Res>(_self.filters, (value) {
    return _then(_self.copyWith(filters: value));
  });
}
}

// dart format on
