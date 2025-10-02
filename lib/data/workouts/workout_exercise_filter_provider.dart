import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:bodybuild/data/programmer/groups.dart';
import 'package:bodybuild/data/programmer/exercises.dart';
import 'package:bodybuild/data/programmer/setup.dart';

part 'workout_exercise_filter_provider.g.dart';

// Simple filter state for workout exercise picker
class WorkoutExerciseFilterState {
  final String query;
  final ProgramGroup? selectedMuscleGroup;
  final Set<String> expandedExercises;

  const WorkoutExerciseFilterState({
    this.query = '',
    this.selectedMuscleGroup,
    this.expandedExercises = const {},
  });

  WorkoutExerciseFilterState copyWith({
    String? query,
    ProgramGroup? selectedMuscleGroup,
    Set<String>? expandedExercises,
    bool clearSelectedMuscleGroup = false,
  }) {
    return WorkoutExerciseFilterState(
      query: query ?? this.query,
      selectedMuscleGroup: clearSelectedMuscleGroup
          ? null
          : (selectedMuscleGroup ?? this.selectedMuscleGroup),
      expandedExercises: expandedExercises ?? this.expandedExercises,
    );
  }
}

// Workout-specific exercise filter provider
@riverpod
class WorkoutExerciseFilter extends _$WorkoutExerciseFilter {
  @override
  WorkoutExerciseFilterState build() {
    return const WorkoutExerciseFilterState();
  }

  void setQuery(String query) {
    state = state.copyWith(query: query);
  }

  void setMuscleGroup(ProgramGroup? group) {
    state = state.copyWith(selectedMuscleGroup: group, clearSelectedMuscleGroup: group == null);
  }

  void toggleExerciseExpansion(String exerciseId) {
    final newExpanded = Set<String>.from(state.expandedExercises);
    if (newExpanded.contains(exerciseId)) {
      newExpanded.remove(exerciseId);
    } else {
      newExpanded.add(exerciseId);
    }
    state = state.copyWith(expandedExercises: newExpanded);
  }

  void reset() {
    state = const WorkoutExerciseFilterState();
  }
}

// Provider for filtered exercises in workout context
@riverpod
List<Ex> workoutFilteredExercises(Ref ref) {
  final filterState = ref.watch(workoutExerciseFilterProvider);
  final settings = ref.watch(setupProvider);

  return settings.when(
    data: (setup) => setup.getAvailableExercises(
      query: filterState.query,
      muscleGroup: filterState.selectedMuscleGroup,
    ),
    loading: () => <Ex>[],
    error: (_, __) => <Ex>[],
  );
}
