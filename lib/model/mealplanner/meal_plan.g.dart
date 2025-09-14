// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meal_plan.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MealPlanImpl _$$MealPlanImplFromJson(Map<String, dynamic> json) => _$MealPlanImpl(
      name: json['name'] as String,
      dayplans: (json['dayplans'] as List<dynamic>?)
              ?.map((e) => DayPlan.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <DayPlan>[],
      calorieCycling: $enumDecodeNullable(_$CalorieCyclingTypeEnumMap, json['calorieCycling']) ??
          CalorieCyclingType.off,
      mealsPerDay: (json['mealsPerDay'] as num?)?.toInt() ?? 4,
      trainingDaysPerWeek: (json['trainingDaysPerWeek'] as num?)?.toInt() ?? 3,
    );

Map<String, dynamic> _$$MealPlanImplToJson(_$MealPlanImpl instance) => <String, dynamic>{
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

_$DayPlanImpl _$$DayPlanImplFromJson(Map<String, dynamic> json) => _$DayPlanImpl(
      desc: json['desc'] as String,
      targets: Targets.fromJson(json['targets'] as Map<String, dynamic>),
      events: (json['events'] as List<dynamic>)
          .map((e) => Event.fromJson(e as Map<String, dynamic>))
          .toList(),
      num: (json['num'] as num?)?.toInt() ?? 1,
    );

Map<String, dynamic> _$$DayPlanImplToJson(_$DayPlanImpl instance) => <String, dynamic>{
      'desc': instance.desc,
      'targets': instance.targets,
      'events': instance.events,
      'num': instance.num,
    };

_$MealEventImpl _$$MealEventImplFromJson(Map<String, dynamic> json) => _$MealEventImpl(
      desc: json['desc'] as String,
      targets: Targets.fromJson(json['targets'] as Map<String, dynamic>),
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$MealEventImplToJson(_$MealEventImpl instance) => <String, dynamic>{
      'desc': instance.desc,
      'targets': instance.targets,
      'runtimeType': instance.$type,
    };

_$StrengthWorkoutEventImpl _$$StrengthWorkoutEventImplFromJson(Map<String, dynamic> json) =>
    _$StrengthWorkoutEventImpl(
      desc: json['desc'] as String,
      estimatedKcal: (json['estimatedKcal'] as num).toDouble(),
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$StrengthWorkoutEventImplToJson(_$StrengthWorkoutEventImpl instance) =>
    <String, dynamic>{
      'desc': instance.desc,
      'estimatedKcal': instance.estimatedKcal,
      'runtimeType': instance.$type,
    };

_$TargetsImpl _$$TargetsImplFromJson(Map<String, dynamic> json) => _$TargetsImpl(
      minProtein: (json['minProtein'] as num).toDouble(),
      maxProtein: (json['maxProtein'] as num).toDouble(),
      minCarbs: (json['minCarbs'] as num).toDouble(),
      maxCarbs: (json['maxCarbs'] as num).toDouble(),
      minFats: (json['minFats'] as num).toDouble(),
      maxFats: (json['maxFats'] as num).toDouble(),
      kCal: (json['kCal'] as num).toDouble(),
    );

Map<String, dynamic> _$$TargetsImplToJson(_$TargetsImpl instance) => <String, dynamic>{
      'minProtein': instance.minProtein,
      'maxProtein': instance.maxProtein,
      'minCarbs': instance.minCarbs,
      'maxCarbs': instance.maxCarbs,
      'minFats': instance.minFats,
      'maxFats': instance.maxFats,
      'kCal': instance.kCal,
    };
