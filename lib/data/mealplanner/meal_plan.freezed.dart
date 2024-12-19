// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'meal_plan.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

MealPlan _$MealPlanFromJson(Map<String, dynamic> json) {
  return _MealPlan.fromJson(json);
}

/// @nodoc
mixin _$MealPlan {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  List<DayPlan> get dayplans => throw _privateConstructorUsedError;

  /// Serializes this MealPlan to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MealPlan
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MealPlanCopyWith<MealPlan> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MealPlanCopyWith<$Res> {
  factory $MealPlanCopyWith(MealPlan value, $Res Function(MealPlan) then) =
      _$MealPlanCopyWithImpl<$Res, MealPlan>;
  @useResult
  $Res call({String id, String name, List<DayPlan> dayplans});
}

/// @nodoc
class _$MealPlanCopyWithImpl<$Res, $Val extends MealPlan>
    implements $MealPlanCopyWith<$Res> {
  _$MealPlanCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MealPlan
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? dayplans = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      dayplans: null == dayplans
          ? _value.dayplans
          : dayplans // ignore: cast_nullable_to_non_nullable
              as List<DayPlan>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MealPlanImplCopyWith<$Res>
    implements $MealPlanCopyWith<$Res> {
  factory _$$MealPlanImplCopyWith(
          _$MealPlanImpl value, $Res Function(_$MealPlanImpl) then) =
      __$$MealPlanImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String name, List<DayPlan> dayplans});
}

/// @nodoc
class __$$MealPlanImplCopyWithImpl<$Res>
    extends _$MealPlanCopyWithImpl<$Res, _$MealPlanImpl>
    implements _$$MealPlanImplCopyWith<$Res> {
  __$$MealPlanImplCopyWithImpl(
      _$MealPlanImpl _value, $Res Function(_$MealPlanImpl) _then)
      : super(_value, _then);

  /// Create a copy of MealPlan
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? dayplans = null,
  }) {
    return _then(_$MealPlanImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      dayplans: null == dayplans
          ? _value._dayplans
          : dayplans // ignore: cast_nullable_to_non_nullable
              as List<DayPlan>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MealPlanImpl with DiagnosticableTreeMixin implements _MealPlan {
  const _$MealPlanImpl(
      {required this.id,
      required this.name,
      required final List<DayPlan> dayplans})
      : _dayplans = dayplans;

  factory _$MealPlanImpl.fromJson(Map<String, dynamic> json) =>
      _$$MealPlanImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  final List<DayPlan> _dayplans;
  @override
  List<DayPlan> get dayplans {
    if (_dayplans is EqualUnmodifiableListView) return _dayplans;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_dayplans);
  }

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'MealPlan(id: $id, name: $name, dayplans: $dayplans)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'MealPlan'))
      ..add(DiagnosticsProperty('id', id))
      ..add(DiagnosticsProperty('name', name))
      ..add(DiagnosticsProperty('dayplans', dayplans));
  }

  /// Create a copy of MealPlan
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MealPlanImplCopyWith<_$MealPlanImpl> get copyWith =>
      __$$MealPlanImplCopyWithImpl<_$MealPlanImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MealPlanImplToJson(
      this,
    );
  }
}

abstract class _MealPlan implements MealPlan {
  const factory _MealPlan(
      {required final String id,
      required final String name,
      required final List<DayPlan> dayplans}) = _$MealPlanImpl;

  factory _MealPlan.fromJson(Map<String, dynamic> json) =
      _$MealPlanImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  List<DayPlan> get dayplans;

  /// Create a copy of MealPlan
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MealPlanImplCopyWith<_$MealPlanImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

DayPlan _$DayPlanFromJson(Map<String, dynamic> json) {
  return _DayPlan.fromJson(json);
}

/// @nodoc
mixin _$DayPlan {
  String get desc => throw _privateConstructorUsedError;
  Targets get targets => throw _privateConstructorUsedError;
  List<Meal> get meals => throw _privateConstructorUsedError;

  /// Serializes this DayPlan to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DayPlan
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DayPlanCopyWith<DayPlan> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DayPlanCopyWith<$Res> {
  factory $DayPlanCopyWith(DayPlan value, $Res Function(DayPlan) then) =
      _$DayPlanCopyWithImpl<$Res, DayPlan>;
  @useResult
  $Res call({String desc, Targets targets, List<Meal> meals});

  $TargetsCopyWith<$Res> get targets;
}

/// @nodoc
class _$DayPlanCopyWithImpl<$Res, $Val extends DayPlan>
    implements $DayPlanCopyWith<$Res> {
  _$DayPlanCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DayPlan
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? desc = null,
    Object? targets = null,
    Object? meals = null,
  }) {
    return _then(_value.copyWith(
      desc: null == desc
          ? _value.desc
          : desc // ignore: cast_nullable_to_non_nullable
              as String,
      targets: null == targets
          ? _value.targets
          : targets // ignore: cast_nullable_to_non_nullable
              as Targets,
      meals: null == meals
          ? _value.meals
          : meals // ignore: cast_nullable_to_non_nullable
              as List<Meal>,
    ) as $Val);
  }

