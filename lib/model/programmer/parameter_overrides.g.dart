// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'parameter_overrides.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MuscleGroupOverride _$MuscleGroupOverrideFromJson(Map<String, dynamic> json) =>
    _MuscleGroupOverride(
      $enumDecode(_$ProgramGroupEnumMap, json['group']),
      (json['sets'] as num).toInt(),
    );

Map<String, dynamic> _$MuscleGroupOverrideToJson(_MuscleGroupOverride instance) =>
    <String, dynamic>{'group': _$ProgramGroupEnumMap[instance.group]!, 'sets': instance.sets};

const _$ProgramGroupEnumMap = {
  ProgramGroup.wristFlexors: 'wristFlexors',
  ProgramGroup.wristExtensors: 'wristExtensors',
  ProgramGroup.lowerPecs: 'lowerPecs',
  ProgramGroup.upperPecs: 'upperPecs',
  ProgramGroup.frontDelts: 'frontDelts',
  ProgramGroup.sideDelts: 'sideDelts',
  ProgramGroup.rearDelts: 'rearDelts',
  ProgramGroup.lowerTraps: 'lowerTraps',
  ProgramGroup.middleTraps: 'middleTraps',
  ProgramGroup.upperTraps: 'upperTraps',
  ProgramGroup.lats: 'lats',
  ProgramGroup.biceps: 'biceps',
  ProgramGroup.tricepsMedLatH: 'tricepsMedLatH',
  ProgramGroup.tricepsLongHead: 'tricepsLongHead',
  ProgramGroup.abs: 'abs',
  ProgramGroup.spinalErectors: 'spinalErectors',
  ProgramGroup.quadsVasti: 'quadsVasti',
  ProgramGroup.quadsRF: 'quadsRF',
  ProgramGroup.hams: 'hams',
  ProgramGroup.hamsShortHead: 'hamsShortHead',
  ProgramGroup.gluteMax: 'gluteMax',
  ProgramGroup.gluteMed: 'gluteMed',
  ProgramGroup.gastroc: 'gastroc',
  ProgramGroup.soleus: 'soleus',
};

_ParameterOverrides _$ParameterOverridesFromJson(Map<String, dynamic> json) => _ParameterOverrides(
  intensities: (json['intensities'] as List<dynamic>?)?.map((e) => (e as num).toInt()).toList(),
  setsPerWeekPerMuscleGroup: (json['setsPerWeekPerMuscleGroup'] as num?)?.toInt(),
  setsPerWeekPerMuscleGroupIndividual:
      (json['setsPerWeekPerMuscleGroupIndividual'] as List<dynamic>?)
          ?.map((e) => MuscleGroupOverride.fromJson(e as Map<String, dynamic>))
          .toList(),
  excludedExercises: _exSetFromJson(json['excludedExercises'] as List?),
);

Map<String, dynamic> _$ParameterOverridesToJson(_ParameterOverrides instance) => <String, dynamic>{
  'intensities': instance.intensities,
  'setsPerWeekPerMuscleGroup': instance.setsPerWeekPerMuscleGroup,
  'setsPerWeekPerMuscleGroupIndividual': instance.setsPerWeekPerMuscleGroupIndividual,
  'excludedExercises': _exSetToJson(instance.excludedExercises),
};
