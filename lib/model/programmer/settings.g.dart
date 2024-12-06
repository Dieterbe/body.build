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
      selectedEquipment: json['selectedEquipment'] == null
          ? const []
          : _equipmentListFromJson(json['selectedEquipment'] as List),
      age: (json['age'] as num?)?.toInt() ?? 30,
      weight: (json['weight'] as num?)?.toInt() ?? 75,
      height: (json['height'] as num?)?.toInt() ?? 178,
      bodyFat: (json['bodyFat'] as num?)?.toInt() ?? 15,
      energyBalance: (json['energyBalance'] as num?)?.toInt() ?? 100,
      recoveryFactor: (json['recoveryFactor'] as num?)?.toDouble() ?? 1.0,
      workoutsPerWeek: (json['workoutsPerWeek'] as num?)?.toInt() ?? 3,
      paramSuggest:
          Parameters.fromJson(json['paramSuggest'] as Map<String, dynamic>),
      paramOverrides: ParameterOverrides.fromJson(
          json['paramOverrides'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$SettingsImplToJson(_$SettingsImpl instance) =>
    <String, dynamic>{
      'level': _$LevelEnumMap[instance.level]!,
      'sex': _$SexEnumMap[instance.sex]!,
      'selectedEquipment': _equipmentListToJson(instance.selectedEquipment),
      'age': instance.age,
      'weight': instance.weight,
      'height': instance.height,
      'bodyFat': instance.bodyFat,
      'energyBalance': instance.energyBalance,
      'recoveryFactor': instance.recoveryFactor,
      'workoutsPerWeek': instance.workoutsPerWeek,
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
