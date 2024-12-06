// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'parameter_overrides.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

MuscleGroupOverride _$MuscleGroupOverrideFromJson(Map<String, dynamic> json) {
  return _MuscleGroupOverride.fromJson(json);
}

/// @nodoc
mixin _$MuscleGroupOverride {
  ProgramGroup get group => throw _privateConstructorUsedError;
  int get sets => throw _privateConstructorUsedError;

  /// Serializes this MuscleGroupOverride to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MuscleGroupOverride
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MuscleGroupOverrideCopyWith<MuscleGroupOverride> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MuscleGroupOverrideCopyWith<$Res> {
  factory $MuscleGroupOverrideCopyWith(
          MuscleGroupOverride value, $Res Function(MuscleGroupOverride) then) =
      _$MuscleGroupOverrideCopyWithImpl<$Res, MuscleGroupOverride>;
  @useResult
  $Res call({ProgramGroup group, int sets});
}

/// @nodoc
class _$MuscleGroupOverrideCopyWithImpl<$Res, $Val extends MuscleGroupOverride>
    implements $MuscleGroupOverrideCopyWith<$Res> {
  _$MuscleGroupOverrideCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MuscleGroupOverride
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? group = null,
    Object? sets = null,
  }) {
    return _then(_value.copyWith(
      group: null == group
          ? _value.group
          : group // ignore: cast_nullable_to_non_nullable
              as ProgramGroup,
      sets: null == sets
          ? _value.sets
          : sets // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MuscleGroupOverrideImplCopyWith<$Res>
    implements $MuscleGroupOverrideCopyWith<$Res> {
  factory _$$MuscleGroupOverrideImplCopyWith(_$MuscleGroupOverrideImpl value,
          $Res Function(_$MuscleGroupOverrideImpl) then) =
      __$$MuscleGroupOverrideImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({ProgramGroup group, int sets});
}

/// @nodoc
class __$$MuscleGroupOverrideImplCopyWithImpl<$Res>
    extends _$MuscleGroupOverrideCopyWithImpl<$Res, _$MuscleGroupOverrideImpl>
    implements _$$MuscleGroupOverrideImplCopyWith<$Res> {
  __$$MuscleGroupOverrideImplCopyWithImpl(_$MuscleGroupOverrideImpl _value,
      $Res Function(_$MuscleGroupOverrideImpl) _then)
      : super(_value, _then);

  /// Create a copy of MuscleGroupOverride
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? group = null,
    Object? sets = null,
  }) {
    return _then(_$MuscleGroupOverrideImpl(
      null == group
          ? _value.group
          : group // ignore: cast_nullable_to_non_nullable
              as ProgramGroup,
      null == sets
          ? _value.sets
          : sets // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MuscleGroupOverrideImpl implements _MuscleGroupOverride {
  const _$MuscleGroupOverrideImpl(this.group, this.sets);

  factory _$MuscleGroupOverrideImpl.fromJson(Map<String, dynamic> json) =>
      _$$MuscleGroupOverrideImplFromJson(json);

  @override
  final ProgramGroup group;
  @override
  final int sets;

  @override
  String toString() {
    return 'MuscleGroupOverride(group: $group, sets: $sets)';
  }

  /// Create a copy of MuscleGroupOverride
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MuscleGroupOverrideImplCopyWith<_$MuscleGroupOverrideImpl> get copyWith =>
      __$$MuscleGroupOverrideImplCopyWithImpl<_$MuscleGroupOverrideImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MuscleGroupOverrideImplToJson(
      this,
    );
  }
}

abstract class _MuscleGroupOverride implements MuscleGroupOverride {
  const factory _MuscleGroupOverride(final ProgramGroup group, final int sets) =
      _$MuscleGroupOverrideImpl;

  factory _MuscleGroupOverride.fromJson(Map<String, dynamic> json) =
      _$MuscleGroupOverrideImpl.fromJson;

  @override
  ProgramGroup get group;
  @override
  int get sets;

  /// Create a copy of MuscleGroupOverride
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MuscleGroupOverrideImplCopyWith<_$MuscleGroupOverrideImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ParameterOverrides _$ParameterOverridesFromJson(Map<String, dynamic> json) {
  return _ParameterOverrides.fromJson(json);
}

/// @nodoc
mixin _$ParameterOverrides {
  List<int>? get intensities => throw _privateConstructorUsedError;
  int? get setsPerWeekPerMuscleGroup => throw _privateConstructorUsedError;
  List<MuscleGroupOverride>? get setsPerWeekPerMuscleGroupIndividual =>
      throw _privateConstructorUsedError;
  @JsonKey(toJson: _exSetToJson, fromJson: _exSetFromJson)
  Set<Ex>? get excludedExercises => throw _privateConstructorUsedError;
  @JsonKey(toJson: _ebaseSetToJson, fromJson: _ebaseSetFromJson)
  Set<EBase>? get excludedBases => throw _privateConstructorUsedError;

  /// Serializes this ParameterOverrides to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ParameterOverrides
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ParameterOverridesCopyWith<ParameterOverrides> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ParameterOverridesCopyWith<$Res> {
  factory $ParameterOverridesCopyWith(
          ParameterOverrides value, $Res Function(ParameterOverrides) then) =
      _$ParameterOverridesCopyWithImpl<$Res, ParameterOverrides>;
  @useResult
  $Res call(
      {List<int>? intensities,
      int? setsPerWeekPerMuscleGroup,
      List<MuscleGroupOverride>? setsPerWeekPerMuscleGroupIndividual,
      @JsonKey(toJson: _exSetToJson, fromJson: _exSetFromJson)
      Set<Ex>? excludedExercises,
      @JsonKey(toJson: _ebaseSetToJson, fromJson: _ebaseSetFromJson)
      Set<EBase>? excludedBases});
}

/// @nodoc
class _$ParameterOverridesCopyWithImpl<$Res, $Val extends ParameterOverrides>
    implements $ParameterOverridesCopyWith<$Res> {
  _$ParameterOverridesCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ParameterOverrides
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? intensities = freezed,
    Object? setsPerWeekPerMuscleGroup = freezed,
    Object? setsPerWeekPerMuscleGroupIndividual = freezed,
    Object? excludedExercises = freezed,
    Object? excludedBases = freezed,
  }) {
    return _then(_value.copyWith(
      intensities: freezed == intensities
          ? _value.intensities
          : intensities // ignore: cast_nullable_to_non_nullable
              as List<int>?,
      setsPerWeekPerMuscleGroup: freezed == setsPerWeekPerMuscleGroup
          ? _value.setsPerWeekPerMuscleGroup
          : setsPerWeekPerMuscleGroup // ignore: cast_nullable_to_non_nullable
              as int?,
      setsPerWeekPerMuscleGroupIndividual: freezed ==
              setsPerWeekPerMuscleGroupIndividual
          ? _value.setsPerWeekPerMuscleGroupIndividual
          : setsPerWeekPerMuscleGroupIndividual // ignore: cast_nullable_to_non_nullable
              as List<MuscleGroupOverride>?,
      excludedExercises: freezed == excludedExercises
          ? _value.excludedExercises
          : excludedExercises // ignore: cast_nullable_to_non_nullable
              as Set<Ex>?,
      excludedBases: freezed == excludedBases
          ? _value.excludedBases
          : excludedBases // ignore: cast_nullable_to_non_nullable
              as Set<EBase>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ParameterOverridesImplCopyWith<$Res>
    implements $ParameterOverridesCopyWith<$Res> {
  factory _$$ParameterOverridesImplCopyWith(_$ParameterOverridesImpl value,
          $Res Function(_$ParameterOverridesImpl) then) =
      __$$ParameterOverridesImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<int>? intensities,
      int? setsPerWeekPerMuscleGroup,
      List<MuscleGroupOverride>? setsPerWeekPerMuscleGroupIndividual,
      @JsonKey(toJson: _exSetToJson, fromJson: _exSetFromJson)
      Set<Ex>? excludedExercises,
      @JsonKey(toJson: _ebaseSetToJson, fromJson: _ebaseSetFromJson)
      Set<EBase>? excludedBases});
}

/// @nodoc
class __$$ParameterOverridesImplCopyWithImpl<$Res>
    extends _$ParameterOverridesCopyWithImpl<$Res, _$ParameterOverridesImpl>
    implements _$$ParameterOverridesImplCopyWith<$Res> {
  __$$ParameterOverridesImplCopyWithImpl(_$ParameterOverridesImpl _value,
      $Res Function(_$ParameterOverridesImpl) _then)
      : super(_value, _then);

  /// Create a copy of ParameterOverrides
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? intensities = freezed,
    Object? setsPerWeekPerMuscleGroup = freezed,
    Object? setsPerWeekPerMuscleGroupIndividual = freezed,
    Object? excludedExercises = freezed,
    Object? excludedBases = freezed,
  }) {
    return _then(_$ParameterOverridesImpl(
      intensities: freezed == intensities
          ? _value._intensities
          : intensities // ignore: cast_nullable_to_non_nullable
              as List<int>?,
      setsPerWeekPerMuscleGroup: freezed == setsPerWeekPerMuscleGroup
          ? _value.setsPerWeekPerMuscleGroup
          : setsPerWeekPerMuscleGroup // ignore: cast_nullable_to_non_nullable
              as int?,
      setsPerWeekPerMuscleGroupIndividual: freezed ==
              setsPerWeekPerMuscleGroupIndividual
          ? _value._setsPerWeekPerMuscleGroupIndividual
          : setsPerWeekPerMuscleGroupIndividual // ignore: cast_nullable_to_non_nullable
              as List<MuscleGroupOverride>?,
      excludedExercises: freezed == excludedExercises
          ? _value._excludedExercises
          : excludedExercises // ignore: cast_nullable_to_non_nullable
              as Set<Ex>?,
      excludedBases: freezed == excludedBases
          ? _value._excludedBases
          : excludedBases // ignore: cast_nullable_to_non_nullable
              as Set<EBase>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ParameterOverridesImpl implements _ParameterOverrides {
  const _$ParameterOverridesImpl(
      {final List<int>? intensities,
      this.setsPerWeekPerMuscleGroup,
      final List<MuscleGroupOverride>? setsPerWeekPerMuscleGroupIndividual,
      @JsonKey(toJson: _exSetToJson, fromJson: _exSetFromJson)
      final Set<Ex>? excludedExercises,
      @JsonKey(toJson: _ebaseSetToJson, fromJson: _ebaseSetFromJson)
      final Set<EBase>? excludedBases})
      : _intensities = intensities,
        _setsPerWeekPerMuscleGroupIndividual =
            setsPerWeekPerMuscleGroupIndividual,
        _excludedExercises = excludedExercises,
        _excludedBases = excludedBases;

  factory _$ParameterOverridesImpl.fromJson(Map<String, dynamic> json) =>
      _$$ParameterOverridesImplFromJson(json);

  final List<int>? _intensities;
  @override
  List<int>? get intensities {
    final value = _intensities;
    if (value == null) return null;
    if (_intensities is EqualUnmodifiableListView) return _intensities;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final int? setsPerWeekPerMuscleGroup;
  final List<MuscleGroupOverride>? _setsPerWeekPerMuscleGroupIndividual;
  @override
  List<MuscleGroupOverride>? get setsPerWeekPerMuscleGroupIndividual {
    final value = _setsPerWeekPerMuscleGroupIndividual;
    if (value == null) return null;
    if (_setsPerWeekPerMuscleGroupIndividual is EqualUnmodifiableListView)
      return _setsPerWeekPerMuscleGroupIndividual;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final Set<Ex>? _excludedExercises;
  @override
  @JsonKey(toJson: _exSetToJson, fromJson: _exSetFromJson)
  Set<Ex>? get excludedExercises {
    final value = _excludedExercises;
    if (value == null) return null;
    if (_excludedExercises is EqualUnmodifiableSetView)
      return _excludedExercises;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(value);
  }

  final Set<EBase>? _excludedBases;
  @override
  @JsonKey(toJson: _ebaseSetToJson, fromJson: _ebaseSetFromJson)
  Set<EBase>? get excludedBases {
    final value = _excludedBases;
    if (value == null) return null;
    if (_excludedBases is EqualUnmodifiableSetView) return _excludedBases;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(value);
  }

  @override
  String toString() {
    return 'ParameterOverrides(intensities: $intensities, setsPerWeekPerMuscleGroup: $setsPerWeekPerMuscleGroup, setsPerWeekPerMuscleGroupIndividual: $setsPerWeekPerMuscleGroupIndividual, excludedExercises: $excludedExercises, excludedBases: $excludedBases)';
  }

  /// Create a copy of ParameterOverrides
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ParameterOverridesImplCopyWith<_$ParameterOverridesImpl> get copyWith =>
      __$$ParameterOverridesImplCopyWithImpl<_$ParameterOverridesImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ParameterOverridesImplToJson(
      this,
    );
  }
}

abstract class _ParameterOverrides implements ParameterOverrides {
  const factory _ParameterOverrides(
      {final List<int>? intensities,
      final int? setsPerWeekPerMuscleGroup,
      final List<MuscleGroupOverride>? setsPerWeekPerMuscleGroupIndividual,
      @JsonKey(toJson: _exSetToJson, fromJson: _exSetFromJson)
      final Set<Ex>? excludedExercises,
      @JsonKey(toJson: _ebaseSetToJson, fromJson: _ebaseSetFromJson)
      final Set<EBase>? excludedBases}) = _$ParameterOverridesImpl;

  factory _ParameterOverrides.fromJson(Map<String, dynamic> json) =
      _$ParameterOverridesImpl.fromJson;

  @override
  List<int>? get intensities;
  @override
  int? get setsPerWeekPerMuscleGroup;
  @override
  List<MuscleGroupOverride>? get setsPerWeekPerMuscleGroupIndividual;
  @override
  @JsonKey(toJson: _exSetToJson, fromJson: _exSetFromJson)
  Set<Ex>? get excludedExercises;
  @override
  @JsonKey(toJson: _ebaseSetToJson, fromJson: _ebaseSetFromJson)
  Set<EBase>? get excludedBases;

  /// Create a copy of ParameterOverrides
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ParameterOverridesImplCopyWith<_$ParameterOverridesImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
