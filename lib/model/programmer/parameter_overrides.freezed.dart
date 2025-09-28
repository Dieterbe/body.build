// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'parameter_overrides.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MuscleGroupOverride {

 ProgramGroup get group; int get sets;
/// Create a copy of MuscleGroupOverride
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MuscleGroupOverrideCopyWith<MuscleGroupOverride> get copyWith => _$MuscleGroupOverrideCopyWithImpl<MuscleGroupOverride>(this as MuscleGroupOverride, _$identity);

  /// Serializes this MuscleGroupOverride to a JSON map.
  Map<String, dynamic> toJson();




@override
String toString() {
  return 'MuscleGroupOverride(group: $group, sets: $sets)';
}


}

/// @nodoc
abstract mixin class $MuscleGroupOverrideCopyWith<$Res>  {
  factory $MuscleGroupOverrideCopyWith(MuscleGroupOverride value, $Res Function(MuscleGroupOverride) _then) = _$MuscleGroupOverrideCopyWithImpl;
@useResult
$Res call({
 ProgramGroup group, int sets
});




}
/// @nodoc
class _$MuscleGroupOverrideCopyWithImpl<$Res>
    implements $MuscleGroupOverrideCopyWith<$Res> {
  _$MuscleGroupOverrideCopyWithImpl(this._self, this._then);

  final MuscleGroupOverride _self;
  final $Res Function(MuscleGroupOverride) _then;

/// Create a copy of MuscleGroupOverride
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? group = null,Object? sets = null,}) {
  return _then(_self.copyWith(
group: null == group ? _self.group : group // ignore: cast_nullable_to_non_nullable
as ProgramGroup,sets: null == sets ? _self.sets : sets // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [MuscleGroupOverride].
extension MuscleGroupOverridePatterns on MuscleGroupOverride {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MuscleGroupOverride value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MuscleGroupOverride() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MuscleGroupOverride value)  $default,){
final _that = this;
switch (_that) {
case _MuscleGroupOverride():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MuscleGroupOverride value)?  $default,){
final _that = this;
switch (_that) {
case _MuscleGroupOverride() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ProgramGroup group,  int sets)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MuscleGroupOverride() when $default != null:
return $default(_that.group,_that.sets);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ProgramGroup group,  int sets)  $default,) {final _that = this;
switch (_that) {
case _MuscleGroupOverride():
return $default(_that.group,_that.sets);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ProgramGroup group,  int sets)?  $default,) {final _that = this;
switch (_that) {
case _MuscleGroupOverride() when $default != null:
return $default(_that.group,_that.sets);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MuscleGroupOverride implements MuscleGroupOverride {
  const _MuscleGroupOverride(this.group, this.sets);
  factory _MuscleGroupOverride.fromJson(Map<String, dynamic> json) => _$MuscleGroupOverrideFromJson(json);

@override final  ProgramGroup group;
@override final  int sets;

/// Create a copy of MuscleGroupOverride
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MuscleGroupOverrideCopyWith<_MuscleGroupOverride> get copyWith => __$MuscleGroupOverrideCopyWithImpl<_MuscleGroupOverride>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MuscleGroupOverrideToJson(this, );
}



@override
String toString() {
  return 'MuscleGroupOverride(group: $group, sets: $sets)';
}


}

/// @nodoc
abstract mixin class _$MuscleGroupOverrideCopyWith<$Res> implements $MuscleGroupOverrideCopyWith<$Res> {
  factory _$MuscleGroupOverrideCopyWith(_MuscleGroupOverride value, $Res Function(_MuscleGroupOverride) _then) = __$MuscleGroupOverrideCopyWithImpl;
@override @useResult
$Res call({
 ProgramGroup group, int sets
});




}
/// @nodoc
class __$MuscleGroupOverrideCopyWithImpl<$Res>
    implements _$MuscleGroupOverrideCopyWith<$Res> {
  __$MuscleGroupOverrideCopyWithImpl(this._self, this._then);

  final _MuscleGroupOverride _self;
  final $Res Function(_MuscleGroupOverride) _then;

/// Create a copy of MuscleGroupOverride
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? group = null,Object? sets = null,}) {
  return _then(_MuscleGroupOverride(
null == group ? _self.group : group // ignore: cast_nullable_to_non_nullable
as ProgramGroup,null == sets ? _self.sets : sets // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$ParameterOverrides {

 List<int>? get intensities; int? get setsPerWeekPerMuscleGroup; List<MuscleGroupOverride>? get setsPerWeekPerMuscleGroupIndividual;@JsonKey(toJson: _exSetToJson, fromJson: _exSetFromJson) Set<Ex>? get excludedExercises;
/// Create a copy of ParameterOverrides
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ParameterOverridesCopyWith<ParameterOverrides> get copyWith => _$ParameterOverridesCopyWithImpl<ParameterOverrides>(this as ParameterOverrides, _$identity);

  /// Serializes this ParameterOverrides to a JSON map.
  Map<String, dynamic> toJson();




@override
String toString() {
  return 'ParameterOverrides(intensities: $intensities, setsPerWeekPerMuscleGroup: $setsPerWeekPerMuscleGroup, setsPerWeekPerMuscleGroupIndividual: $setsPerWeekPerMuscleGroupIndividual, excludedExercises: $excludedExercises)';
}


}

/// @nodoc
abstract mixin class $ParameterOverridesCopyWith<$Res>  {
  factory $ParameterOverridesCopyWith(ParameterOverrides value, $Res Function(ParameterOverrides) _then) = _$ParameterOverridesCopyWithImpl;
@useResult
$Res call({
 List<int>? intensities, int? setsPerWeekPerMuscleGroup, List<MuscleGroupOverride>? setsPerWeekPerMuscleGroupIndividual,@JsonKey(toJson: _exSetToJson, fromJson: _exSetFromJson) Set<Ex>? excludedExercises
});




}
/// @nodoc
class _$ParameterOverridesCopyWithImpl<$Res>
    implements $ParameterOverridesCopyWith<$Res> {
  _$ParameterOverridesCopyWithImpl(this._self, this._then);

  final ParameterOverrides _self;
  final $Res Function(ParameterOverrides) _then;

/// Create a copy of ParameterOverrides
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? intensities = freezed,Object? setsPerWeekPerMuscleGroup = freezed,Object? setsPerWeekPerMuscleGroupIndividual = freezed,Object? excludedExercises = freezed,}) {
  return _then(_self.copyWith(
intensities: freezed == intensities ? _self.intensities : intensities // ignore: cast_nullable_to_non_nullable
as List<int>?,setsPerWeekPerMuscleGroup: freezed == setsPerWeekPerMuscleGroup ? _self.setsPerWeekPerMuscleGroup : setsPerWeekPerMuscleGroup // ignore: cast_nullable_to_non_nullable
as int?,setsPerWeekPerMuscleGroupIndividual: freezed == setsPerWeekPerMuscleGroupIndividual ? _self.setsPerWeekPerMuscleGroupIndividual : setsPerWeekPerMuscleGroupIndividual // ignore: cast_nullable_to_non_nullable
as List<MuscleGroupOverride>?,excludedExercises: freezed == excludedExercises ? _self.excludedExercises : excludedExercises // ignore: cast_nullable_to_non_nullable
as Set<Ex>?,
  ));
}

}


/// Adds pattern-matching-related methods to [ParameterOverrides].
extension ParameterOverridesPatterns on ParameterOverrides {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ParameterOverrides value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ParameterOverrides() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ParameterOverrides value)  $default,){
final _that = this;
switch (_that) {
case _ParameterOverrides():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ParameterOverrides value)?  $default,){
final _that = this;
switch (_that) {
case _ParameterOverrides() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<int>? intensities,  int? setsPerWeekPerMuscleGroup,  List<MuscleGroupOverride>? setsPerWeekPerMuscleGroupIndividual, @JsonKey(toJson: _exSetToJson, fromJson: _exSetFromJson)  Set<Ex>? excludedExercises)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ParameterOverrides() when $default != null:
return $default(_that.intensities,_that.setsPerWeekPerMuscleGroup,_that.setsPerWeekPerMuscleGroupIndividual,_that.excludedExercises);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<int>? intensities,  int? setsPerWeekPerMuscleGroup,  List<MuscleGroupOverride>? setsPerWeekPerMuscleGroupIndividual, @JsonKey(toJson: _exSetToJson, fromJson: _exSetFromJson)  Set<Ex>? excludedExercises)  $default,) {final _that = this;
switch (_that) {
case _ParameterOverrides():
return $default(_that.intensities,_that.setsPerWeekPerMuscleGroup,_that.setsPerWeekPerMuscleGroupIndividual,_that.excludedExercises);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<int>? intensities,  int? setsPerWeekPerMuscleGroup,  List<MuscleGroupOverride>? setsPerWeekPerMuscleGroupIndividual, @JsonKey(toJson: _exSetToJson, fromJson: _exSetFromJson)  Set<Ex>? excludedExercises)?  $default,) {final _that = this;
switch (_that) {
case _ParameterOverrides() when $default != null:
return $default(_that.intensities,_that.setsPerWeekPerMuscleGroup,_that.setsPerWeekPerMuscleGroupIndividual,_that.excludedExercises);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ParameterOverrides implements ParameterOverrides {
  const _ParameterOverrides({final  List<int>? intensities, this.setsPerWeekPerMuscleGroup, final  List<MuscleGroupOverride>? setsPerWeekPerMuscleGroupIndividual, @JsonKey(toJson: _exSetToJson, fromJson: _exSetFromJson) final  Set<Ex>? excludedExercises}): _intensities = intensities,_setsPerWeekPerMuscleGroupIndividual = setsPerWeekPerMuscleGroupIndividual,_excludedExercises = excludedExercises;
  factory _ParameterOverrides.fromJson(Map<String, dynamic> json) => _$ParameterOverridesFromJson(json);

 final  List<int>? _intensities;
@override List<int>? get intensities {
  final value = _intensities;
  if (value == null) return null;
  if (_intensities is EqualUnmodifiableListView) return _intensities;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override final  int? setsPerWeekPerMuscleGroup;
 final  List<MuscleGroupOverride>? _setsPerWeekPerMuscleGroupIndividual;
@override List<MuscleGroupOverride>? get setsPerWeekPerMuscleGroupIndividual {
  final value = _setsPerWeekPerMuscleGroupIndividual;
  if (value == null) return null;
  if (_setsPerWeekPerMuscleGroupIndividual is EqualUnmodifiableListView) return _setsPerWeekPerMuscleGroupIndividual;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  Set<Ex>? _excludedExercises;
@override@JsonKey(toJson: _exSetToJson, fromJson: _exSetFromJson) Set<Ex>? get excludedExercises {
  final value = _excludedExercises;
  if (value == null) return null;
  if (_excludedExercises is EqualUnmodifiableSetView) return _excludedExercises;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(value);
}


/// Create a copy of ParameterOverrides
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ParameterOverridesCopyWith<_ParameterOverrides> get copyWith => __$ParameterOverridesCopyWithImpl<_ParameterOverrides>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ParameterOverridesToJson(this, );
}



@override
String toString() {
  return 'ParameterOverrides(intensities: $intensities, setsPerWeekPerMuscleGroup: $setsPerWeekPerMuscleGroup, setsPerWeekPerMuscleGroupIndividual: $setsPerWeekPerMuscleGroupIndividual, excludedExercises: $excludedExercises)';
}


}

/// @nodoc
abstract mixin class _$ParameterOverridesCopyWith<$Res> implements $ParameterOverridesCopyWith<$Res> {
  factory _$ParameterOverridesCopyWith(_ParameterOverrides value, $Res Function(_ParameterOverrides) _then) = __$ParameterOverridesCopyWithImpl;
@override @useResult
$Res call({
 List<int>? intensities, int? setsPerWeekPerMuscleGroup, List<MuscleGroupOverride>? setsPerWeekPerMuscleGroupIndividual,@JsonKey(toJson: _exSetToJson, fromJson: _exSetFromJson) Set<Ex>? excludedExercises
});




}
/// @nodoc
class __$ParameterOverridesCopyWithImpl<$Res>
    implements _$ParameterOverridesCopyWith<$Res> {
  __$ParameterOverridesCopyWithImpl(this._self, this._then);

  final _ParameterOverrides _self;
  final $Res Function(_ParameterOverrides) _then;

/// Create a copy of ParameterOverrides
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? intensities = freezed,Object? setsPerWeekPerMuscleGroup = freezed,Object? setsPerWeekPerMuscleGroupIndividual = freezed,Object? excludedExercises = freezed,}) {
  return _then(_ParameterOverrides(
intensities: freezed == intensities ? _self._intensities : intensities // ignore: cast_nullable_to_non_nullable
as List<int>?,setsPerWeekPerMuscleGroup: freezed == setsPerWeekPerMuscleGroup ? _self.setsPerWeekPerMuscleGroup : setsPerWeekPerMuscleGroup // ignore: cast_nullable_to_non_nullable
as int?,setsPerWeekPerMuscleGroupIndividual: freezed == setsPerWeekPerMuscleGroupIndividual ? _self._setsPerWeekPerMuscleGroupIndividual : setsPerWeekPerMuscleGroupIndividual // ignore: cast_nullable_to_non_nullable
as List<MuscleGroupOverride>?,excludedExercises: freezed == excludedExercises ? _self._excludedExercises : excludedExercises // ignore: cast_nullable_to_non_nullable
as Set<Ex>?,
  ));
}


}

// dart format on
