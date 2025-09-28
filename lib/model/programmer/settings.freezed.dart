// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Settings {

 String get name;// Personal information
 Level get level; Sex get sex; double get age; double get weight; double get height; double? get bodyFat;// percentage
 int get energyBalance;// percentage (100 = maintenance)
 double get recoveryFactor;// Recovery quality factor (0.5 - 1.2)
 double get tefFactor;// Thermic effect of food
 double get atFactor;// Adaptive thermogenesis
 int get workoutsPerWeek; int get workoutDuration;// minutes
 ActivityLevel get activityLevel;// other
 BMRMethod get bmrMethod;@JsonKey(toJson: _equipmentSetToJson, fromJson: _equipmentSetFromJson) Set<Equipment> get availEquipment; Parameters get paramSuggest; ParameterOverrides get paramOverrides;
/// Create a copy of Settings
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SettingsCopyWith<Settings> get copyWith => _$SettingsCopyWithImpl<Settings>(this as Settings, _$identity);

  /// Serializes this Settings to a JSON map.
  Map<String, dynamic> toJson();




@override
String toString() {
  return 'Settings(name: $name, level: $level, sex: $sex, age: $age, weight: $weight, height: $height, bodyFat: $bodyFat, energyBalance: $energyBalance, recoveryFactor: $recoveryFactor, tefFactor: $tefFactor, atFactor: $atFactor, workoutsPerWeek: $workoutsPerWeek, workoutDuration: $workoutDuration, activityLevel: $activityLevel, bmrMethod: $bmrMethod, availEquipment: $availEquipment, paramSuggest: $paramSuggest, paramOverrides: $paramOverrides)';
}


}

/// @nodoc
abstract mixin class $SettingsCopyWith<$Res>  {
  factory $SettingsCopyWith(Settings value, $Res Function(Settings) _then) = _$SettingsCopyWithImpl;
@useResult
$Res call({
 String name, Level level, Sex sex, double age, double weight, double height, double? bodyFat, int energyBalance, double recoveryFactor, double tefFactor, double atFactor, int workoutsPerWeek, int workoutDuration, ActivityLevel activityLevel, BMRMethod bmrMethod,@JsonKey(toJson: _equipmentSetToJson, fromJson: _equipmentSetFromJson) Set<Equipment> availEquipment, Parameters paramSuggest, ParameterOverrides paramOverrides
});


$ParametersCopyWith<$Res> get paramSuggest;$ParameterOverridesCopyWith<$Res> get paramOverrides;

}
/// @nodoc
class _$SettingsCopyWithImpl<$Res>
    implements $SettingsCopyWith<$Res> {
  _$SettingsCopyWithImpl(this._self, this._then);

  final Settings _self;
  final $Res Function(Settings) _then;

/// Create a copy of Settings
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? level = null,Object? sex = null,Object? age = null,Object? weight = null,Object? height = null,Object? bodyFat = freezed,Object? energyBalance = null,Object? recoveryFactor = null,Object? tefFactor = null,Object? atFactor = null,Object? workoutsPerWeek = null,Object? workoutDuration = null,Object? activityLevel = null,Object? bmrMethod = null,Object? availEquipment = null,Object? paramSuggest = null,Object? paramOverrides = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as Level,sex: null == sex ? _self.sex : sex // ignore: cast_nullable_to_non_nullable
as Sex,age: null == age ? _self.age : age // ignore: cast_nullable_to_non_nullable
as double,weight: null == weight ? _self.weight : weight // ignore: cast_nullable_to_non_nullable
as double,height: null == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as double,bodyFat: freezed == bodyFat ? _self.bodyFat : bodyFat // ignore: cast_nullable_to_non_nullable
as double?,energyBalance: null == energyBalance ? _self.energyBalance : energyBalance // ignore: cast_nullable_to_non_nullable
as int,recoveryFactor: null == recoveryFactor ? _self.recoveryFactor : recoveryFactor // ignore: cast_nullable_to_non_nullable
as double,tefFactor: null == tefFactor ? _self.tefFactor : tefFactor // ignore: cast_nullable_to_non_nullable
as double,atFactor: null == atFactor ? _self.atFactor : atFactor // ignore: cast_nullable_to_non_nullable
as double,workoutsPerWeek: null == workoutsPerWeek ? _self.workoutsPerWeek : workoutsPerWeek // ignore: cast_nullable_to_non_nullable
as int,workoutDuration: null == workoutDuration ? _self.workoutDuration : workoutDuration // ignore: cast_nullable_to_non_nullable
as int,activityLevel: null == activityLevel ? _self.activityLevel : activityLevel // ignore: cast_nullable_to_non_nullable
as ActivityLevel,bmrMethod: null == bmrMethod ? _self.bmrMethod : bmrMethod // ignore: cast_nullable_to_non_nullable
as BMRMethod,availEquipment: null == availEquipment ? _self.availEquipment : availEquipment // ignore: cast_nullable_to_non_nullable
as Set<Equipment>,paramSuggest: null == paramSuggest ? _self.paramSuggest : paramSuggest // ignore: cast_nullable_to_non_nullable
as Parameters,paramOverrides: null == paramOverrides ? _self.paramOverrides : paramOverrides // ignore: cast_nullable_to_non_nullable
as ParameterOverrides,
  ));
}
/// Create a copy of Settings
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ParametersCopyWith<$Res> get paramSuggest {
  
  return $ParametersCopyWith<$Res>(_self.paramSuggest, (value) {
    return _then(_self.copyWith(paramSuggest: value));
  });
}/// Create a copy of Settings
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ParameterOverridesCopyWith<$Res> get paramOverrides {
  
  return $ParameterOverridesCopyWith<$Res>(_self.paramOverrides, (value) {
    return _then(_self.copyWith(paramOverrides: value));
  });
}
}


