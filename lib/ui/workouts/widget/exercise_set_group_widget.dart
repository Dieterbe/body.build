import 'package:bodybuild/data/dataset/exercises.dart';
import 'package:bodybuild/model/programmer/set_group.dart';
import 'package:bodybuild/model/workouts/workout.dart' as model;
import 'package:bodybuild/ui/workouts/widget/log_set_sheet.dart';
import 'package:bodybuild/ui/workouts/widget/edit_exercise_set_group_sheet.dart';
import 'package:bodybuild/ui/workouts/widget/set_log_widget.dart';
import 'package:bodybuild/util/string_extension.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

/// Widget to display a group of sets for the same exercise+tweaks combination
/// Supports editing exercise/tweaks and managing individual sets
class ExerciseSetGroupWidget extends StatelessWidget {
  final model.ExerciseSetGroup group;
  final Function(model.WorkoutSet) onUpdateSet;
  final Function(model.ExerciseSetGroup, Sets) onUpdateExercise;
  final Function(Map<String, dynamic>) onAddSet;
  final Function(String setId) onDeleteSet;

  const ExerciseSetGroupWidget({
    super.key,
    required this.group,
    required this.onUpdateSet,
    required this.onUpdateExercise,
    required this.onAddSet,
    required this.onDeleteSet,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            if (group.tweaks.isNotEmpty) ...[const SizedBox(height: 8), _buildTweaks(context)],
            const SizedBox(height: 12),
            ...group.sets.map((set) {
              return SetLogWidget(
                workoutSet: set,
                onTap: !set.completed ? () => _logPlannedSet(context, set) : null,
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            group.exerciseId,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        // Edit exercise/tweaks button
        IconButton(
          onPressed: () => _showEditExerciseDialog(context),
          icon: const Icon(Icons.edit),
          tooltip: 'Edit exercise/tweaks',
          iconSize: 20,
          style: IconButton.styleFrom(foregroundColor: Theme.of(context).colorScheme.primary),
        ),
        // Add exercise button
        IconButton(
          onPressed: () => _showAddSetSheet(context),
          icon: const Icon(Icons.add_circle_outline),
          tooltip: 'Add exercise',
          iconSize: 20,
          style: IconButton.styleFrom(foregroundColor: Theme.of(context).colorScheme.primary),
        ),
      ],
    );
  }

  Widget _buildTweaks(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: group.tweaks.entries
          .map(
            (e) => Chip(
              label: Text(
                '${e.key.capitalizeFirstOnlyButKeepAcronym()}: ${e.value}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              visualDensity: VisualDensity.compact,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
              backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
              side: BorderSide(color: Theme.of(context).dividerColor.withValues(alpha: 0.3)),
            ),
          )
          .toList(),
    );
  }

  void _showAddSetSheet(BuildContext context) async {
    final exercise = exes.firstWhereOrNull((e) => e.id == group.exerciseId);
    if (exercise == null) return;

    // Get initial values from the last set if available
    final lastSet = group.sets.lastOrNull;
    final initialWeight = lastSet?.weight;
    final initialReps = lastSet?.reps;
    final initialRir = lastSet?.rir;
    final initialComments = lastSet?.comments;

    final result = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      builder: (context) => LogSetSheet(
        initialSets: Sets(0, ex: exercise, tweakOptions: group.tweaks),
        initialWeight: initialWeight,
        initialReps: initialReps,
        initialRir: initialRir,
        initialComments: initialComments,
      ),
    );

    if (result != null && context.mounted) {
      onAddSet(result);
    }
  }

  void _showEditExerciseDialog(BuildContext context) async {
    final result = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      builder: (context) => EditExerciseSetGroupSheet(group: group),
    );

    if (result != null && context.mounted) {
      // Handle deleted sets first
      final deletedSetIds = (result['deletedSetIds'] as List?)?.cast<String>() ?? [];
      for (final setId in deletedSetIds) {
        onDeleteSet(setId);
      }

      // Handle updated sets (changes to weight, reps, RIR, comments, exercise, tweaks)
      final updatedSets = (result['updatedSets'] as List?)?.cast<model.WorkoutSet>() ?? [];
      for (final set in updatedSets) {
        onUpdateSet(set);
      }
    }
  }

  void _logPlannedSet(BuildContext context, model.WorkoutSet plannedSet) async {
    final exercise = exes.firstWhereOrNull((e) => e.id == plannedSet.exerciseId);
    if (exercise == null) return;

    final result = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      builder: (context) => LogSetSheet(
        initialSets: Sets(0, ex: exercise, tweakOptions: plannedSet.tweaks),
        initialWeight: plannedSet.weight,
        initialReps: plannedSet.reps,
        initialRir: plannedSet.rir,
        initialComments: plannedSet.comments,
      ),
    );

    if (result != null && context.mounted) {
      // Update the planned set to completed with the logged values
      final updatedSet = plannedSet.copyWith(
        weight: result['weight'] as double?,
        reps: result['reps'] as int?,
        rir: result['rir'] as int?,
        comments: result['comments'] as String?,
        completed: true,
      );
      onUpdateSet(updatedSet);
    }
  }
}
