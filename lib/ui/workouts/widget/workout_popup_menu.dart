import 'dart:async';

import 'package:bodybuild/data/workouts/workout_providers.dart';
import 'package:bodybuild/model/workouts/workout.dart' as model;
import 'package:bodybuild/ui/core/confirmation_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class WorkoutPopupMenu extends ConsumerWidget {
  const WorkoutPopupMenu(this.workout, {super.key, this.reRoute});
  final model.Workout workout;
  final String? reRoute;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PopupMenuButton<String>(
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'notes',
          child: Row(spacing: 8, children: [Icon(Icons.notes_rounded), Text('Edit Notes')]),
        ),
        if (workout.isActive)
          const PopupMenuItem(
            value: 'finish',
            child: Row(spacing: 8, children: [Icon(Icons.check_circle), Text('Finish Workout')]),
          ),
        const PopupMenuItem(
          value: 'delete',
          child: Row(
            spacing: 8,
            children: [
              Icon(Icons.delete, color: Colors.red),
              Text('Delete Workout'),
            ],
          ),
        ),
      ],
      onSelected: (value) => switch (value) {
        'notes' => _showEditWorkoutNotesDialog(context, ref),
        'finish' => _showFinishWorkoutConfirmationDialog(context, ref),
        'delete' => _showDeleteWorkoutConfirmationDialog(context, ref),
        _ => null,
      },
    );
  }

  void _showFinishWorkoutConfirmationDialog(BuildContext context, WidgetRef ref) {
    showConfirmationDialog(
      context: context,
      title: 'Finish Workout',
      content: workout.sets.isEmpty
          ? 'No sets logged!. Better delete this workout instead '
                'or you know, actually do exercises first.'
          : 'Awesome work! This will finish the workout.',
      confirmText: 'Finish',
      onConfirm: () {
        ref.read(workoutManagerProvider.notifier).endWorkout(workout.id);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Workout finished')));
        if (reRoute == null) return;
        context.go(reRoute!);
      },
    );
  }

  void _showDeleteWorkoutConfirmationDialog(BuildContext context, WidgetRef ref) {
    showConfirmationDialog(
      context: context,
      title: 'Delete Workout',
      content:
          'Are you sure you want to delete this workout? '
          'This action cannot be undone.',
      confirmText: 'Delete',
      isDestructive: true,
      onConfirm: () {
        ref.read(workoutManagerProvider.notifier).deleteWorkout(workout.id);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Workout deleted')));
        if (reRoute == null) return;
        context.go(reRoute!);
      },
    );
  }

  void _showEditWorkoutNotesDialog(BuildContext context, WidgetRef ref) {
    var notesController = TextEditingController(text: workout.notes);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Workout Notes'),
        content: TextFormField(
          controller: notesController,
          decoration: const InputDecoration(
            hintText: 'Edit notes about this workout...',
            border: OutlineInputBorder(),
          ),
          maxLines: 4,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();

              unawaited(() async {
                final notes = notesController.text;
                try {
                  final workoutManager = ref.read(workoutManagerProvider.notifier);
                  await workoutManager.updateWorkoutNotes(workout.id, notes.isEmpty ? null : notes);
                } catch (e) {
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error updating notes: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }());
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
