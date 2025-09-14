// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'parameters.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Parameters _$ParametersFromJson(Map<String, dynamic> json) {
  return _Parameters.fromJson(json);
}

/// @nodoc
mixin _$Parameters {
  List<int> get intensities => throw _privateConstructorUsedError;
  int get setsPerweekPerMuscleGroup => throw _privateConstructorUsedError;
  List<MuscleGroupOverride> get setsPerWeekPerMuscleGroupIndividual =>
      throw _privateConstructorUsedError;

  /// Serializes this Parameters to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Parameters
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ParametersCopyWith<Parameters> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ParametersCopyWith<$Res> {
  factory $ParametersCopyWith(Parameters value, $Res Function(Parameters) then) =
      _$ParametersCopyWithImpl<$Res, Parameters>;
  @useResult
  $Res call(
      {List<int> intensities,
      int setsPerweekPerMuscleGroup,
      List<MuscleGroupOverride> setsPerWeekPerMuscleGroupIndividual});
}

/// @nodoc
class _$ParametersCopyWithImpl<$Res, $Val extends Parameters> implements $ParametersCopyWith<$Res> {
  _$ParametersCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Parameters
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? intensities = null,
    Object? setsPerweekPerMuscleGroup = null,
    Object? setsPerWeekPerMuscleGroupIndividual = null,
  }) {
    return _then(_value.copyWith(
      intensities: null == intensities
          ? _value.intensities
          : intensities // ignore: cast_nullable_to_non_nullable
              as List<int>,
      setsPerweekPerMuscleGroup: null == setsPerweekPerMuscleGroup
          ? _value.setsPerweekPerMuscleGroup
          : setsPerweekPerMuscleGroup // ignore: cast_nullable_to_non_nullable
              as int,
      setsPerWeekPerMuscleGroupIndividual: null == setsPerWeekPerMuscleGroupIndividual
          ? _value.setsPerWeekPerMuscleGroupIndividual
          : setsPerWeekPerMuscleGroupIndividual // ignore: cast_nullable_to_non_nullable
              as List<MuscleGroupOverride>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ParametersImplCopyWith<$Res> implements $ParametersCopyWith<$Res> {
  factory _$$ParametersImplCopyWith(_$ParametersImpl value, $Res Function(_$ParametersImpl) then) =
      __$$ParametersImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<int> intensities,
      int setsPerweekPerMuscleGroup,
      List<MuscleGroupOverride> setsPerWeekPerMuscleGroupIndividual});
}

/// @nodoc
class __$$ParametersImplCopyWithImpl<$Res> extends _$ParametersCopyWithImpl<$Res, _$ParametersImpl>
    implements _$$ParametersImplCopyWith<$Res> {
  __$$ParametersImplCopyWithImpl(_$ParametersImpl _value, $Res Function(_$ParametersImpl) _then)
      : super(_value, _then);

  /// Create a copy of Parameters
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? intensities = null,
    Object? setsPerweekPerMuscleGroup = null,
    Object? setsPerWeekPerMuscleGroupIndividual = null,
  }) {
    return _then(_$ParametersImpl(
      intensities: null == intensities
          ? _value._intensities
          : intensities // ignore: cast_nullable_to_non_nullable
              as List<int>,
      setsPerweekPerMuscleGroup: null == setsPerweekPerMuscleGroup
          ? _value.setsPerweekPerMuscleGroup
          : setsPerweekPerMuscleGroup // ignore: cast_nullable_to_non_nullable
              as int,
      setsPerWeekPerMuscleGroupIndividual: null == setsPerWeekPerMuscleGroupIndividual
          ? _value._setsPerWeekPerMuscleGroupIndividual
          : setsPerWeekPerMuscleGroupIndividual // ignore: cast_nullable_to_non_nullable
              as List<MuscleGroupOverride>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ParametersImpl extends _Parameters {
  _$ParametersImpl(
      {final List<int> intensities = const [],
      this.setsPerweekPerMuscleGroup = 0,
      final List<MuscleGroupOverride> setsPerWeekPerMuscleGroupIndividual = const []})
      : _intensities = intensities,
        _setsPerWeekPerMuscleGroupIndividual = setsPerWeekPerMuscleGroupIndividual,
        super._();

  factory _$ParametersImpl.fromJson(Map<String, dynamic> json) => _$$ParametersImplFromJson(json);

  final List<int> _intensities;
  @override
  @JsonKey()
  List<int> get intensities {
    if (_intensities is EqualUnmodifiableListView) return _intensities;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_intensities);
  }

  @override
  @JsonKey()
  final int setsPerweekPerMuscleGroup;
  final List<MuscleGroupOverride> _setsPerWeekPerMuscleGroupIndividual;
  @override
  @JsonKey()
  List<MuscleGroupOverride> get setsPerWeekPerMuscleGroupIndividual {
    if (_setsPerWeekPerMuscleGroupIndividual is EqualUnmodifiableListView)
      return _setsPerWeekPerMuscleGroupIndividual;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_setsPerWeekPerMuscleGroupIndividual);
  }

  @override
  String toString() {
    return 'Parameters(intensities: $intensities, setsPerweekPerMuscleGroup: $setsPerweekPerMuscleGroup, setsPerWeekPerMuscleGroupIndividual: $setsPerWeekPerMuscleGroupIndividual)';
  }

  /// Create a copy of Parameters
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ParametersImplCopyWith<_$ParametersImpl> get copyWith =>
      __$$ParametersImplCopyWithImpl<_$ParametersImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ParametersImplToJson(
      this,
    );
  }
}

abstract class _Parameters extends Parameters {
  factory _Parameters(
      {final List<int> intensities,
      final int setsPerweekPerMuscleGroup,
      final List<MuscleGroupOverride> setsPerWeekPerMuscleGroupIndividual}) = _$ParametersImpl;
  _Parameters._() : super._();

  factory _Parameters.fromJson(Map<String, dynamic> json) = _$ParametersImpl.fromJson;

  @override
  List<int> get intensities;
  @override
  int get setsPerweekPerMuscleGroup;
  @override
  List<MuscleGroupOverride> get setsPerWeekPerMuscleGroupIndividual;

  /// Create a copy of Parameters
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ParametersImplCopyWith<_$ParametersImpl> get copyWith => throw _privateConstructorUsedError;
}
