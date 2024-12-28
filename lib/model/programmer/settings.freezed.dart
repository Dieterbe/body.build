// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Settings _$SettingsFromJson(Map<String, dynamic> json) {
  return _Settings.fromJson(json);
}

/// @nodoc
mixin _$Settings {
  String get name => throw _privateConstructorUsedError; // Personal information
  Level get level => throw _privateConstructorUsedError;
  Sex get sex => throw _privateConstructorUsedError;
  double get age => throw _privateConstructorUsedError;
  double get weight => throw _privateConstructorUsedError;
  double get height => throw _privateConstructorUsedError;
  double? get bodyFat => throw _privateConstructorUsedError; // percentage
  int get energyBalance =>
      throw _privateConstructorUsedError; // percentage (100 = maintenance)
  double get recoveryFactor =>
      throw _privateConstructorUsedError; // Recovery quality factor (0.5 - 1.2)
  double get tefFactor =>
      throw _privateConstructorUsedError; // Thermic effect of food
  double get atFactor =>
      throw _privateConstructorUsedError; // Adaptive thermogenesis
  int get workoutsPerWeek => throw _privateConstructorUsedError;
  int get workoutDuration => throw _privateConstructorUsedError; // minutes
  ActivityLevel get activityLevel =>
      throw _privateConstructorUsedError; // other
  BMRMethod get bmrMethod => throw _privateConstructorUsedError;
  @JsonKey(toJson: _equipmentSetToJson, fromJson: _equipmentSetFromJson)
  Set<Equipment> get availEquipment => throw _privateConstructorUsedError;
  Parameters get paramSuggest => throw _privateConstructorUsedError;
  ParameterOverrides get paramOverrides => throw _privateConstructorUsedError;

  /// Serializes this Settings to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Settings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SettingsCopyWith<Settings> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SettingsCopyWith<$Res> {
  factory $SettingsCopyWith(Settings value, $Res Function(Settings) then) =
      _$SettingsCopyWithImpl<$Res, Settings>;
  @useResult
  $Res call(
      {String name,
      Level level,
      Sex sex,
      double age,
      double weight,
      double height,
      double? bodyFat,
      int energyBalance,
      double recoveryFactor,
      double tefFactor,
      double atFactor,
      int workoutsPerWeek,
      int workoutDuration,
      ActivityLevel activityLevel,
      BMRMethod bmrMethod,
      @JsonKey(toJson: _equipmentSetToJson, fromJson: _equipmentSetFromJson)
      Set<Equipment> availEquipment,
      Parameters paramSuggest,
      ParameterOverrides paramOverrides});

  $ParametersCopyWith<$Res> get paramSuggest;
  $ParameterOverridesCopyWith<$Res> get paramOverrides;
}