  /// Create a copy of DayPlan
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TargetsCopyWith<$Res> get targets {
    return $TargetsCopyWith<$Res>(_value.targets, (value) {
      return _then(_value.copyWith(targets: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$DayPlanImplCopyWith<$Res> implements $DayPlanCopyWith<$Res> {
  factory _$$DayPlanImplCopyWith(
          _$DayPlanImpl value, $Res Function(_$DayPlanImpl) then) =
      __$$DayPlanImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String desc, Targets targets, List<Meal> meals});

  @override
  $TargetsCopyWith<$Res> get targets;
}

/// @nodoc
class __$$DayPlanImplCopyWithImpl<$Res>
    extends _$DayPlanCopyWithImpl<$Res, _$DayPlanImpl>
    implements _$$DayPlanImplCopyWith<$Res> {
  __$$DayPlanImplCopyWithImpl(
      _$DayPlanImpl _value, $Res Function(_$DayPlanImpl) _then)
      : super(_value, _then);

  /// Create a copy of DayPlan
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? desc = null,
    Object? targets = null,
    Object? meals = null,
  }) {
    return _then(_$DayPlanImpl(
      desc: null == desc
          ? _value.desc
          : desc // ignore: cast_nullable_to_non_nullable
              as String,
      targets: null == targets
          ? _value.targets
          : targets // ignore: cast_nullable_to_non_nullable
              as Targets,
      meals: null == meals
          ? _value._meals
          : meals // ignore: cast_nullable_to_non_nullable
              as List<Meal>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DayPlanImpl with DiagnosticableTreeMixin implements _DayPlan {
  const _$DayPlanImpl(
      {required this.desc,
      required this.targets,
      required final List<Meal> meals})
      : _meals = meals;

  factory _$DayPlanImpl.fromJson(Map<String, dynamic> json) =>
      _$$DayPlanImplFromJson(json);

  @override
  final String desc;
  @override
  final Targets targets;
  final List<Meal> _meals;
  @override
  List<Meal> get meals {
    if (_meals is EqualUnmodifiableListView) return _meals;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_meals);
  }

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'DayPlan(desc: $desc, targets: $targets, meals: $meals)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'DayPlan'))
      ..add(DiagnosticsProperty('desc', desc))
      ..add(DiagnosticsProperty('targets', targets))
      ..add(DiagnosticsProperty('meals', meals));
  }

  /// Create a copy of DayPlan
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DayPlanImplCopyWith<_$DayPlanImpl> get copyWith =>
      __$$DayPlanImplCopyWithImpl<_$DayPlanImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DayPlanImplToJson(
      this,
    );
  }
}

abstract class _DayPlan implements DayPlan {
  const factory _DayPlan(
      {required final String desc,
      required final Targets targets,
      required final List<Meal> meals}) = _$DayPlanImpl;

  factory _DayPlan.fromJson(Map<String, dynamic> json) = _$DayPlanImpl.fromJson;

  @override
  String get desc;
  @override
  Targets get targets;
  @override
  List<Meal> get meals;

  /// Create a copy of DayPlan
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DayPlanImplCopyWith<_$DayPlanImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Meal _$MealFromJson(Map<String, dynamic> json) {
  return _Meal.fromJson(json);
}

/// @nodoc
mixin _$Meal {
  String get desc => throw _privateConstructorUsedError;
  Targets get targets => throw _privateConstructorUsedError;

  /// Serializes this Meal to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Meal
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MealCopyWith<Meal> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MealCopyWith<$Res> {
  factory $MealCopyWith(Meal value, $Res Function(Meal) then) =
      _$MealCopyWithImpl<$Res, Meal>;
  @useResult
  $Res call({String desc, Targets targets});

  $TargetsCopyWith<$Res> get targets;
}

/// @nodoc
class _$MealCopyWithImpl<$Res, $Val extends Meal>
    implements $MealCopyWith<$Res> {
  _$MealCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Meal
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? desc = null,
    Object? targets = null,
  }) {
    return _then(_value.copyWith(
      desc: null == desc
          ? _value.desc
          : desc // ignore: cast_nullable_to_non_nullable
              as String,
      targets: null == targets
          ? _value.targets
          : targets // ignore: cast_nullable_to_non_nullable
              as Targets,
    ) as $Val);
  }

  /// Create a copy of Meal
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TargetsCopyWith<$Res> get targets {
    return $TargetsCopyWith<$Res>(_value.targets, (value) {
      return _then(_value.copyWith(targets: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$MealImplCopyWith<$Res> implements $MealCopyWith<$Res> {
  factory _$$MealImplCopyWith(
          _$MealImpl value, $Res Function(_$MealImpl) then) =
      __$$MealImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String desc, Targets targets});

  @override
  $TargetsCopyWith<$Res> get targets;
}

/// @nodoc
class __$$MealImplCopyWithImpl<$Res>
    extends _$MealCopyWithImpl<$Res, _$MealImpl>
    implements _$$MealImplCopyWith<$Res> {
  __$$MealImplCopyWithImpl(_$MealImpl _value, $Res Function(_$MealImpl) _then)
      : super(_value, _then);

  /// Create a copy of Meal
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? desc = null,
    Object? targets = null,
  }) {
    return _then(_$MealImpl(
      desc: null == desc
          ? _value.desc
          : desc // ignore: cast_nullable_to_non_nullable
              as String,
      targets: null == targets
          ? _value.targets
          : targets // ignore: cast_nullable_to_non_nullable
              as Targets,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MealImpl with DiagnosticableTreeMixin implements _Meal {
  const _$MealImpl({required this.desc, required this.targets});

  factory _$MealImpl.fromJson(Map<String, dynamic> json) =>
      _$$MealImplFromJson(json);

  @override
  final String desc;
  @override
  final Targets targets;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'Meal(desc: $desc, targets: $targets)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'Meal'))
      ..add(DiagnosticsProperty('desc', desc))
      ..add(DiagnosticsProperty('targets', targets));
  }

  /// Create a copy of Meal
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MealImplCopyWith<_$MealImpl> get copyWith =>
      __$$MealImplCopyWithImpl<_$MealImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MealImplToJson(
      this,
    );
  }
}

abstract class _Meal implements Meal {
  const factory _Meal(
      {required final String desc,
      required final Targets targets}) = _$MealImpl;

  factory _Meal.fromJson(Map<String, dynamic> json) = _$MealImpl.fromJson;

  @override
  String get desc;
  @override
  Targets get targets;

  /// Create a copy of Meal
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MealImplCopyWith<_$MealImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Targets _$TargetsFromJson(Map<String, dynamic> json) {
  return _Targets.fromJson(json);
}

/// @nodoc
mixin _$Targets {
  double get minProtein => throw _privateConstructorUsedError;
  double get maxProtein => throw _privateConstructorUsedError;
  double get minCarbs => throw _privateConstructorUsedError;
  double get maxCarbs => throw _privateConstructorUsedError;
  double get minFats => throw _privateConstructorUsedError;
  double get maxFats => throw _privateConstructorUsedError;
  double get kCal => throw _privateConstructorUsedError;

  /// Serializes this Targets to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Targets
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TargetsCopyWith<Targets> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TargetsCopyWith<$Res> {
  factory $TargetsCopyWith(Targets value, $Res Function(Targets) then) =
      _$TargetsCopyWithImpl<$Res, Targets>;
  @useResult
  $Res call(
      {double minProtein,
      double maxProtein,
      double minCarbs,
      double maxCarbs,
      double minFats,
      double maxFats,
      double kCal});
}

/// @nodoc
class _$TargetsCopyWithImpl<$Res, $Val extends Targets>
    implements $TargetsCopyWith<$Res> {
  _$TargetsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Targets
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? minProtein = null,
    Object? maxProtein = null,
    Object? minCarbs = null,
    Object? maxCarbs = null,
    Object? minFats = null,
    Object? maxFats = null,
    Object? kCal = null,
  }) {
    return _then(_value.copyWith(
      minProtein: null == minProtein
          ? _value.minProtein
          : minProtein // ignore: cast_nullable_to_non_nullable
              as double,
      maxProtein: null == maxProtein
          ? _value.maxProtein
          : maxProtein // ignore: cast_nullable_to_non_nullable
              as double,
      minCarbs: null == minCarbs
          ? _value.minCarbs
          : minCarbs // ignore: cast_nullable_to_non_nullable
              as double,
      maxCarbs: null == maxCarbs
          ? _value.maxCarbs
          : maxCarbs // ignore: cast_nullable_to_non_nullable
              as double,
      minFats: null == minFats
          ? _value.minFats
          : minFats // ignore: cast_nullable_to_non_nullable
              as double,
      maxFats: null == maxFats
          ? _value.maxFats
          : maxFats // ignore: cast_nullable_to_non_nullable
              as double,
      kCal: null == kCal
          ? _value.kCal
          : kCal // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TargetsImplCopyWith<$Res> implements $TargetsCopyWith<$Res> {
  factory _$$TargetsImplCopyWith(
          _$TargetsImpl value, $Res Function(_$TargetsImpl) then) =
      __$$TargetsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {double minProtein,
      double maxProtein,
      double minCarbs,
      double maxCarbs,
      double minFats,
      double maxFats,
      double kCal});
}

/// @nodoc
class __$$TargetsImplCopyWithImpl<$Res>
    extends _$TargetsCopyWithImpl<$Res, _$TargetsImpl>
    implements _$$TargetsImplCopyWith<$Res> {
  __$$TargetsImplCopyWithImpl(
      _$TargetsImpl _value, $Res Function(_$TargetsImpl) _then)
      : super(_value, _then);

  /// Create a copy of Targets
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? minProtein = null,
    Object? maxProtein = null,
    Object? minCarbs = null,
    Object? maxCarbs = null,
    Object? minFats = null,
    Object? maxFats = null,
    Object? kCal = null,
  }) {
    return _then(_$TargetsImpl(
      minProtein: null == minProtein
          ? _value.minProtein
          : minProtein // ignore: cast_nullable_to_non_nullable
              as double,
      maxProtein: null == maxProtein
          ? _value.maxProtein
          : maxProtein // ignore: cast_nullable_to_non_nullable
              as double,
      minCarbs: null == minCarbs
          ? _value.minCarbs
          : minCarbs // ignore: cast_nullable_to_non_nullable
              as double,
      maxCarbs: null == maxCarbs
          ? _value.maxCarbs
          : maxCarbs // ignore: cast_nullable_to_non_nullable
              as double,
      minFats: null == minFats
          ? _value.minFats
          : minFats // ignore: cast_nullable_to_non_nullable
              as double,
      maxFats: null == maxFats
          ? _value.maxFats
          : maxFats // ignore: cast_nullable_to_non_nullable
              as double,
      kCal: null == kCal
          ? _value.kCal
          : kCal // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TargetsImpl with DiagnosticableTreeMixin implements _Targets {
  const _$TargetsImpl(
      {required this.minProtein,
      required this.maxProtein,
      required this.minCarbs,
      required this.maxCarbs,
      required this.minFats,
      required this.maxFats,
      required this.kCal});

  factory _$TargetsImpl.fromJson(Map<String, dynamic> json) =>
      _$$TargetsImplFromJson(json);

  @override
  final double minProtein;
  @override
  final double maxProtein;
  @override
  final double minCarbs;
  @override
  final double maxCarbs;
  @override
  final double minFats;
  @override
  final double maxFats;
  @override
  final double kCal;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'Targets(minProtein: $minProtein, maxProtein: $maxProtein, minCarbs: $minCarbs, maxCarbs: $maxCarbs, minFats: $minFats, maxFats: $maxFats, kCal: $kCal)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'Targets'))
      ..add(DiagnosticsProperty('minProtein', minProtein))
      ..add(DiagnosticsProperty('maxProtein', maxProtein))
      ..add(DiagnosticsProperty('minCarbs', minCarbs))
      ..add(DiagnosticsProperty('maxCarbs', maxCarbs))
      ..add(DiagnosticsProperty('minFats', minFats))
      ..add(DiagnosticsProperty('maxFats', maxFats))
      ..add(DiagnosticsProperty('kCal', kCal));
  }

  /// Create a copy of Targets
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TargetsImplCopyWith<_$TargetsImpl> get copyWith =>
      __$$TargetsImplCopyWithImpl<_$TargetsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TargetsImplToJson(
      this,
    );
  }
}

abstract class _Targets implements Targets {
  const factory _Targets(
      {required final double minProtein,
      required final double maxProtein,
      required final double minCarbs,
      required final double maxCarbs,
      required final double minFats,
      required final double maxFats,
      required final double kCal}) = _$TargetsImpl;

  factory _Targets.fromJson(Map<String, dynamic> json) = _$TargetsImpl.fromJson;

  @override
  double get minProtein;
  @override
  double get maxProtein;
  @override
  double get minCarbs;
  @override
  double get maxCarbs;
  @override
  double get minFats;
  @override
  double get maxFats;
  @override
  double get kCal;

  /// Create a copy of Targets
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TargetsImplCopyWith<_$TargetsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
