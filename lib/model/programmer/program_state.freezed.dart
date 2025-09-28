// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'program_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ProgramState {

 String get name; List<Workout> get workouts; bool get builtin;
/// Create a copy of ProgramState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProgramStateCopyWith<ProgramState> get copyWith => _$ProgramStateCopyWithImpl<ProgramState>(this as ProgramState, _$identity);

  /// Serializes this ProgramState to a JSON map.
  Map<String, dynamic> toJson();




@override
String toString() {
  return 'ProgramState(name: $name, workouts: $workouts, builtin: $builtin)';
}


}

/// @nodoc
abstract mixin class $ProgramStateCopyWith<$Res>  {
  factory $ProgramStateCopyWith(ProgramState value, $Res Function(ProgramState) _then) = _$ProgramStateCopyWithImpl;
@useResult
$Res call({
 String name, List<Workout> workouts, bool builtin
});




}
/// @nodoc
class _$ProgramStateCopyWithImpl<$Res>
    implements $ProgramStateCopyWith<$Res> {
  _$ProgramStateCopyWithImpl(this._self, this._then);

  final ProgramState _self;
  final $Res Function(ProgramState) _then;

/// Create a copy of ProgramState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? workouts = null,Object? builtin = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,workouts: null == workouts ? _self.workouts : workouts // ignore: cast_nullable_to_non_nullable
as List<Workout>,builtin: null == builtin ? _self.builtin : builtin // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ProgramState].
extension ProgramStatePatterns on ProgramState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProgramState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProgramState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProgramState value)  $default,){
final _that = this;
switch (_that) {
case _ProgramState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProgramState value)?  $default,){
final _that = this;
switch (_that) {
case _ProgramState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  List<Workout> workouts,  bool builtin)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProgramState() when $default != null:
return $default(_that.name,_that.workouts,_that.builtin);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  List<Workout> workouts,  bool builtin)  $default,) {final _that = this;
switch (_that) {
case _ProgramState():
return $default(_that.name,_that.workouts,_that.builtin);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  List<Workout> workouts,  bool builtin)?  $default,) {final _that = this;
switch (_that) {
case _ProgramState() when $default != null:
return $default(_that.name,_that.workouts,_that.builtin);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProgramState implements ProgramState {
  const _ProgramState({this.name = 'unnamed program', final  List<Workout> workouts = const [], this.builtin = false}): _workouts = workouts;
  factory _ProgramState.fromJson(Map<String, dynamic> json) => _$ProgramStateFromJson(json);

@override@JsonKey() final  String name;
 final  List<Workout> _workouts;
@override@JsonKey() List<Workout> get workouts {
  if (_workouts is EqualUnmodifiableListView) return _workouts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_workouts);
}

@override@JsonKey() final  bool builtin;

/// Create a copy of ProgramState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProgramStateCopyWith<_ProgramState> get copyWith => __$ProgramStateCopyWithImpl<_ProgramState>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProgramStateToJson(this, );
}



@override
String toString() {
  return 'ProgramState(name: $name, workouts: $workouts, builtin: $builtin)';
}


}

/// @nodoc
abstract mixin class _$ProgramStateCopyWith<$Res> implements $ProgramStateCopyWith<$Res> {
  factory _$ProgramStateCopyWith(_ProgramState value, $Res Function(_ProgramState) _then) = __$ProgramStateCopyWithImpl;
@override @useResult
$Res call({
 String name, List<Workout> workouts, bool builtin
});




}
/// @nodoc
class __$ProgramStateCopyWithImpl<$Res>
    implements _$ProgramStateCopyWith<$Res> {
  __$ProgramStateCopyWithImpl(this._self, this._then);

  final _ProgramState _self;
  final $Res Function(_ProgramState) _then;

/// Create a copy of ProgramState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? workouts = null,Object? builtin = null,}) {
  return _then(_ProgramState(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,workouts: null == workouts ? _self._workouts : workouts // ignore: cast_nullable_to_non_nullable
as List<Workout>,builtin: null == builtin ? _self.builtin : builtin // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
