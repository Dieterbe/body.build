// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meal_plan.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MealPlanImpl _$$MealPlanImplFromJson(Map<String, dynamic> json) =>
    _$MealPlanImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      dayplans: (json['dayplans'] as List<dynamic>)
          .map((e) => DayPlan.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$MealPlanImplToJson(_$MealPlanImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'dayplans': instance.dayplans,
    };

_$DayPlanImpl _$$DayPlanImplFromJson(Map<String, dynamic> json) =>
    _$DayPlanImpl(
      desc: json['desc'] as String,
      targets: Targets.fromJson(json['targets'] as Map<String, dynamic>),
      meals: (json['meals'] as List<dynamic>)
          .map((e) => Meal.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$DayPlanImplToJson(_$DayPlanImpl instance) =>
    <String, dynamic>{
      'desc': instance.desc,
      'targets': instance.targets,
      'meals': instance.meals,
    };

_$MealImpl _$$MealImplFromJson(Map<String, dynamic> json) => _$MealImpl(
      desc: json['desc'] as String,
      targets: Targets.fromJson(json['targets'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$MealImplToJson(_$MealImpl instance) =>
    <String, dynamic>{
      'desc': instance.desc,
      'targets': instance.targets,
    };

_$TargetsImpl _$$TargetsImplFromJson(Map<String, dynamic> json) =>
    _$TargetsImpl(
      minProtein: (json['minProtein'] as num).toDouble(),
      maxProtein: (json['maxProtein'] as num).toDouble(),
      minCarbs: (json['minCarbs'] as num).toDouble(),
      maxCarbs: (json['maxCarbs'] as num).toDouble(),
      minFats: (json['minFats'] as num).toDouble(),
      maxFats: (json['maxFats'] as num).toDouble(),
      kCal: (json['kCal'] as num).toDouble(),
    );

Map<String, dynamic> _$$TargetsImplToJson(_$TargetsImpl instance) =>
    <String, dynamic>{
      'minProtein': instance.minProtein,
      'maxProtein': instance.maxProtein,
      'minCarbs': instance.minCarbs,
      'maxCarbs': instance.maxCarbs,
      'minFats': instance.minFats,
      'maxFats': instance.maxFats,
      'kCal': instance.kCal,
    };
