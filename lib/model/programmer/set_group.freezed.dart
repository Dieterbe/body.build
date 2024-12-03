// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'set_group.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Sets _$SetsFromJson(Map<String, dynamic> json) {
  return _Sets.fromJson(json);
}

/// @nodoc
mixin _$Sets {
  int get intensity => throw _privateConstructorUsedError;
  @JsonKey(toJson: _exToJson, fromJson: _exFromJson)
  Ex? get ex => throw _privateConstructorUsedError;
  int get n => throw _privateConstructorUsedError;
  @JsonKey(includeToJson: false)
  bool get changeEx => throw _privateConstructorUsedError;

  /// Serializes this Sets to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Sets
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SetsCopyWith<Sets> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SetsCopyWith<$Res> {
  factory $SetsCopyWith(Sets value, $Res Function(Sets) then) =
      _$SetsCopyWithImpl<$Res, Sets>;
  @useResult
  $Res call(
      {int intensity,
      @JsonKey(toJson: _exToJson, fromJson: _exFromJson) Ex? ex,
      int n,
      @JsonKey(includeToJson: false) bool changeEx});
}

/// @nodoc
class _$SetsCopyWithImpl<$Res, $Val extends Sets>
    implements $SetsCopyWith<$Res> {
  _$SetsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Sets
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? intensity = null,
    Object? ex = freezed,
    Object? n = null,
    Object? changeEx = null,
  }) {
    return _then(_value.copyWith(
      intensity: null == intensity
          ? _value.intensity
          : intensity // ignore: cast_nullable_to_non_nullable
              as int,
      ex: freezed == ex
          ? _value.ex
          : ex // ignore: cast_nullable_to_non_nullable
              as Ex?,
      n: null == n
          ? _value.n
          : n // ignore: cast_nullable_to_non_nullable
              as int,
      changeEx: null == changeEx
          ? _value.changeEx
          : changeEx // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SetsImplCopyWith<$Res> implements $SetsCopyWith<$Res> {
  factory _$$SetsImplCopyWith(
          _$SetsImpl value, $Res Function(_$SetsImpl) then) =
      __$$SetsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int intensity,
      @JsonKey(toJson: _exToJson, fromJson: _exFromJson) Ex? ex,
      int n,
      @JsonKey(includeToJson: false) bool changeEx});
}

/// @nodoc
class __$$SetsImplCopyWithImpl<$Res>
    extends _$SetsCopyWithImpl<$Res, _$SetsImpl>
    implements _$$SetsImplCopyWith<$Res> {
  __$$SetsImplCopyWithImpl(_$SetsImpl _value, $Res Function(_$SetsImpl) _then)
      : super(_value, _then);

  /// Create a copy of Sets
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? intensity = null,
    Object? ex = freezed,
    Object? n = null,
    Object? changeEx = null,
  }) {
    return _then(_$SetsImpl(
      null == intensity
          ? _value.intensity
          : intensity // ignore: cast_nullable_to_non_nullable
              as int,
      ex: freezed == ex
          ? _value.ex
          : ex // ignore: cast_nullable_to_non_nullable
              as Ex?,
      n: null == n
          ? _value.n
          : n // ignore: cast_nullable_to_non_nullable
              as int,
      changeEx: null == changeEx
          ? _value.changeEx
          : changeEx // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SetsImpl extends _Sets {
  const _$SetsImpl(this.intensity,
      {@JsonKey(toJson: _exToJson, fromJson: _exFromJson) this.ex,
      this.n = 1,
      @JsonKey(includeToJson: false) this.changeEx = false})
      : super._();

  factory _$SetsImpl.fromJson(Map<String, dynamic> json) =>
      _$$SetsImplFromJson(json);

  @override
  final int intensity;
  @override
  @JsonKey(toJson: _exToJson, fromJson: _exFromJson)
  final Ex? ex;
  @override
  @JsonKey()
  final int n;
  @override
  @JsonKey(includeToJson: false)
  final bool changeEx;

  @override
  String toString() {
    return 'Sets(intensity: $intensity, ex: $ex, n: $n, changeEx: $changeEx)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SetsImpl &&
            (identical(other.intensity, intensity) ||
                other.intensity == intensity) &&
            (identical(other.ex, ex) || other.ex == ex) &&
            (identical(other.n, n) || other.n == n) &&
            (identical(other.changeEx, changeEx) ||
                other.changeEx == changeEx));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, intensity, ex, n, changeEx);

  /// Create a copy of Sets
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SetsImplCopyWith<_$SetsImpl> get copyWith =>
      __$$SetsImplCopyWithImpl<_$SetsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SetsImplToJson(
      this,
    );
  }
}

