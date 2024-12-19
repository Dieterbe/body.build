// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'meal_plan_setup.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

MealPlanSetup _$MealPlanSetupFromJson(Map<String, dynamic> json) {
  return _MealPlanSetup.fromJson(json);
}

/// @nodoc
mixin _$MealPlanSetup {
  int get weeklyKcal => throw _privateConstructorUsedError;
  CalorieCyclingType get calorieCycling => throw _privateConstructorUsedError;
  int get mealsPerDay => throw _privateConstructorUsedError;
  double get energyBalanceFactor => throw _privateConstructorUsedError;
  int get trainingDaysPerWeek => throw _privateConstructorUsedError;

  /// Serializes this MealPlanSetup to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MealPlanSetup
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MealPlanSetupCopyWith<MealPlanSetup> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MealPlanSetupCopyWith<$Res> {
  factory $MealPlanSetupCopyWith(
          MealPlanSetup value, $Res Function(MealPlanSetup) then) =
      _$MealPlanSetupCopyWithImpl<$Res, MealPlanSetup>;
  @useResult
  $Res call(
      {int weeklyKcal,
      CalorieCyclingType calorieCycling,
      int mealsPerDay,
      double energyBalanceFactor,
      int trainingDaysPerWeek});
}

/// @nodoc
class _$MealPlanSetupCopyWithImpl<$Res, $Val extends MealPlanSetup>
    implements $MealPlanSetupCopyWith<$Res> {
  _$MealPlanSetupCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MealPlanSetup
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? weeklyKcal = null,
    Object? calorieCycling = null,
    Object? mealsPerDay = null,
    Object? energyBalanceFactor = null,
    Object? trainingDaysPerWeek = null,
  }) {
    return _then(_value.copyWith(
      weeklyKcal: null == weeklyKcal
          ? _value.weeklyKcal
          : weeklyKcal // ignore: cast_nullable_to_non_nullable
              as int,
      calorieCycling: null == calorieCycling
          ? _value.calorieCycling
          : calorieCycling // ignore: cast_nullable_to_non_nullable
              as CalorieCyclingType,
      mealsPerDay: null == mealsPerDay
          ? _value.mealsPerDay
          : mealsPerDay // ignore: cast_nullable_to_non_nullable
              as int,
      energyBalanceFactor: null == energyBalanceFactor
          ? _value.energyBalanceFactor
          : energyBalanceFactor // ignore: cast_nullable_to_non_nullable
              as double,
      trainingDaysPerWeek: null == trainingDaysPerWeek
          ? _value.trainingDaysPerWeek
          : trainingDaysPerWeek // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MealPlanSetupImplCopyWith<$Res>
    implements $MealPlanSetupCopyWith<$Res> {
  factory _$$MealPlanSetupImplCopyWith(
          _$MealPlanSetupImpl value, $Res Function(_$MealPlanSetupImpl) then) =
      __$$MealPlanSetupImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int weeklyKcal,
      CalorieCyclingType calorieCycling,
      int mealsPerDay,
      double energyBalanceFactor,
      int trainingDaysPerWeek});
}

/// @nodoc
class __$$MealPlanSetupImplCopyWithImpl<$Res>
    extends _$MealPlanSetupCopyWithImpl<$Res, _$MealPlanSetupImpl>
    implements _$$MealPlanSetupImplCopyWith<$Res> {
  __$$MealPlanSetupImplCopyWithImpl(
      _$MealPlanSetupImpl _value, $Res Function(_$MealPlanSetupImpl) _then)
      : super(_value, _then);

  /// Create a copy of MealPlanSetup
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? weeklyKcal = null,
    Object? calorieCycling = null,
    Object? mealsPerDay = null,
    Object? energyBalanceFactor = null,
    Object? trainingDaysPerWeek = null,
  }) {
    return _then(_$MealPlanSetupImpl(
      weeklyKcal: null == weeklyKcal
          ? _value.weeklyKcal
          : weeklyKcal // ignore: cast_nullable_to_non_nullable
              as int,
      calorieCycling: null == calorieCycling
          ? _value.calorieCycling
          : calorieCycling // ignore: cast_nullable_to_non_nullable
              as CalorieCyclingType,
      mealsPerDay: null == mealsPerDay
          ? _value.mealsPerDay
          : mealsPerDay // ignore: cast_nullable_to_non_nullable
              as int,
      energyBalanceFactor: null == energyBalanceFactor
          ? _value.energyBalanceFactor
          : energyBalanceFactor // ignore: cast_nullable_to_non_nullable
              as double,
      trainingDaysPerWeek: null == trainingDaysPerWeek
          ? _value.trainingDaysPerWeek
          : trainingDaysPerWeek // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MealPlanSetupImpl
    with DiagnosticableTreeMixin
    implements _MealPlanSetup {
  const _$MealPlanSetupImpl(
      {required this.weeklyKcal,
      this.calorieCycling = CalorieCyclingType.off,
      this.mealsPerDay = 4,
      this.energyBalanceFactor = 1.0,
      this.trainingDaysPerWeek = 3});

  factory _$MealPlanSetupImpl.fromJson(Map<String, dynamic> json) =>
      _$$MealPlanSetupImplFromJson(json);

  @override
  final int weeklyKcal;
  @override
  @JsonKey()
  final CalorieCyclingType calorieCycling;
  @override
  @JsonKey()
  final int mealsPerDay;
  @override
  @JsonKey()
  final double energyBalanceFactor;
  @override
  @JsonKey()
  final int trainingDaysPerWeek;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'MealPlanSetup(weeklyKcal: $weeklyKcal, calorieCycling: $calorieCycling, mealsPerDay: $mealsPerDay, energyBalanceFactor: $energyBalanceFactor, trainingDaysPerWeek: $trainingDaysPerWeek)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'MealPlanSetup'))
      ..add(DiagnosticsProperty('weeklyKcal', weeklyKcal))
      ..add(DiagnosticsProperty('calorieCycling', calorieCycling))
      ..add(DiagnosticsProperty('mealsPerDay', mealsPerDay))
      ..add(DiagnosticsProperty('energyBalanceFactor', energyBalanceFactor))
      ..add(DiagnosticsProperty('trainingDaysPerWeek', trainingDaysPerWeek));
  }

  /// Create a copy of MealPlanSetup
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MealPlanSetupImplCopyWith<_$MealPlanSetupImpl> get copyWith =>
      __$$MealPlanSetupImplCopyWithImpl<_$MealPlanSetupImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MealPlanSetupImplToJson(
      this,
    );
  }
}

abstract class _MealPlanSetup implements MealPlanSetup {
  const factory _MealPlanSetup(
      {required final int weeklyKcal,
      final CalorieCyclingType calorieCycling,
      final int mealsPerDay,
      final double energyBalanceFactor,
      final int trainingDaysPerWeek}) = _$MealPlanSetupImpl;

  factory _MealPlanSetup.fromJson(Map<String, dynamic> json) =
      _$MealPlanSetupImpl.fromJson;

  @override
  int get weeklyKcal;
  @override
  CalorieCyclingType get calorieCycling;
  @override
  int get mealsPerDay;
  @override
  double get energyBalanceFactor;
  @override
  int get trainingDaysPerWeek;

  /// Create a copy of MealPlanSetup
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MealPlanSetupImplCopyWith<_$MealPlanSetupImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
