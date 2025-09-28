// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'workout.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Workout {

 String get name; List<SetGroup> get setGroups; int get timesPerPeriod; int get periodWeeks;
/// Create a copy of Workout
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WorkoutCopyWith<Workout> get copyWith => _$WorkoutCopyWithImpl<Workout>(this as Workout, _$identity);

  /// Serializes this Workout to a JSON map.
  Map<String, dynamic> toJson();




@override
String toString() {
  return 'Workout(name: $name, setGroups: $setGroups, timesPerPeriod: $timesPerPeriod, periodWeeks: $periodWeeks)';
}


}

/// @nodoc
abstract mixin class $WorkoutCopyWith<$Res>  {
  factory $WorkoutCopyWith(Workout value, $Res Function(Workout) _then) = _$WorkoutCopyWithImpl;
@useResult
$Res call({
 String name, List<SetGroup> setGroups, int timesPerPeriod, int periodWeeks
});




}
/// @nodoc
class _$WorkoutCopyWithImpl<$Res>
    implements $WorkoutCopyWith<$Res> {
  _$WorkoutCopyWithImpl(this._self, this._then);

  final Workout _self;
  final $Res Function(Workout) _then;

/// Create a copy of Workout
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? setGroups = null,Object? timesPerPeriod = null,Object? periodWeeks = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,setGroups: null == setGroups ? _self.setGroups : setGroups // ignore: cast_nullable_to_non_nullable
as List<SetGroup>,timesPerPeriod: null == timesPerPeriod ? _self.timesPerPeriod : timesPerPeriod // ignore: cast_nullable_to_non_nullable
as int,periodWeeks: null == periodWeeks ? _self.periodWeeks : periodWeeks // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [Workout].
extension WorkoutPatterns on Workout {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Workout value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Workout() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Workout value)  $default,){
final _that = this;
switch (_that) {
case _Workout():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Workout value)?  $default,){
final _that = this;
switch (_that) {
case _Workout() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  List<SetGroup> setGroups,  int timesPerPeriod,  int periodWeeks)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Workout() when $default != null:
return $default(_that.name,_that.setGroups,_that.timesPerPeriod,_that.periodWeeks);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  List<SetGroup> setGroups,  int timesPerPeriod,  int periodWeeks)  $default,) {final _that = this;
switch (_that) {
case _Workout():
return $default(_that.name,_that.setGroups,_that.timesPerPeriod,_that.periodWeeks);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  List<SetGroup> setGroups,  int timesPerPeriod,  int periodWeeks)?  $default,) {final _that = this;
switch (_that) {
case _Workout() when $default != null:
return $default(_that.name,_that.setGroups,_that.timesPerPeriod,_that.periodWeeks);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Workout implements Workout {
  const _Workout({this.name = 'unnamed workout', final  List<SetGroup> setGroups = const [], this.timesPerPeriod = 1, this.periodWeeks = 1}): _setGroups = setGroups;
  factory _Workout.fromJson(Map<String, dynamic> json) => _$WorkoutFromJson(json);

@override@JsonKey() final  String name;
 final  List<SetGroup> _setGroups;
@override@JsonKey() List<SetGroup> get setGroups {
  if (_setGroups is EqualUnmodifiableListView) return _setGroups;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_setGroups);
}

@override@JsonKey() final  int timesPerPeriod;
@override@JsonKey() final  int periodWeeks;

/// Create a copy of Workout
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WorkoutCopyWith<_Workout> get copyWith => __$WorkoutCopyWithImpl<_Workout>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WorkoutToJson(this, );
}



@override
String toString() {
  return 'Workout(name: $name, setGroups: $setGroups, timesPerPeriod: $timesPerPeriod, periodWeeks: $periodWeeks)';
}


}

/// @nodoc
abstract mixin class _$WorkoutCopyWith<$Res> implements $WorkoutCopyWith<$Res> {
  factory _$WorkoutCopyWith(_Workout value, $Res Function(_Workout) _then) = __$WorkoutCopyWithImpl;
@override @useResult
$Res call({
 String name, List<SetGroup> setGroups, int timesPerPeriod, int periodWeeks
});




}
/// @nodoc
class __$WorkoutCopyWithImpl<$Res>
    implements _$WorkoutCopyWith<$Res> {
  __$WorkoutCopyWithImpl(this._self, this._then);

  final _Workout _self;
  final $Res Function(_Workout) _then;

/// Create a copy of Workout
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? setGroups = null,Object? timesPerPeriod = null,Object? periodWeeks = null,}) {
  return _then(_Workout(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,setGroups: null == setGroups ? _self._setGroups : setGroups // ignore: cast_nullable_to_non_nullable
as List<SetGroup>,timesPerPeriod: null == timesPerPeriod ? _self.timesPerPeriod : timesPerPeriod // ignore: cast_nullable_to_non_nullable
as int,periodWeeks: null == periodWeeks ? _self.periodWeeks : periodWeeks // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
