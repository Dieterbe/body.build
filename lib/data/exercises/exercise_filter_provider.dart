import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:bodybuild/data/programmer/groups.dart';
import 'package:bodybuild/data/programmer/equipment.dart';
import 'package:bodybuild/data/programmer/exercises.dart';

part 'exercise_filter_provider.g.dart';

final allEquipment = Equipment.values
    .where(
      (eq) =>
          eq.category == EquipmentCategory.nonMachine ||
          eq.category == EquipmentCategory.generalMachines,
    )
    .toSet();

const allCategories = {
  EquipmentCategory.upperBodyMachines,
  EquipmentCategory.lowerBodyMachines,
  EquipmentCategory.coreAndGluteMachines,
};

/// Filter state class.
/// For filtering equipment, we group upperbody, lowerbody, and core/glute into their categories
/// (as to not overwhelm) whereas for for general machines and non machine equipment, we list them
/// individually.
class ExerciseFilterState {
  final bool showFilters;
  final String query;
  final ProgramGroup? selectedMuscleGroup;
  final Set<Equipment> selectedEquipment;
  final Set<EquipmentCategory> selectedEquipmentCategories;
  final Ex? selectedExercise;
  final Map<String, String> selectedTweakOptions;

  const ExerciseFilterState({
    this.showFilters = false,
    this.query = '',
    this.selectedMuscleGroup,
    this.selectedEquipment = const {},
    this.selectedEquipmentCategories = const {},
    this.selectedExercise,
    this.selectedTweakOptions = const {},
  });

  ExerciseFilterState copyWith({
    bool? showFilters,
    String? query,
    ProgramGroup? selectedMuscleGroup,
    Set<Equipment>? selectedEquipment,
    Set<EquipmentCategory>? selectedEquipmentCategories,
    Ex? selectedExercise,
    Map<String, String>? selectedTweakOptions,
    bool clearSelectedMuscleGroup = false,
    bool clearSelectedExercise = false,
  }) {
    return ExerciseFilterState(
      showFilters: showFilters ?? this.showFilters,
      query: query ?? this.query,
      selectedMuscleGroup: clearSelectedMuscleGroup
          ? null
          : (selectedMuscleGroup ?? this.selectedMuscleGroup),
      selectedEquipment: selectedEquipment ?? this.selectedEquipment,
      selectedEquipmentCategories: selectedEquipmentCategories ?? this.selectedEquipmentCategories,
      selectedExercise: clearSelectedExercise ? null : (selectedExercise ?? this.selectedExercise),
      selectedTweakOptions: selectedTweakOptions ?? this.selectedTweakOptions,
    );
  }
}

// Exercise filter notifier using Riverpod 2.0 Notifier
@riverpod
class ExerciseFilter extends _$ExerciseFilter {
  @override
  ExerciseFilterState build() {
    return ExerciseFilterState(
      selectedEquipment: allEquipment,
      selectedEquipmentCategories: allCategories,
    );
  }

  void setQuery(String query) {
    state = state.copyWith(query: query);
  }

  void setMuscleGroup(ProgramGroup? group) {
    state = state.copyWith(selectedMuscleGroup: group, clearSelectedMuscleGroup: group == null);
  }

  void toggleEquipment(Equipment equipment, bool? selected) {
    final newSelectedEquipment = Set<Equipment>.from(state.selectedEquipment);
    if (selected == true) {
      newSelectedEquipment.add(equipment);
    } else {
      newSelectedEquipment.remove(equipment);
    }
    state = state.copyWith(selectedEquipment: newSelectedEquipment);
  }

  void toggleEquipmentCategory(EquipmentCategory category, bool? selected) {
    final newSelectedCategories = Set<EquipmentCategory>.from(state.selectedEquipmentCategories);
    if (selected == true) {
      newSelectedCategories.add(category);
    } else {
      newSelectedCategories.remove(category);
    }
    state = state.copyWith(selectedEquipmentCategories: newSelectedCategories);
  }

  void setAllEquipment() {
    state = state.copyWith(
      selectedEquipment: allEquipment,
      selectedEquipmentCategories: allCategories,
    );
  }

  void setNoEquipment() {
    state = state.copyWith(
      selectedEquipment: <Equipment>{},
      selectedEquipmentCategories: <EquipmentCategory>{},
    );
  }

  void setSelectedExercise(Ex? exercise, {Map<String, String>? tweakOptions}) {
    state = state.copyWith(
      selectedExercise: exercise,
      selectedTweakOptions: tweakOptions ?? {},
      clearSelectedExercise: exercise == null,
    );
  }

  void toggleShowFilters() {
    state = state.copyWith(showFilters: !state.showFilters);
  }
}

// Provider for filtered exercises, notably ignoring 'setup' because we want to explore the whole library
// and using the custom equipment filters that use equipment categories
@riverpod
List<Ex> filteredExercises(Ref ref) {
  final filterState = ref.watch(exerciseFilterProvider);

  return getFilteredExercises(
    query: filterState.query,
    muscleGroup: filterState.selectedMuscleGroup,
    availEquipment: filterState.selectedEquipment,
    availEquipmentCategories: filterState.selectedEquipmentCategories,
  );
}
