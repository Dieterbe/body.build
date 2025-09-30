// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workout.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Workout _$WorkoutFromJson(Map<String, dynamic> json) => _Workout(
  id: json['id'] as String,
  startTime: DateTime.parse(json['startTime'] as String),
  endTime: json['endTime'] == null
      ? null
      : DateTime.parse(json['endTime'] as String),
  notes: json['notes'] as String?,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
  sets:
      (json['sets'] as List<dynamic>?)
          ?.map((e) => WorkoutSet.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$WorkoutToJson(_Workout instance) => <String, dynamic>{
  'id': instance.id,
  'startTime': instance.startTime.toIso8601String(),
  'endTime': instance.endTime?.toIso8601String(),
  'notes': instance.notes,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
  'sets': instance.sets,
};

_WorkoutSet _$WorkoutSetFromJson(Map<String, dynamic> json) => _WorkoutSet(
  id: json['id'] as String,
  workoutId: json['workoutId'] as String,
  exerciseId: json['exerciseId'] as String,
  modifiers:
      (json['modifiers'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ) ??
      const {},
  cues:
      (json['cues'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as bool),
      ) ??
      const {},
  weight: (json['weight'] as num?)?.toDouble(),
  reps: (json['reps'] as num?)?.toInt(),
  rir: (json['rir'] as num?)?.toInt(),
  comments: json['comments'] as String?,
  timestamp: DateTime.parse(json['timestamp'] as String),
  setOrder: (json['setOrder'] as num).toInt(),
);

Map<String, dynamic> _$WorkoutSetToJson(_WorkoutSet instance) =>
    <String, dynamic>{
      'id': instance.id,
      'workoutId': instance.workoutId,
      'exerciseId': instance.exerciseId,
      'modifiers': instance.modifiers,
      'cues': instance.cues,
      'weight': instance.weight,
      'reps': instance.reps,
      'rir': instance.rir,
      'comments': instance.comments,
      'timestamp': instance.timestamp.toIso8601String(),
      'setOrder': instance.setOrder,
    };

_WorkoutState _$WorkoutStateFromJson(Map<String, dynamic> json) =>
    _WorkoutState(
      allWorkouts: (json['allWorkouts'] as List<dynamic>)
          .map((e) => Workout.fromJson(e as Map<String, dynamic>))
          .toList(),
      activeWorkout: json['activeWorkout'] == null
          ? null
          : Workout.fromJson(json['activeWorkout'] as Map<String, dynamic>),
      completedWorkouts: (json['completedWorkouts'] as List<dynamic>)
          .map((e) => Workout.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$WorkoutStateToJson(_WorkoutState instance) =>
    <String, dynamic>{
      'allWorkouts': instance.allWorkouts,
      'activeWorkout': instance.activeWorkout,
      'completedWorkouts': instance.completedWorkouts,
    };