/// @nodoc
class _$SettingsCopyWithImpl<$Res, $Val extends Settings>
    implements $SettingsCopyWith<$Res> {
  _$SettingsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Settings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? level = null,
    Object? sex = null,
    Object? age = null,
    Object? weight = null,
    Object? height = null,
    Object? bodyFat = freezed,
    Object? energyBalance = null,
    Object? recoveryFactor = null,
    Object? tefFactor = null,
    Object? atFactor = null,
    Object? workoutsPerWeek = null,
    Object? workoutDuration = null,
    Object? activityLevel = null,
    Object? bmrMethod = null,
    Object? availEquipment = null,
    Object? paramSuggest = null,
    Object? paramOverrides = null,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      level: null == level
          ? _value.level
          : level // ignore: cast_nullable_to_non_nullable
              as Level,
      sex: null == sex
          ? _value.sex
          : sex // ignore: cast_nullable_to_non_nullable
              as Sex,
      age: null == age
          ? _value.age
          : age // ignore: cast_nullable_to_non_nullable
              as double,
      weight: null == weight
          ? _value.weight
          : weight // ignore: cast_nullable_to_non_nullable
              as double,
      height: null == height
          ? _value.height
          : height // ignore: cast_nullable_to_non_nullable
              as double,
      bodyFat: freezed == bodyFat
          ? _value.bodyFat
          : bodyFat // ignore: cast_nullable_to_non_nullable
              as double?,
      energyBalance: null == energyBalance
          ? _value.energyBalance
          : energyBalance // ignore: cast_nullable_to_non_nullable
              as int,
      recoveryFactor: null == recoveryFactor
          ? _value.recoveryFactor
          : recoveryFactor // ignore: cast_nullable_to_non_nullable
              as double,
      tefFactor: null == tefFactor
          ? _value.tefFactor
          : tefFactor // ignore: cast_nullable_to_non_nullable
              as double,
      atFactor: null == atFactor
          ? _value.atFactor
          : atFactor // ignore: cast_nullable_to_non_nullable
              as double,
      workoutsPerWeek: null == workoutsPerWeek
          ? _value.workoutsPerWeek
          : workoutsPerWeek // ignore: cast_nullable_to_non_nullable
              as int,
      workoutDuration: null == workoutDuration
          ? _value.workoutDuration
          : workoutDuration // ignore: cast_nullable_to_non_nullable
              as int,
      activityLevel: null == activityLevel
          ? _value.activityLevel
          : activityLevel // ignore: cast_nullable_to_non_nullable
              as ActivityLevel,
      bmrMethod: null == bmrMethod
          ? _value.bmrMethod
          : bmrMethod // ignore: cast_nullable_to_non_nullable
              as BMRMethod,
      availEquipment: null == availEquipment
          ? _value.availEquipment
          : availEquipment // ignore: cast_nullable_to_non_nullable
              as Set<Equipment>,
      paramSuggest: null == paramSuggest
          ? _value.paramSuggest
          : paramSuggest // ignore: cast_nullable_to_non_nullable
              as Parameters,
      paramOverrides: null == paramOverrides
          ? _value.paramOverrides
          : paramOverrides // ignore: cast_nullable_to_non_nullable
              as ParameterOverrides,
    ) as $Val);
  }

  /// Create a copy of Settings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ParametersCopyWith<$Res> get paramSuggest {
    return $ParametersCopyWith<$Res>(_value.paramSuggest, (value) {
      return _then(_value.copyWith(paramSuggest: value) as $Val);
    });
  }

  /// Create a copy of Settings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ParameterOverridesCopyWith<$Res> get paramOverrides {
    return $ParameterOverridesCopyWith<$Res>(_value.paramOverrides, (value) {
      return _then(_value.copyWith(paramOverrides: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$SettingsImplCopyWith<$Res>
    implements $SettingsCopyWith<$Res> {
  factory _$$SettingsImplCopyWith(
          _$SettingsImpl value, $Res Function(_$SettingsImpl) then) =
      __$$SettingsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String name,
      Level level,
      Sex sex,
      double age,
      double weight,
      double height,
      double? bodyFat,
      int energyBalance,
      double recoveryFactor,
      double tefFactor,
      double atFactor,
      int workoutsPerWeek,
      int workoutDuration,
      ActivityLevel activityLevel,
      BMRMethod bmrMethod,
      @JsonKey(toJson: _equipmentSetToJson, fromJson: _equipmentSetFromJson)
      Set<Equipment> availEquipment,
      Parameters paramSuggest,
      ParameterOverrides paramOverrides});

  @override
  $ParametersCopyWith<$Res> get paramSuggest;
  @override
  $ParameterOverridesCopyWith<$Res> get paramOverrides;
}

/// @nodoc
class __$$SettingsImplCopyWithImpl<$Res>
    extends _$SettingsCopyWithImpl<$Res, _$SettingsImpl>
    implements _$$SettingsImplCopyWith<$Res> {
  __$$SettingsImplCopyWithImpl(
      _$SettingsImpl _value, $Res Function(_$SettingsImpl) _then)
      : super(_value, _then);

  /// Create a copy of Settings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? level = null,
    Object? sex = null,
    Object? age = null,
    Object? weight = null,
    Object? height = null,
    Object? bodyFat = freezed,
    Object? energyBalance = null,
    Object? recoveryFactor = null,
    Object? tefFactor = null,
    Object? atFactor = null,
    Object? workoutsPerWeek = null,
    Object? workoutDuration = null,
    Object? activityLevel = null,
    Object? bmrMethod = null,
    Object? availEquipment = null,
    Object? paramSuggest = null,
    Object? paramOverrides = null,
  }) {
    return _then(_$SettingsImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      level: null == level
          ? _value.level
          : level // ignore: cast_nullable_to_non_nullable
              as Level,
      sex: null == sex
          ? _value.sex
          : sex // ignore: cast_nullable_to_non_nullable
              as Sex,
      age: null == age
          ? _value.age
          : age // ignore: cast_nullable_to_non_nullable
              as double,
      weight: null == weight
          ? _value.weight
          : weight // ignore: cast_nullable_to_non_nullable
              as double,
      height: null == height
          ? _value.height
          : height // ignore: cast_nullable_to_non_nullable
              as double,
      bodyFat: freezed == bodyFat
          ? _value.bodyFat
          : bodyFat // ignore: cast_nullable_to_non_nullable
              as double?,
      energyBalance: null == energyBalance
          ? _value.energyBalance
          : energyBalance // ignore: cast_nullable_to_non_nullable
              as int,
      recoveryFactor: null == recoveryFactor
          ? _value.recoveryFactor
          : recoveryFactor // ignore: cast_nullable_to_non_nullable
              as double,
      tefFactor: null == tefFactor
          ? _value.tefFactor
          : tefFactor // ignore: cast_nullable_to_non_nullable
              as double,
      atFactor: null == atFactor
          ? _value.atFactor
          : atFactor // ignore: cast_nullable_to_non_nullable
              as double,
      workoutsPerWeek: null == workoutsPerWeek
          ? _value.workoutsPerWeek
          : workoutsPerWeek // ignore: cast_nullable_to_non_nullable
              as int,
      workoutDuration: null == workoutDuration
          ? _value.workoutDuration
          : workoutDuration // ignore: cast_nullable_to_non_nullable
              as int,
      activityLevel: null == activityLevel
          ? _value.activityLevel
          : activityLevel // ignore: cast_nullable_to_non_nullable
              as ActivityLevel,
      bmrMethod: null == bmrMethod
          ? _value.bmrMethod
          : bmrMethod // ignore: cast_nullable_to_non_nullable
              as BMRMethod,
      availEquipment: null == availEquipment
          ? _value._availEquipment
          : availEquipment // ignore: cast_nullable_to_non_nullable
              as Set<Equipment>,
      paramSuggest: null == paramSuggest
          ? _value.paramSuggest
          : paramSuggest // ignore: cast_nullable_to_non_nullable
              as Parameters,
      paramOverrides: null == paramOverrides
          ? _value.paramOverrides
          : paramOverrides // ignore: cast_nullable_to_non_nullable
              as ParameterOverrides,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SettingsImpl extends _Settings {
  const _$SettingsImpl(
      {this.name = 'unnamed profile',
      this.level = Level.beginner,
      this.sex = Sex.male,
      this.age = 30,
      this.weight = 75,
      this.height = 178,
      this.bodyFat = null,
      this.energyBalance = 100,
      this.recoveryFactor = 1.0,
      this.tefFactor = 1.2,
      this.atFactor = 1.0,
      this.workoutsPerWeek = 3,
      this.workoutDuration = 60,
      this.activityLevel = ActivityLevel.sedentary,
      this.bmrMethod = BMRMethod.tenHaaf,
      @JsonKey(toJson: _equipmentSetToJson, fromJson: _equipmentSetFromJson)
      final Set<Equipment> availEquipment = const {},
      required this.paramSuggest,
      required this.paramOverrides})
      : _availEquipment = availEquipment,
        super._();

  factory _$SettingsImpl.fromJson(Map<String, dynamic> json) =>
      _$$SettingsImplFromJson(json);

  @override
  @JsonKey()
  final String name;
// Personal information
  @override
  @JsonKey()
  final Level level;
  @override
  @JsonKey()
  final Sex sex;
  @override
  @JsonKey()
  final double age;
  @override
  @JsonKey()
  final double weight;
  @override
  @JsonKey()
  final double height;
  @override
  @JsonKey()
  final double? bodyFat;
// percentage
  @override
  @JsonKey()
  final int energyBalance;
// percentage (100 = maintenance)
  @override
  @JsonKey()
  final double recoveryFactor;
// Recovery quality factor (0.5 - 1.2)
  @override
  @JsonKey()
  final double tefFactor;
// Thermic effect of food
  @override
  @JsonKey()
  final double atFactor;
// Adaptive thermogenesis
  @override
  @JsonKey()
  final int workoutsPerWeek;
  @override
  @JsonKey()
  final int workoutDuration;
// minutes
  @override
  @JsonKey()
  final ActivityLevel activityLevel;
// other
  @override
  @JsonKey()
  final BMRMethod bmrMethod;
  final Set<Equipment> _availEquipment;
  @override
  @JsonKey(toJson: _equipmentSetToJson, fromJson: _equipmentSetFromJson)
  Set<Equipment> get availEquipment {
    if (_availEquipment is EqualUnmodifiableSetView) return _availEquipment;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(_availEquipment);
  }

  @override
  final Parameters paramSuggest;
  @override
  final ParameterOverrides paramOverrides;

  @override
  String toString() {
    return 'Settings(name: $name, level: $level, sex: $sex, age: $age, weight: $weight, height: $height, bodyFat: $bodyFat, energyBalance: $energyBalance, recoveryFactor: $recoveryFactor, tefFactor: $tefFactor, atFactor: $atFactor, workoutsPerWeek: $workoutsPerWeek, workoutDuration: $workoutDuration, activityLevel: $activityLevel, bmrMethod: $bmrMethod, availEquipment: $availEquipment, paramSuggest: $paramSuggest, paramOverrides: $paramOverrides)';
  }

  /// Create a copy of Settings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SettingsImplCopyWith<_$SettingsImpl> get copyWith =>
      __$$SettingsImplCopyWithImpl<_$SettingsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SettingsImplToJson(
      this,
    );
  }
}

abstract class _Settings extends Settings {
  const factory _Settings(
      {final String name,
      final Level level,
      final Sex sex,
      final double age,
      final double weight,
      final double height,
      final double? bodyFat,
      final int energyBalance,
      final double recoveryFactor,
      final double tefFactor,
      final double atFactor,
      final int workoutsPerWeek,
      final int workoutDuration,
      final ActivityLevel activityLevel,
      final BMRMethod bmrMethod,
      @JsonKey(toJson: _equipmentSetToJson, fromJson: _equipmentSetFromJson)
      final Set<Equipment> availEquipment,
      required final Parameters paramSuggest,
      required final ParameterOverrides paramOverrides}) = _$SettingsImpl;
  const _Settings._() : super._();

  factory _Settings.fromJson(Map<String, dynamic> json) =
      _$SettingsImpl.fromJson;

  @override
  String get name; // Personal information
  @override
  Level get level;
  @override
  Sex get sex;
  @override
  double get age;
  @override
  double get weight;
  @override
  double get height;
  @override
  double? get bodyFat; // percentage
  @override
  int get energyBalance; // percentage (100 = maintenance)
  @override
  double get recoveryFactor; // Recovery quality factor (0.5 - 1.2)
  @override
  double get tefFactor; // Thermic effect of food
  @override
  double get atFactor; // Adaptive thermogenesis
  @override
  int get workoutsPerWeek;
  @override
  int get workoutDuration; // minutes
  @override
  ActivityLevel get activityLevel; // other
  @override
  BMRMethod get bmrMethod;
  @override
  @JsonKey(toJson: _equipmentSetToJson, fromJson: _equipmentSetFromJson)
  Set<Equipment> get availEquipment;
  @override
  Parameters get paramSuggest;
  @override
  ParameterOverrides get paramOverrides;

  /// Create a copy of Settings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SettingsImplCopyWith<_$SettingsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
