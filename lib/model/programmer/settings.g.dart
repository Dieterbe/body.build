// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SettingsImpl _$$SettingsImplFromJson(Map<String, dynamic> json) => _$SettingsImpl(
      name: json['name'] as String? ?? 'unnamed profile',
      level: $enumDecodeNullable(_$LevelEnumMap, json['level']) ?? Level.beginner,
      sex: $enumDecodeNullable(_$SexEnumMap, json['sex']) ?? Sex.male,
      age: (json['age'] as num?)?.toDouble() ?? 30,
      weight: (json['weight'] as num?)?.toDouble() ?? 75,
      height: (json['height'] as num?)?.toDouble() ?? 178,
      bodyFat: (json['bodyFat'] as num?)?.toDouble() ?? null,
      energyBalance: (json['energyBalance'] as num?)?.toInt() ?? 100,
      recoveryFactor: (json['recoveryFactor'] as num?)?.toDouble() ?? 1.0,
      tefFactor: (json['tefFactor'] as num?)?.toDouble() ?? 1.2,
      atFactor: (json['atFactor'] as num?)?.toDouble() ?? 1.0,
      workoutsPerWeek: (json['workoutsPerWeek'] as num?)?.toInt() ?? 3,
      workoutDuration: (json['workoutDuration'] as num?)?.toInt() ?? 60,
      activityLevel: $enumDecodeNullable(_$ActivityLevelEnumMap, json['activityLevel']) ??
          ActivityLevel.sedentary,
      bmrMethod: $enumDecodeNullable(_$BMRMethodEnumMap, json['bmrMethod']) ?? BMRMethod.tenHaaf,
      availEquipment: json['availEquipment'] == null
          ? const {}
          : _equipmentSetFromJson(json['availEquipment'] as List),
      paramSuggest: Parameters.fromJson(json['paramSuggest'] as Map<String, dynamic>),
      paramOverrides: ParameterOverrides.fromJson(json['paramOverrides'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$SettingsImplToJson(_$SettingsImpl instance) => <String, dynamic>{
      'name': instance.name,
      'level': _$LevelEnumMap[instance.level]!,
      'sex': _$SexEnumMap[instance.sex]!,
      'age': instance.age,
      'weight': instance.weight,
      'height': instance.height,
      'bodyFat': instance.bodyFat,
      'energyBalance': instance.energyBalance,
      'recoveryFactor': instance.recoveryFactor,
      'tefFactor': instance.tefFactor,
      'atFactor': instance.atFactor,
      'workoutsPerWeek': instance.workoutsPerWeek,
      'workoutDuration': instance.workoutDuration,
      'activityLevel': _$ActivityLevelEnumMap[instance.activityLevel]!,
      'bmrMethod': _$BMRMethodEnumMap[instance.bmrMethod]!,
      'availEquipment': _equipmentSetToJson(instance.availEquipment),
      'paramSuggest': instance.paramSuggest,
      'paramOverrides': instance.paramOverrides,
    };

const _$LevelEnumMap = {
  Level.beginner: 'beginner',
  Level.intermediate: 'intermediate',
  Level.advanced: 'advanced',
  Level.elite: 'elite',
};

const _$SexEnumMap = {
  Sex.male: 'male',
  Sex.female: 'female',
};

const _$ActivityLevelEnumMap = {
  ActivityLevel.sedentary: 'sedentary',
  ActivityLevel.somewhatActive: 'somewhatActive',
  ActivityLevel.active: 'active',
  ActivityLevel.veryActive: 'veryActive',
};

const _$BMRMethodEnumMap = {
  BMRMethod.cunningham: 'cunningham',
  BMRMethod.tinsley: 'tinsley',
  BMRMethod.tenHaaf: 'tenHaaf',
};
