import 'dart:async';

import 'package:bodybuild/data/workouts/workout_providers.dart';
import 'package:bodybuild/model/workouts/workout.dart' as model;
import 'package:bodybuild/ui/core/confirmation_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class WorkoutPopupMenu extends ConsumerWidget {
  const WorkoutPopupMenu(this.workout, {super.key, this.reRoute, this.menuKey});
  final model.Workout workout;
  final String? reRoute;
  final GlobalKey<PopupMenuButtonState<String>>? menuKey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // when we autoclose due to threshold breach, we add the buffer to the end time
    // so we need to adjust our check accordingly, otherwise we allow a resume, and it
    // would be auto-closed again immediately.
    final bool canResume =
        workout.endTime != null &&
        DateTime.now().difference(workout.endTime!) <
            WorkoutManager.autoCloseThreshold - WorkoutManager.autoCloseBuffer;

    return PopupMenuButton<String>(
      key: menuKey,
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
        if (canResume)
          const PopupMenuItem(
            value: 'resume',
            child: Row(spacing: 8, children: [Icon(Icons.play_arrow), Text('Resume Workout')]),
          ),
        if (!workout.isActive && workout.sets.isNotEmpty)
          const PopupMenuItem(
            value: 'saveAsTemplate',
            child: Row(spacing: 8, children: [Icon(Icons.library_add), Text('Save as Template')]),
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
        'resume' => _showResumeWorkoutConfirmationDialog(context, ref),
        'saveAsTemplate' => _showSaveAsTemplateDialog(context, ref),
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
        ref.read(workoutManagerProvider.notifier).endWorkout(workout.id, DateTime.now());
        if (reRoute == null) return;
        context.go(reRoute!);
      },
    );
  }

  void _showResumeWorkoutConfirmationDialog(BuildContext context, WidgetRef ref) {
    showConfirmationDialog(
      context: context,
      title: 'Resume Workout',
      content: 'So you decided to do some more sets in this workout? Right on!',
      confirmText: 'Resume',
      onConfirm: () {
        ref.read(workoutManagerProvider.notifier).resumeWorkout(workout.id);
        context.go('/workouts/${workout.id}');
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

  void _showSaveAsTemplateDialog(BuildContext context, WidgetRef ref) {
    var nameController = TextEditingController(text: workout.startTime.toString().split(' ')[0]);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Save as Template'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Create a template from this workout for future use.'),
            const SizedBox(height: 16),
            TextFormField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Template Name',
                hintText: 'Enter a name for this template...',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();

              unawaited(() async {
                final name = nameController.text.trim();
                if (name.isEmpty) {
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please enter a template name'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                try {
                  final templateManager = ref.read(templateManagerProvider.notifier);
                  await templateManager.saveWorkoutAsTemplate(workout, name: name);

                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Template "$name" saved successfully'),
                      backgroundColor: Colors.green,
                    ),
                  );
                } catch (e) {
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error saving template: $e'),
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
