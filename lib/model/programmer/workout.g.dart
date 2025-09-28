// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workout.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Workout _$WorkoutFromJson(Map<String, dynamic> json) => _Workout(
  name: json['name'] as String? ?? 'unnamed workout',
  setGroups:
      (json['setGroups'] as List<dynamic>?)
          ?.map((e) => SetGroup.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  timesPerPeriod: (json['timesPerPeriod'] as num?)?.toInt() ?? 1,
  periodWeeks: (json['periodWeeks'] as num?)?.toInt() ?? 1,
);

Map<String, dynamic> _$WorkoutToJson(_Workout instance) => <String, dynamic>{
  'name': instance.name,
  'setGroups': instance.setGroups,
  'timesPerPeriod': instance.timesPerPeriod,
  'periodWeeks': instance.periodWeeks,
};
