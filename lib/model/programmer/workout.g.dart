// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workout.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WorkoutImpl _$$WorkoutImplFromJson(Map<String, dynamic> json) =>
    _$WorkoutImpl(
      name: json['name'] as String? ?? 'unnamed workout',
      setGroups: (json['setGroups'] as List<dynamic>?)
              ?.map((e) => SetGroup.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      timesPerPeriod: (json['timesPerPeriod'] as num?)?.toInt() ?? 1,
      periodWeeks: (json['periodWeeks'] as num?)?.toInt() ?? 1,
    );

Map<String, dynamic> _$$WorkoutImplToJson(_$WorkoutImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'setGroups': instance.setGroups,
      'timesPerPeriod': instance.timesPerPeriod,
      'periodWeeks': instance.periodWeeks,
    };
