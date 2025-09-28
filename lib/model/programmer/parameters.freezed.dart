// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'parameters.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Parameters {

 List<int> get intensities; int get setsPerweekPerMuscleGroup; List<MuscleGroupOverride> get setsPerWeekPerMuscleGroupIndividual;
/// Create a copy of Parameters
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ParametersCopyWith<Parameters> get copyWith => _$ParametersCopyWithImpl<Parameters>(this as Parameters, _$identity);

  /// Serializes this Parameters to a JSON map.
  Map<String, dynamic> toJson();




@override
String toString() {
  return 'Parameters(intensities: $intensities, setsPerweekPerMuscleGroup: $setsPerweekPerMuscleGroup, setsPerWeekPerMuscleGroupIndividual: $setsPerWeekPerMuscleGroupIndividual)';
}


}

/// @nodoc
abstract mixin class $ParametersCopyWith<$Res>  {
  factory $ParametersCopyWith(Parameters value, $Res Function(Parameters) _then) = _$ParametersCopyWithImpl;
@useResult
$Res call({
 List<int> intensities, int setsPerweekPerMuscleGroup, List<MuscleGroupOverride> setsPerWeekPerMuscleGroupIndividual
});




}
/// @nodoc
class _$ParametersCopyWithImpl<$Res>
    implements $ParametersCopyWith<$Res> {
  _$ParametersCopyWithImpl(this._self, this._then);

  final Parameters _self;
  final $Res Function(Parameters) _then;

/// Create a copy of Parameters
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? intensities = null,Object? setsPerweekPerMuscleGroup = null,Object? setsPerWeekPerMuscleGroupIndividual = null,}) {
  return _then(_self.copyWith(
intensities: null == intensities ? _self.intensities : intensities // ignore: cast_nullable_to_non_nullable
as List<int>,setsPerweekPerMuscleGroup: null == setsPerweekPerMuscleGroup ? _self.setsPerweekPerMuscleGroup : setsPerweekPerMuscleGroup // ignore: cast_nullable_to_non_nullable
as int,setsPerWeekPerMuscleGroupIndividual: null == setsPerWeekPerMuscleGroupIndividual ? _self.setsPerWeekPerMuscleGroupIndividual : setsPerWeekPerMuscleGroupIndividual // ignore: cast_nullable_to_non_nullable
as List<MuscleGroupOverride>,
  ));
}

}


/// Adds pattern-matching-related methods to [Parameters].
extension ParametersPatterns on Parameters {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Parameters value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Parameters() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Parameters value)  $default,){
final _that = this;
switch (_that) {
case _Parameters():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Parameters value)?  $default,){
final _that = this;
switch (_that) {
case _Parameters() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<int> intensities,  int setsPerweekPerMuscleGroup,  List<MuscleGroupOverride> setsPerWeekPerMuscleGroupIndividual)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Parameters() when $default != null:
return $default(_that.intensities,_that.setsPerweekPerMuscleGroup,_that.setsPerWeekPerMuscleGroupIndividual);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<int> intensities,  int setsPerweekPerMuscleGroup,  List<MuscleGroupOverride> setsPerWeekPerMuscleGroupIndividual)  $default,) {final _that = this;
switch (_that) {
case _Parameters():
return $default(_that.intensities,_that.setsPerweekPerMuscleGroup,_that.setsPerWeekPerMuscleGroupIndividual);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<int> intensities,  int setsPerweekPerMuscleGroup,  List<MuscleGroupOverride> setsPerWeekPerMuscleGroupIndividual)?  $default,) {final _that = this;
switch (_that) {
case _Parameters() when $default != null:
return $default(_that.intensities,_that.setsPerweekPerMuscleGroup,_that.setsPerWeekPerMuscleGroupIndividual);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Parameters extends Parameters {
   _Parameters({final  List<int> intensities = const [], this.setsPerweekPerMuscleGroup = 0, final  List<MuscleGroupOverride> setsPerWeekPerMuscleGroupIndividual = const []}): _intensities = intensities,_setsPerWeekPerMuscleGroupIndividual = setsPerWeekPerMuscleGroupIndividual,super._();
  factory _Parameters.fromJson(Map<String, dynamic> json) => _$ParametersFromJson(json);

 final  List<int> _intensities;
@override@JsonKey() List<int> get intensities {
  if (_intensities is EqualUnmodifiableListView) return _intensities;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_intensities);
}

@override@JsonKey() final  int setsPerweekPerMuscleGroup;
 final  List<MuscleGroupOverride> _setsPerWeekPerMuscleGroupIndividual;
@override@JsonKey() List<MuscleGroupOverride> get setsPerWeekPerMuscleGroupIndividual {
  if (_setsPerWeekPerMuscleGroupIndividual is EqualUnmodifiableListView) return _setsPerWeekPerMuscleGroupIndividual;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_setsPerWeekPerMuscleGroupIndividual);
}


/// Create a copy of Parameters
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ParametersCopyWith<_Parameters> get copyWith => __$ParametersCopyWithImpl<_Parameters>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ParametersToJson(this, );
}



@override
String toString() {
  return 'Parameters(intensities: $intensities, setsPerweekPerMuscleGroup: $setsPerweekPerMuscleGroup, setsPerWeekPerMuscleGroupIndividual: $setsPerWeekPerMuscleGroupIndividual)';
}


}

/// @nodoc
abstract mixin class _$ParametersCopyWith<$Res> implements $ParametersCopyWith<$Res> {
  factory _$ParametersCopyWith(_Parameters value, $Res Function(_Parameters) _then) = __$ParametersCopyWithImpl;
@override @useResult
$Res call({
 List<int> intensities, int setsPerweekPerMuscleGroup, List<MuscleGroupOverride> setsPerWeekPerMuscleGroupIndividual
});




}
/// @nodoc
class __$ParametersCopyWithImpl<$Res>
    implements _$ParametersCopyWith<$Res> {
  __$ParametersCopyWithImpl(this._self, this._then);

  final _Parameters _self;
  final $Res Function(_Parameters) _then;

/// Create a copy of Parameters
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? intensities = null,Object? setsPerweekPerMuscleGroup = null,Object? setsPerWeekPerMuscleGroupIndividual = null,}) {
  return _then(_Parameters(
intensities: null == intensities ? _self._intensities : intensities // ignore: cast_nullable_to_non_nullable
as List<int>,setsPerweekPerMuscleGroup: null == setsPerweekPerMuscleGroup ? _self.setsPerweekPerMuscleGroup : setsPerweekPerMuscleGroup // ignore: cast_nullable_to_non_nullable
as int,setsPerWeekPerMuscleGroupIndividual: null == setsPerWeekPerMuscleGroupIndividual ? _self._setsPerWeekPerMuscleGroupIndividual : setsPerWeekPerMuscleGroupIndividual // ignore: cast_nullable_to_non_nullable
as List<MuscleGroupOverride>,
  ));
}


}

// dart format on
