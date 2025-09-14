// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'program_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ProgramState _$ProgramStateFromJson(Map<String, dynamic> json) {
  return _ProgramState.fromJson(json);
}

/// @nodoc
mixin _$ProgramState {
  String get name => throw _privateConstructorUsedError;
  List<Workout> get workouts => throw _privateConstructorUsedError;
  bool get builtin => throw _privateConstructorUsedError;

  /// Serializes this ProgramState to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ProgramState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProgramStateCopyWith<ProgramState> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProgramStateCopyWith<$Res> {
  factory $ProgramStateCopyWith(ProgramState value, $Res Function(ProgramState) then) =
      _$ProgramStateCopyWithImpl<$Res, ProgramState>;
  @useResult
  $Res call({String name, List<Workout> workouts, bool builtin});
}

/// @nodoc
class _$ProgramStateCopyWithImpl<$Res, $Val extends ProgramState>
    implements $ProgramStateCopyWith<$Res> {
  _$ProgramStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProgramState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? workouts = null,
    Object? builtin = null,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      workouts: null == workouts
          ? _value.workouts
          : workouts // ignore: cast_nullable_to_non_nullable
              as List<Workout>,
      builtin: null == builtin
          ? _value.builtin
          : builtin // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ProgramStateImplCopyWith<$Res> implements $ProgramStateCopyWith<$Res> {
  factory _$$ProgramStateImplCopyWith(
          _$ProgramStateImpl value, $Res Function(_$ProgramStateImpl) then) =
      __$$ProgramStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String name, List<Workout> workouts, bool builtin});
}

/// @nodoc
class __$$ProgramStateImplCopyWithImpl<$Res>
    extends _$ProgramStateCopyWithImpl<$Res, _$ProgramStateImpl>
    implements _$$ProgramStateImplCopyWith<$Res> {
  __$$ProgramStateImplCopyWithImpl(
      _$ProgramStateImpl _value, $Res Function(_$ProgramStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of ProgramState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? workouts = null,
    Object? builtin = null,
  }) {
    return _then(_$ProgramStateImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      workouts: null == workouts
          ? _value._workouts
          : workouts // ignore: cast_nullable_to_non_nullable
              as List<Workout>,
      builtin: null == builtin
          ? _value.builtin
          : builtin // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ProgramStateImpl implements _ProgramState {
  const _$ProgramStateImpl(
      {this.name = 'unnamed program',
      final List<Workout> workouts = const [],
      this.builtin = false})
      : _workouts = workouts;

  factory _$ProgramStateImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProgramStateImplFromJson(json);

  @override
  @JsonKey()
  final String name;
  final List<Workout> _workouts;
  @override
  @JsonKey()
  List<Workout> get workouts {
    if (_workouts is EqualUnmodifiableListView) return _workouts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_workouts);
  }

  @override
  @JsonKey()
  final bool builtin;

  @override
  String toString() {
    return 'ProgramState(name: $name, workouts: $workouts, builtin: $builtin)';
  }

  /// Create a copy of ProgramState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProgramStateImplCopyWith<_$ProgramStateImpl> get copyWith =>
      __$$ProgramStateImplCopyWithImpl<_$ProgramStateImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProgramStateImplToJson(
      this,
    );
  }
}

abstract class _ProgramState implements ProgramState {
  const factory _ProgramState(
      {final String name, final List<Workout> workouts, final bool builtin}) = _$ProgramStateImpl;

  factory _ProgramState.fromJson(Map<String, dynamic> json) = _$ProgramStateImpl.fromJson;

  @override
  String get name;
  @override
  List<Workout> get workouts;
  @override
  bool get builtin;

  /// Create a copy of ProgramState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProgramStateImplCopyWith<_$ProgramStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
