import 'package:bodybuild/model/programmer/set_group.dart';
import 'package:bodybuild/model/workouts/workout.dart' as model;
import 'package:bodybuild/ui/workouts/widget/edit_exercise_set_group_sheet.dart';
import 'package:bodybuild/ui/workouts/widget/set_log_widget.dart';
import 'package:bodybuild/util/string_extension.dart';
import 'package:flutter/material.dart';

/// Widget to display a group of sets for the same exercise+tweaks combination
/// Supports editing exercise/tweaks and managing individual sets
class ExerciseSetGroupWidget extends StatelessWidget {
  final model.ExerciseSetGroup group;
  final void Function(model.WorkoutSet) onUpdateSet;
  final void Function(model.ExerciseSetGroup, Sets) onUpdateExercise; // TODO not used i think
  final void Function(String setId) onDeleteSet;

  const ExerciseSetGroupWidget({
    super.key,
    required this.group,
    required this.onUpdateSet,
    required this.onUpdateExercise,
    required this.onDeleteSet,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _showEditExerciseDialog(context),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              if (group.tweaks.isNotEmpty) ...[const SizedBox(height: 8), _buildTweaks(context)],
              const SizedBox(height: 12),
              ...group.sets.map((set) {
                return SetLogWidget(workoutSet: set);
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Text(
      group.exerciseId,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
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

  void _showEditExerciseDialog(BuildContext context) async {
    final result = await showModalBottomSheet<EditExerciseSetGroupSheetResponse>(
      context: context,
      isScrollControlled: true,
      builder: (context) =>
          EditExerciseSetGroupSheet(group.sets.firstOrNull!.workoutId, group: group),
    );

    if (result == null || !context.mounted) return;

    // Process deletes
    result.deletedSetIds.forEach(onDeleteSet);
    // Re-save our sets. They may have been updated.
    result.sets.forEach(onUpdateSet);
  }
}
