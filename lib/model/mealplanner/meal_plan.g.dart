// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meal_plan.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MealPlan _$MealPlanFromJson(Map<String, dynamic> json) => _MealPlan(
  name: json['name'] as String,
  dayplans:
      (json['dayplans'] as List<dynamic>?)
          ?.map((e) => DayPlan.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <DayPlan>[],
  calorieCycling:
      $enumDecodeNullable(
        _$CalorieCyclingTypeEnumMap,
        json['calorieCycling'],
      ) ??
      CalorieCyclingType.off,
  mealsPerDay: (json['mealsPerDay'] as num?)?.toInt() ?? 4,
  trainingDaysPerWeek: (json['trainingDaysPerWeek'] as num?)?.toInt() ?? 3,
);

Map<String, dynamic> _$MealPlanToJson(_MealPlan instance) => <String, dynamic>{
  'name': instance.name,
  'dayplans': instance.dayplans,
  'calorieCycling': _$CalorieCyclingTypeEnumMap[instance.calorieCycling]!,
  'mealsPerDay': instance.mealsPerDay,
  'trainingDaysPerWeek': instance.trainingDaysPerWeek,
};

const _$CalorieCyclingTypeEnumMap = {
  CalorieCyclingType.off: 'off',
  CalorieCyclingType.on: 'on',
  CalorieCyclingType.psmf: 'psmf',
};

_DayPlan _$DayPlanFromJson(Map<String, dynamic> json) => _DayPlan(
  desc: json['desc'] as String,
  targets: Targets.fromJson(json['targets'] as Map<String, dynamic>),
  events: (json['events'] as List<dynamic>)
      .map((e) => Event.fromJson(e as Map<String, dynamic>))
      .toList(),
  num: (json['num'] as num?)?.toInt() ?? 1,
);

Map<String, dynamic> _$DayPlanToJson(_DayPlan instance) => <String, dynamic>{
  'desc': instance.desc,
  'targets': instance.targets,
  'events': instance.events,
  'num': instance.num,
};

MealEvent _$MealEventFromJson(Map<String, dynamic> json) => MealEvent(
  desc: json['desc'] as String,
  targets: Targets.fromJson(json['targets'] as Map<String, dynamic>),
  $type: json['runtimeType'] as String?,
);

Map<String, dynamic> _$MealEventToJson(MealEvent instance) => <String, dynamic>{
  'desc': instance.desc,
  'targets': instance.targets,
  'runtimeType': instance.$type,
};

StrengthWorkoutEvent _$StrengthWorkoutEventFromJson(
  Map<String, dynamic> json,
) => StrengthWorkoutEvent(
  desc: json['desc'] as String,
  estimatedKcal: (json['estimatedKcal'] as num).toDouble(),
  $type: json['runtimeType'] as String?,
);

Map<String, dynamic> _$StrengthWorkoutEventToJson(
  StrengthWorkoutEvent instance,
) => <String, dynamic>{
  'desc': instance.desc,
  'estimatedKcal': instance.estimatedKcal,
  'runtimeType': instance.$type,
};

_Targets _$TargetsFromJson(Map<String, dynamic> json) => _Targets(
  minProtein: (json['minProtein'] as num).toDouble(),
  maxProtein: (json['maxProtein'] as num).toDouble(),
  minCarbs: (json['minCarbs'] as num).toDouble(),
  maxCarbs: (json['maxCarbs'] as num).toDouble(),
  minFats: (json['minFats'] as num).toDouble(),
  maxFats: (json['maxFats'] as num).toDouble(),
  kCal: (json['kCal'] as num).toDouble(),
);

Map<String, dynamic> _$TargetsToJson(_Targets instance) => <String, dynamic>{
  'minProtein': instance.minProtein,
  'maxProtein': instance.maxProtein,
  'minCarbs': instance.minCarbs,
  'maxCarbs': instance.maxCarbs,
  'minFats': instance.minFats,
  'maxFats': instance.maxFats,
  'kCal': instance.kCal,
};
