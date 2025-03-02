// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'workout.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Workout _$WorkoutFromJson(Map<String, dynamic> json) {
  return _Workout.fromJson(json);
}

/// @nodoc
mixin _$Workout {
  String get name => throw _privateConstructorUsedError;
  List<SetGroup> get setGroups => throw _privateConstructorUsedError;
  int get timesPerPeriod => throw _privateConstructorUsedError;
  int get periodWeeks => throw _privateConstructorUsedError;

  /// Serializes this Workout to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Workout
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WorkoutCopyWith<Workout> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WorkoutCopyWith<$Res> {
  factory $WorkoutCopyWith(Workout value, $Res Function(Workout) then) =
      _$WorkoutCopyWithImpl<$Res, Workout>;
  @useResult
  $Res call(
      {String name,
      List<SetGroup> setGroups,
      int timesPerPeriod,
      int periodWeeks});
}

/// @nodoc
class _$WorkoutCopyWithImpl<$Res, $Val extends Workout>
    implements $WorkoutCopyWith<$Res> {
  _$WorkoutCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Workout
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? setGroups = null,
    Object? timesPerPeriod = null,
    Object? periodWeeks = null,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      setGroups: null == setGroups
          ? _value.setGroups
          : setGroups // ignore: cast_nullable_to_non_nullable
              as List<SetGroup>,
      timesPerPeriod: null == timesPerPeriod
          ? _value.timesPerPeriod
          : timesPerPeriod // ignore: cast_nullable_to_non_nullable
              as int,
      periodWeeks: null == periodWeeks
          ? _value.periodWeeks
          : periodWeeks // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WorkoutImplCopyWith<$Res> implements $WorkoutCopyWith<$Res> {
  factory _$$WorkoutImplCopyWith(
          _$WorkoutImpl value, $Res Function(_$WorkoutImpl) then) =
      __$$WorkoutImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String name,
      List<SetGroup> setGroups,
      int timesPerPeriod,
      int periodWeeks});
}

/// @nodoc
class __$$WorkoutImplCopyWithImpl<$Res>
    extends _$WorkoutCopyWithImpl<$Res, _$WorkoutImpl>
    implements _$$WorkoutImplCopyWith<$Res> {
  __$$WorkoutImplCopyWithImpl(
      _$WorkoutImpl _value, $Res Function(_$WorkoutImpl) _then)
      : super(_value, _then);

  /// Create a copy of Workout
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? setGroups = null,
    Object? timesPerPeriod = null,
    Object? periodWeeks = null,
  }) {
    return _then(_$WorkoutImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      setGroups: null == setGroups
          ? _value._setGroups
          : setGroups // ignore: cast_nullable_to_non_nullable
              as List<SetGroup>,
      timesPerPeriod: null == timesPerPeriod
          ? _value.timesPerPeriod
          : timesPerPeriod // ignore: cast_nullable_to_non_nullable
              as int,
      periodWeeks: null == periodWeeks
          ? _value.periodWeeks
          : periodWeeks // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WorkoutImpl implements _Workout {
  const _$WorkoutImpl(
      {this.name = 'unnamed workout',
      final List<SetGroup> setGroups = const [],
      this.timesPerPeriod = 1,
      this.periodWeeks = 1})
      : _setGroups = setGroups;

  factory _$WorkoutImpl.fromJson(Map<String, dynamic> json) =>
      _$$WorkoutImplFromJson(json);

  @override
  @JsonKey()
  final String name;
  final List<SetGroup> _setGroups;
  @override
  @JsonKey()
  List<SetGroup> get setGroups {
    if (_setGroups is EqualUnmodifiableListView) return _setGroups;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_setGroups);
  }

  @override
  @JsonKey()
  final int timesPerPeriod;
  @override
  @JsonKey()
  final int periodWeeks;

  @override
  String toString() {
    return 'Workout(name: $name, setGroups: $setGroups, timesPerPeriod: $timesPerPeriod, periodWeeks: $periodWeeks)';
  }

  /// Create a copy of Workout
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WorkoutImplCopyWith<_$WorkoutImpl> get copyWith =>
      __$$WorkoutImplCopyWithImpl<_$WorkoutImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WorkoutImplToJson(
      this,
    );
  }
}

abstract class _Workout implements Workout {
  const factory _Workout(
      {final String name,
      final List<SetGroup> setGroups,
      final int timesPerPeriod,
      final int periodWeeks}) = _$WorkoutImpl;

  factory _Workout.fromJson(Map<String, dynamic> json) = _$WorkoutImpl.fromJson;

  @override
  String get name;
  @override
  List<SetGroup> get setGroups;
  @override
  int get timesPerPeriod;
  @override
  int get periodWeeks;

  /// Create a copy of Workout
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WorkoutImplCopyWith<_$WorkoutImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
