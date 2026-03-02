// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workout_template.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WorkoutTemplate _$WorkoutTemplateFromJson(Map<String, dynamic> json) => _WorkoutTemplate(
  id: json['id'] as String,
  description: json['description'] as String?,
  isBuiltin: json['isBuiltin'] as bool? ?? false,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
  workout: Workout.fromJson(json['workout'] as Map<String, dynamic>),
);

Map<String, dynamic> _$WorkoutTemplateToJson(_WorkoutTemplate instance) => <String, dynamic>{
  'id': instance.id,
  'description': instance.description,
  'isBuiltin': instance.isBuiltin,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
  'workout': instance.workout,
};