/// Adds pattern-matching-related methods to [Settings].
extension SettingsPatterns on Settings {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Settings value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Settings() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Settings value)  $default,){
final _that = this;
switch (_that) {
case _Settings():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Settings value)?  $default,){
final _that = this;
switch (_that) {
case _Settings() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  Level level,  Sex sex,  double age,  double weight,  double height,  double? bodyFat,  int energyBalance,  double recoveryFactor,  double tefFactor,  double atFactor,  int workoutsPerWeek,  int workoutDuration,  ActivityLevel activityLevel,  BMRMethod bmrMethod, @JsonKey(toJson: _equipmentSetToJson, fromJson: _equipmentSetFromJson)  Set<Equipment> availEquipment,  Parameters paramSuggest,  ParameterOverrides paramOverrides)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Settings() when $default != null:
return $default(_that.name,_that.level,_that.sex,_that.age,_that.weight,_that.height,_that.bodyFat,_that.energyBalance,_that.recoveryFactor,_that.tefFactor,_that.atFactor,_that.workoutsPerWeek,_that.workoutDuration,_that.activityLevel,_that.bmrMethod,_that.availEquipment,_that.paramSuggest,_that.paramOverrides);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  Level level,  Sex sex,  double age,  double weight,  double height,  double? bodyFat,  int energyBalance,  double recoveryFactor,  double tefFactor,  double atFactor,  int workoutsPerWeek,  int workoutDuration,  ActivityLevel activityLevel,  BMRMethod bmrMethod, @JsonKey(toJson: _equipmentSetToJson, fromJson: _equipmentSetFromJson)  Set<Equipment> availEquipment,  Parameters paramSuggest,  ParameterOverrides paramOverrides)  $default,) {final _that = this;
switch (_that) {
case _Settings():
return $default(_that.name,_that.level,_that.sex,_that.age,_that.weight,_that.height,_that.bodyFat,_that.energyBalance,_that.recoveryFactor,_that.tefFactor,_that.atFactor,_that.workoutsPerWeek,_that.workoutDuration,_that.activityLevel,_that.bmrMethod,_that.availEquipment,_that.paramSuggest,_that.paramOverrides);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  Level level,  Sex sex,  double age,  double weight,  double height,  double? bodyFat,  int energyBalance,  double recoveryFactor,  double tefFactor,  double atFactor,  int workoutsPerWeek,  int workoutDuration,  ActivityLevel activityLevel,  BMRMethod bmrMethod, @JsonKey(toJson: _equipmentSetToJson, fromJson: _equipmentSetFromJson)  Set<Equipment> availEquipment,  Parameters paramSuggest,  ParameterOverrides paramOverrides)?  $default,) {final _that = this;
switch (_that) {
case _Settings() when $default != null:
return $default(_that.name,_that.level,_that.sex,_that.age,_that.weight,_that.height,_that.bodyFat,_that.energyBalance,_that.recoveryFactor,_that.tefFactor,_that.atFactor,_that.workoutsPerWeek,_that.workoutDuration,_that.activityLevel,_that.bmrMethod,_that.availEquipment,_that.paramSuggest,_that.paramOverrides);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Settings extends Settings {
  const _Settings({this.name = 'unnamed profile', this.level = Level.beginner, this.sex = Sex.male, this.age = 30, this.weight = 75, this.height = 178, this.bodyFat = null, this.energyBalance = 100, this.recoveryFactor = 1.0, this.tefFactor = 1.2, this.atFactor = 1.0, this.workoutsPerWeek = 3, this.workoutDuration = 60, this.activityLevel = ActivityLevel.sedentary, this.bmrMethod = BMRMethod.tenHaaf, @JsonKey(toJson: _equipmentSetToJson, fromJson: _equipmentSetFromJson) final  Set<Equipment> availEquipment = const {}, required this.paramSuggest, required this.paramOverrides}): _availEquipment = availEquipment,super._();
  factory _Settings.fromJson(Map<String, dynamic> json) => _$SettingsFromJson(json);

@override@JsonKey() final  String name;
// Personal information
@override@JsonKey() final  Level level;
@override@JsonKey() final  Sex sex;
@override@JsonKey() final  double age;
@override@JsonKey() final  double weight;
@override@JsonKey() final  double height;
@override@JsonKey() final  double? bodyFat;
// percentage
@override@JsonKey() final  int energyBalance;
// percentage (100 = maintenance)
@override@JsonKey() final  double recoveryFactor;
// Recovery quality factor (0.5 - 1.2)
@override@JsonKey() final  double tefFactor;
// Thermic effect of food
@override@JsonKey() final  double atFactor;
// Adaptive thermogenesis
@override@JsonKey() final  int workoutsPerWeek;
@override@JsonKey() final  int workoutDuration;
// minutes
@override@JsonKey() final  ActivityLevel activityLevel;
// other
@override@JsonKey() final  BMRMethod bmrMethod;
 final  Set<Equipment> _availEquipment;
@override@JsonKey(toJson: _equipmentSetToJson, fromJson: _equipmentSetFromJson) Set<Equipment> get availEquipment {
  if (_availEquipment is EqualUnmodifiableSetView) return _availEquipment;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_availEquipment);
}

@override final  Parameters paramSuggest;
@override final  ParameterOverrides paramOverrides;

/// Create a copy of Settings
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SettingsCopyWith<_Settings> get copyWith => __$SettingsCopyWithImpl<_Settings>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SettingsToJson(this, );
}



@override
String toString() {
  return 'Settings(name: $name, level: $level, sex: $sex, age: $age, weight: $weight, height: $height, bodyFat: $bodyFat, energyBalance: $energyBalance, recoveryFactor: $recoveryFactor, tefFactor: $tefFactor, atFactor: $atFactor, workoutsPerWeek: $workoutsPerWeek, workoutDuration: $workoutDuration, activityLevel: $activityLevel, bmrMethod: $bmrMethod, availEquipment: $availEquipment, paramSuggest: $paramSuggest, paramOverrides: $paramOverrides)';
}


}

