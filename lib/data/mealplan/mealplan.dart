import 'package:bodybuild/model/mealplanner/meal_plan.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:bodybuild/data/mealplan/mealplan_persistence_provider.dart';
import 'package:bodybuild/data/mealplan/current_mealplan_provider.dart';

part 'mealplan.g.dart';

@Riverpod(keepAlive: true)
class Mealplan extends _$Mealplan {
  @override
  Future<MealPlan> build() async {
    ref.onDispose(() {
      print('mealplan provider disposed');
    });

    // Watch the current mealplan ID to rebuild when it changes
    final currentMealplan = await ref.watch(currentMealplanProvider.future);

    // Listen to state changes and save automatically
    listenSelf((previous, next) async {
      if (next.value == null) return;
      final service = await ref.read(mealplanPersistenceProvider.future);
      await service.saveMealplan(currentMealplan, next.value!);
    });

    // Try to load saved mealplan
    final service = await ref.read(mealplanPersistenceProvider.future);
    final savedMealplan = await service.loadMealplan(currentMealplan);
    return savedMealplan ?? const MealPlan(name: 'New Mealplan');
  }

  void updateName(String name) => state = AsyncData(state.value!.copyWith(name: name));

  void updateTrainingDaysPerWeek(double trainingDaysPerWeek) =>
      state = AsyncData(state.value!.copyWith(trainingDaysPerWeek: trainingDaysPerWeek.round()));

  void addDay(DayPlan day) =>
      state = AsyncData(state.value!.copyWith(dayplans: [...state.value!.dayplans, day]));

  void updateDay(DayPlan oldDay, DayPlan newDay) {
    print('called updateDay');
    print(oldDay);
    print(newDay);
    state = AsyncData(state.value!.copyWith(
      dayplans: state.value!.dayplans.map((e) => ((e == oldDay) ? newDay : e)).toList(),
    ));
  }

  void deleteDay(DayPlan day) {
    state = AsyncData(state.value!.copyWith(
      dayplans: state.value!.dayplans.where((e) => e != day).toList(),
    ));
  }
}
