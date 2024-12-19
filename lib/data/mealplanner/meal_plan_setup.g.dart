// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meal_plan_setup.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MealPlanSetupImpl _$$MealPlanSetupImplFromJson(Map<String, dynamic> json) =>
    _$MealPlanSetupImpl(
      weeklyKcal: (json['weeklyKcal'] as num).toInt(),
      calorieCycling: $enumDecodeNullable(
              _$CalorieCyclingTypeEnumMap, json['calorieCycling']) ??
          CalorieCyclingType.off,
      mealsPerDay: (json['mealsPerDay'] as num?)?.toInt() ?? 4,
      energyBalanceFactor:
          (json['energyBalanceFactor'] as num?)?.toDouble() ?? 1.0,
      trainingDaysPerWeek: (json['trainingDaysPerWeek'] as num?)?.toInt() ?? 3,
    );

Map<String, dynamic> _$$MealPlanSetupImplToJson(_$MealPlanSetupImpl instance) =>
    <String, dynamic>{
      'weeklyKcal': instance.weeklyKcal,
      'calorieCycling': _$CalorieCyclingTypeEnumMap[instance.calorieCycling]!,
      'mealsPerDay': instance.mealsPerDay,
      'energyBalanceFactor': instance.energyBalanceFactor,
      'trainingDaysPerWeek': instance.trainingDaysPerWeek,
    };

const _$CalorieCyclingTypeEnumMap = {
  CalorieCyclingType.off: 'off',
  CalorieCyclingType.on: 'on',
  CalorieCyclingType.psmf: 'psmf',
};

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$mealPlanSetupNotifierHash() =>
    r'f75cc701a1b1802c8faf20d1936434d5fe9e6a6f';

/// See also [MealPlanSetupNotifier].
@ProviderFor(MealPlanSetupNotifier)
final mealPlanSetupNotifierProvider =
    AutoDisposeNotifierProvider<MealPlanSetupNotifier, MealPlanSetup>.internal(
  MealPlanSetupNotifier.new,
  name: r'mealPlanSetupNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$mealPlanSetupNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$MealPlanSetupNotifier = AutoDisposeNotifier<MealPlanSetup>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