abstract class _Sets extends Sets {
  const factory _Sets(final int intensity,
      {@JsonKey(toJson: _exToJson, fromJson: _exFromJson) final Ex? ex,
      final int n,
      @JsonKey(includeToJson: false) final bool changeEx}) = _$SetsImpl;
  const _Sets._() : super._();

  factory _Sets.fromJson(Map<String, dynamic> json) = _$SetsImpl.fromJson;

  @override
  int get intensity;
  @override
  @JsonKey(toJson: _exToJson, fromJson: _exFromJson)
  Ex? get ex;
  @override
  int get n;
  @override
  @JsonKey(includeToJson: false)
  bool get changeEx;

  /// Create a copy of Sets
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SetsImplCopyWith<_$SetsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SetGroup _$SetGroupFromJson(Map<String, dynamic> json) {
  return _SetGroup.fromJson(json);
}

/// @nodoc
mixin _$SetGroup {
  List<Sets> get sets => throw _privateConstructorUsedError;

  /// Serializes this SetGroup to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SetGroup
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SetGroupCopyWith<SetGroup> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SetGroupCopyWith<$Res> {
  factory $SetGroupCopyWith(SetGroup value, $Res Function(SetGroup) then) =
      _$SetGroupCopyWithImpl<$Res, SetGroup>;
  @useResult
  $Res call({List<Sets> sets});
}

/// @nodoc
class _$SetGroupCopyWithImpl<$Res, $Val extends SetGroup>
    implements $SetGroupCopyWith<$Res> {
  _$SetGroupCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SetGroup
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sets = null,
  }) {
    return _then(_value.copyWith(
      sets: null == sets
          ? _value.sets
          : sets // ignore: cast_nullable_to_non_nullable
              as List<Sets>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SetGroupImplCopyWith<$Res>
    implements $SetGroupCopyWith<$Res> {
  factory _$$SetGroupImplCopyWith(
          _$SetGroupImpl value, $Res Function(_$SetGroupImpl) then) =
      __$$SetGroupImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<Sets> sets});
}

/// @nodoc
class __$$SetGroupImplCopyWithImpl<$Res>
    extends _$SetGroupCopyWithImpl<$Res, _$SetGroupImpl>
    implements _$$SetGroupImplCopyWith<$Res> {
  __$$SetGroupImplCopyWithImpl(
      _$SetGroupImpl _value, $Res Function(_$SetGroupImpl) _then)
      : super(_value, _then);

  /// Create a copy of SetGroup
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sets = null,
  }) {
    return _then(_$SetGroupImpl(
      null == sets
          ? _value._sets
          : sets // ignore: cast_nullable_to_non_nullable
              as List<Sets>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SetGroupImpl implements _SetGroup {
  const _$SetGroupImpl(final List<Sets> sets) : _sets = sets;

  factory _$SetGroupImpl.fromJson(Map<String, dynamic> json) =>
      _$$SetGroupImplFromJson(json);

  final List<Sets> _sets;
  @override
  List<Sets> get sets {
    if (_sets is EqualUnmodifiableListView) return _sets;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_sets);
  }

  @override
  String toString() {
    return 'SetGroup(sets: $sets)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SetGroupImpl &&
            const DeepCollectionEquality().equals(other._sets, _sets));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_sets));

  /// Create a copy of SetGroup
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SetGroupImplCopyWith<_$SetGroupImpl> get copyWith =>
      __$$SetGroupImplCopyWithImpl<_$SetGroupImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SetGroupImplToJson(
      this,
    );
  }
}

abstract class _SetGroup implements SetGroup {
  const factory _SetGroup(final List<Sets> sets) = _$SetGroupImpl;

  factory _SetGroup.fromJson(Map<String, dynamic> json) =
      _$SetGroupImpl.fromJson;

  @override
  List<Sets> get sets;

  /// Create a copy of SetGroup
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SetGroupImplCopyWith<_$SetGroupImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
