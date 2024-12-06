// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'parameter_overrides.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MuscleGroupOverrideImpl _$$MuscleGroupOverrideImplFromJson(
        Map<String, dynamic> json) =>
    _$MuscleGroupOverrideImpl(
      $enumDecode(_$ProgramGroupEnumMap, json['group']),
      (json['sets'] as num).toInt(),
    );

Map<String, dynamic> _$$MuscleGroupOverrideImplToJson(
        _$MuscleGroupOverrideImpl instance) =>
    <String, dynamic>{
      'group': _$ProgramGroupEnumMap[instance.group]!,
      'sets': instance.sets,
    };

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

_$ParameterOverridesImpl _$$ParameterOverridesImplFromJson(
        Map<String, dynamic> json) =>
    _$ParameterOverridesImpl(
      intensities: (json['intensities'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
      setsPerWeekPerMuscleGroup:
          (json['setsPerWeekPerMuscleGroup'] as num?)?.toInt(),
      setsPerWeekPerMuscleGroupIndividual: (json[
              'setsPerWeekPerMuscleGroupIndividual'] as List<dynamic>?)
          ?.map((e) => MuscleGroupOverride.fromJson(e as Map<String, dynamic>))
          .toList(),
      excludedExercises: _exSetFromJson(json['excludedExercises'] as List?),
      excludedBases: _ebaseSetFromJson(json['excludedBases'] as List?),
    );

Map<String, dynamic> _$$ParameterOverridesImplToJson(
        _$ParameterOverridesImpl instance) =>
    <String, dynamic>{
      'intensities': instance.intensities,
      'setsPerWeekPerMuscleGroup': instance.setsPerWeekPerMuscleGroup,
      'setsPerWeekPerMuscleGroupIndividual':
          instance.setsPerWeekPerMuscleGroupIndividual,
      'excludedExercises': _exSetToJson(instance.excludedExercises),
      'excludedBases': _ebaseSetToJson(instance.excludedBases),
    };
