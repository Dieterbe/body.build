// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'program_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProgramStateImpl _$$ProgramStateImplFromJson(Map<String, dynamic> json) =>
    _$ProgramStateImpl(
      name: json['name'] as String? ?? 'unnamed program',
      workouts: (json['workouts'] as List<dynamic>?)
              ?.map((e) => Workout.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$ProgramStateImplToJson(_$ProgramStateImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'workouts': instance.workouts,
    };
