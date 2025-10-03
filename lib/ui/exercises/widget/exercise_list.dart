import 'package:bodybuild/data/exercises/exercise_filter_provider.dart';
import 'package:bodybuild/ui/core/exercise_tile_list.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ExerciseList extends ConsumerWidget {
  const ExerciseList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filteredExercises = ref.watch(filteredExercisesProvider);
    final filterState = ref.watch(exerciseFilterProvider);
    final selectedExercise = ref.watch(
      exerciseFilterProvider.select((state) => state.selectedExercise),
    );

    return ExerciseTileList(
      exercises: filteredExercises,
      onExerciseSelected: (exerciseId, tweaks) {
        final exercise = filteredExercises.firstWhereOrNull((ex) => ex.id == exerciseId);
        if (exercise == null) return;

        // Toggle selection: if already selected, deselect
        final newSelection = selectedExercise?.id == exerciseId ? null : exercise;
        ref
            .read(exerciseFilterProvider.notifier)
            .setSelectedExercise(newSelection, tweakOptions: tweaks);
      },
      expandedExercises: filterState.expandedExercises,
      onToggleExpansion: (exerciseId) {
        ref.read(exerciseFilterProvider.notifier).toggleExerciseExpansion(exerciseId);
      },
      selectedExerciseId: selectedExercise?.id,
      showHeader: true,
    );
  }
}
