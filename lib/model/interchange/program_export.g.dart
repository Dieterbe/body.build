// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'program_export.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProgramExport _$ProgramExportFromJson(Map<String, dynamic> json) =>
    _ProgramExport(
      formatVersion:
          (json['formatVersion'] as num?)?.toInt() ??
          programExportFormatVersion,
      exerciseDatasetVersion: (json['exerciseDatasetVersion'] as num).toInt(),
      program: ProgramState.fromJson(json['program'] as Map<String, dynamic>),
      exportedAt: json['exportedAt'] == null
          ? null
          : DateTime.parse(json['exportedAt'] as String),
      exportedFrom: json['exportedFrom'] as String?,
    );

Map<String, dynamic> _$ProgramExportToJson(_ProgramExport instance) =>
    <String, dynamic>{
      'formatVersion': instance.formatVersion,
      'exerciseDatasetVersion': instance.exerciseDatasetVersion,
      'program': instance.program,
      'exportedAt': instance.exportedAt?.toIso8601String(),
      'exportedFrom': instance.exportedFrom,
    };
