// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'template.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WorkoutTemplate _$WorkoutTemplateFromJson(Map<String, dynamic> json) => _WorkoutTemplate(
  id: json['id'] as String,
  name: json['name'] as String,
  description: json['description'] as String?,
  isBuiltin: json['isBuiltin'] as bool? ?? false,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
  sets:
      (json['sets'] as List<dynamic>?)
          ?.map((e) => TemplateSet.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$WorkoutTemplateToJson(_WorkoutTemplate instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'description': instance.description,
  'isBuiltin': instance.isBuiltin,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
  'sets': instance.sets,
};

_TemplateSet _$TemplateSetFromJson(Map<String, dynamic> json) => _TemplateSet(
  id: json['id'] as String,
  templateId: json['templateId'] as String,
  exerciseId: json['exerciseId'] as String,
  tweaks:
      (json['tweaks'] as Map<String, dynamic>?)?.map((k, e) => MapEntry(k, e as String)) ??
      const {},
  setOrder: (json['setOrder'] as num).toInt(),
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$TemplateSetToJson(_TemplateSet instance) => <String, dynamic>{
  'id': instance.id,
  'templateId': instance.templateId,
  'exerciseId': instance.exerciseId,
  'tweaks': instance.tweaks,
  'setOrder': instance.setOrder,
  'createdAt': instance.createdAt.toIso8601String(),
};
