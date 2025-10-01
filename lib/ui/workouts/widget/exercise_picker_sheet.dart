import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bodybuild/data/programmer/exercises.dart';
import 'package:bodybuild/data/programmer/setup.dart';
import 'package:bodybuild/model/programmer/settings.dart';
import 'package:bodybuild/data/workouts/workout_exercise_filter_provider.dart';
import 'package:bodybuild/ui/core/exercise_search_bar.dart';
import 'package:bodybuild/ui/core/muscle_group_selector.dart';
import 'package:bodybuild/ui/core/exercise_tile_list.dart';

class ExercisePickerSheet extends ConsumerWidget {
  final Function(String exerciseId) onExerciseSelected;

  const ExercisePickerSheet({super.key, required this.onExerciseSelected});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(setupProvider);
    final filterState = ref.watch(workoutExerciseFilterProvider);

    return settings.when(
      data: (setup) => _buildContent(context, ref, setup, filterState),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error loading exercises: $error')),
    );
  }

  Widget _buildContent(
    BuildContext context,
    WidgetRef ref,
    Settings setup,
    WorkoutExerciseFilterState filterState,
  ) {
    final availableExercises = getAvailableExercises(
      excludedExercises: setup.paramOverrides.excludedExercises,
      availEquipment: setup.availEquipment,
    );
    final filteredExercises = _filterExercises(availableExercises, filterState);

    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Expanded(
                child: Text(
                  'Select Exercise',
                  style: Theme.of(
                    context,
                  ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Search bar
          ExerciseSearchBar(
            initialValue: filterState.query,
            onChanged: (query) {
              ref.read(workoutExerciseFilterProvider.notifier).setQuery(query);
            },
          ),
          const SizedBox(height: 16),

          // Muscle group filter
          MuscleGroupSelector(
            selectedMuscleGroup: filterState.selectedMuscleGroup,
            onChanged: (group) {
              ref.read(workoutExerciseFilterProvider.notifier).setMuscleGroup(group);
            },
          ),
          const SizedBox(height: 16),

          // Exercise list
          Expanded(
            child: ExerciseTileList(
              exercises: filteredExercises,
              setup: setup,
              expandedExercises: filterState.expandedExercises,
              onToggleExpansion: (exerciseId) {
                ref
                    .read(workoutExerciseFilterProvider.notifier)
                    .toggleExerciseExpansion(exerciseId);
              },
              onExerciseSelected: (exerciseId, modifiers) {
                onExerciseSelected(exerciseId);
              },
            ),
          ),
        ],
      ),
    );
  }

  List<Ex> _filterExercises(List<Ex> exercises, WorkoutExerciseFilterState filterState) {
    var filtered = exercises;

    // Filter by search query
    if (filterState.query.isNotEmpty) {
      filtered = filtered
          .where((exercise) => exercise.id.toLowerCase().contains(filterState.query.toLowerCase()))
          .toList();
    }

    // Filter by muscle group
    if (filterState.selectedMuscleGroup != null) {
      filtered = filtered
          .where(
            (exercise) =>
                exercise.recruitmentFiltered(filterState.selectedMuscleGroup!, {}, 0.5).volume >
                0.5,
          )
          .toList();
    }

    // Sort by id
    filtered.sort((a, b) => a.id.compareTo(b.id));

    return filtered;
  }
}
