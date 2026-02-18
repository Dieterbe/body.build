// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'program_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProgramState _$ProgramStateFromJson(Map<String, dynamic> json) =>
    _ProgramState(
      name: json['name'] as String? ?? 'unnamed program',
      workouts:
          (json['workouts'] as List<dynamic>?)
              ?.map((e) => Workout.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      builtin: json['builtin'] as bool? ?? false,
    );

Map<String, dynamic> _$ProgramStateToJson(_ProgramState instance) =>
    <String, dynamic>{
      'name': instance.name,
      'workouts': instance.workouts,
      'builtin': instance.builtin,
    };