/// @nodoc
abstract mixin class _$SettingsCopyWith<$Res> implements $SettingsCopyWith<$Res> {
  factory _$SettingsCopyWith(_Settings value, $Res Function(_Settings) _then) = __$SettingsCopyWithImpl;
@override @useResult
$Res call({
 String name, Level level, Sex sex, double age, double weight, double height, double? bodyFat, int energyBalance, double recoveryFactor, double tefFactor, double atFactor, int workoutsPerWeek, int workoutDuration, ActivityLevel activityLevel, BMRMethod bmrMethod,@JsonKey(toJson: _equipmentSetToJson, fromJson: _equipmentSetFromJson) Set<Equipment> availEquipment, Parameters paramSuggest, ParameterOverrides paramOverrides
});


@override $ParametersCopyWith<$Res> get paramSuggest;@override $ParameterOverridesCopyWith<$Res> get paramOverrides;

}
/// @nodoc
class __$SettingsCopyWithImpl<$Res>
    implements _$SettingsCopyWith<$Res> {
  __$SettingsCopyWithImpl(this._self, this._then);

  final _Settings _self;
  final $Res Function(_Settings) _then;

/// Create a copy of Settings
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? level = null,Object? sex = null,Object? age = null,Object? weight = null,Object? height = null,Object? bodyFat = freezed,Object? energyBalance = null,Object? recoveryFactor = null,Object? tefFactor = null,Object? atFactor = null,Object? workoutsPerWeek = null,Object? workoutDuration = null,Object? activityLevel = null,Object? bmrMethod = null,Object? availEquipment = null,Object? paramSuggest = null,Object? paramOverrides = null,}) {
  return _then(_Settings(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as Level,sex: null == sex ? _self.sex : sex // ignore: cast_nullable_to_non_nullable
as Sex,age: null == age ? _self.age : age // ignore: cast_nullable_to_non_nullable
as double,weight: null == weight ? _self.weight : weight // ignore: cast_nullable_to_non_nullable
as double,height: null == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as double,bodyFat: freezed == bodyFat ? _self.bodyFat : bodyFat // ignore: cast_nullable_to_non_nullable
as double?,energyBalance: null == energyBalance ? _self.energyBalance : energyBalance // ignore: cast_nullable_to_non_nullable
as int,recoveryFactor: null == recoveryFactor ? _self.recoveryFactor : recoveryFactor // ignore: cast_nullable_to_non_nullable
as double,tefFactor: null == tefFactor ? _self.tefFactor : tefFactor // ignore: cast_nullable_to_non_nullable
as double,atFactor: null == atFactor ? _self.atFactor : atFactor // ignore: cast_nullable_to_non_nullable
as double,workoutsPerWeek: null == workoutsPerWeek ? _self.workoutsPerWeek : workoutsPerWeek // ignore: cast_nullable_to_non_nullable
as int,workoutDuration: null == workoutDuration ? _self.workoutDuration : workoutDuration // ignore: cast_nullable_to_non_nullable
as int,activityLevel: null == activityLevel ? _self.activityLevel : activityLevel // ignore: cast_nullable_to_non_nullable
as ActivityLevel,bmrMethod: null == bmrMethod ? _self.bmrMethod : bmrMethod // ignore: cast_nullable_to_non_nullable
as BMRMethod,availEquipment: null == availEquipment ? _self._availEquipment : availEquipment // ignore: cast_nullable_to_non_nullable
as Set<Equipment>,paramSuggest: null == paramSuggest ? _self.paramSuggest : paramSuggest // ignore: cast_nullable_to_non_nullable
as Parameters,paramOverrides: null == paramOverrides ? _self.paramOverrides : paramOverrides // ignore: cast_nullable_to_non_nullable
as ParameterOverrides,
  ));
}

/// Create a copy of Settings
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ParametersCopyWith<$Res> get paramSuggest {
  
  return $ParametersCopyWith<$Res>(_self.paramSuggest, (value) {
    return _then(_self.copyWith(paramSuggest: value));
  });
}/// Create a copy of Settings
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ParameterOverridesCopyWith<$Res> get paramOverrides {
  
  return $ParameterOverridesCopyWith<$Res>(_self.paramOverrides, (value) {
    return _then(_self.copyWith(paramOverrides: value));
  });
}
}

// dart format on
