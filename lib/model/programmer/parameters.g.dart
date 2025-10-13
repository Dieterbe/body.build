// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'parameters.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Parameters _$ParametersFromJson(Map<String, dynamic> json) => _Parameters(
  intensities:
      (json['intensities'] as List<dynamic>?)?.map((e) => (e as num).toInt()).toList() ?? const [],
  setsPerweekPerMuscleGroup: (json['setsPerweekPerMuscleGroup'] as num?)?.toInt() ?? 0,
  setsPerWeekPerMuscleGroupIndividual:
      (json['setsPerWeekPerMuscleGroupIndividual'] as List<dynamic>?)
          ?.map((e) => MuscleGroupOverride.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$ParametersToJson(_Parameters instance) => <String, dynamic>{
  'intensities': instance.intensities,
  'setsPerweekPerMuscleGroup': instance.setsPerweekPerMuscleGroup,
  'setsPerWeekPerMuscleGroupIndividual': instance.setsPerWeekPerMuscleGroupIndividual,
};
