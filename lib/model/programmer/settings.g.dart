// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SettingsImpl _$$SettingsImplFromJson(Map<String, dynamic> json) =>
    _$SettingsImpl(
      level:
          $enumDecodeNullable(_$LevelEnumMap, json['level']) ?? Level.beginner,
      sex: $enumDecodeNullable(_$SexEnumMap, json['sex']) ?? Sex.male,
      availEquipment: json['availEquipment'] == null
          ? const {}
          : _equipmentSetFromJson(json['availEquipment'] as List),
      age: (json['age'] as num?)?.toDouble() ?? 30,
      weight: (json['weight'] as num?)?.toDouble() ?? 75,
      height: (json['height'] as num?)?.toDouble() ?? 178,
      bodyFat: (json['bodyFat'] as num?)?.toDouble() ?? null,
      energyBalance: (json['energyBalance'] as num?)?.toInt() ?? 100,
      recoveryFactor: (json['recoveryFactor'] as num?)?.toDouble() ?? 1.0,
      workoutsPerWeek: (json['workoutsPerWeek'] as num?)?.toInt() ?? 3,
      bmrMethod: $enumDecodeNullable(_$BMRMethodEnumMap, json['bmrMethod']) ??
          BMRMethod.tenHaaf,
      activityLevel:
          $enumDecodeNullable(_$ActivityLevelEnumMap, json['activityLevel']) ??
              ActivityLevel.sedentary,
      paramSuggest:
          Parameters.fromJson(json['paramSuggest'] as Map<String, dynamic>),
      paramOverrides: ParameterOverrides.fromJson(
          json['paramOverrides'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$SettingsImplToJson(_$SettingsImpl instance) =>
    <String, dynamic>{
      'level': _$LevelEnumMap[instance.level]!,
      'sex': _$SexEnumMap[instance.sex]!,
      'availEquipment': _equipmentSetToJson(instance.availEquipment),
      'age': instance.age,
      'weight': instance.weight,
      'height': instance.height,
      'bodyFat': instance.bodyFat,
      'energyBalance': instance.energyBalance,
      'recoveryFactor': instance.recoveryFactor,
      'workoutsPerWeek': instance.workoutsPerWeek,
      'bmrMethod': _$BMRMethodEnumMap[instance.bmrMethod]!,
      'activityLevel': _$ActivityLevelEnumMap[instance.activityLevel]!,
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

const _$BMRMethodEnumMap = {
  BMRMethod.cunningham: 'cunningham',
  BMRMethod.tinsley: 'tinsley',
  BMRMethod.tenHaaf: 'tenHaaf',
};

const _$ActivityLevelEnumMap = {
  ActivityLevel.sedentary: 'sedentary',
  ActivityLevel.somewhatActive: 'somewhatActive',
  ActivityLevel.active: 'active',
  ActivityLevel.veryActive: 'veryActive',
};
