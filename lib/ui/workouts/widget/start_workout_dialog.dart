import 'package:bodybuild/data/workouts/workout_providers.dart';
import 'package:bodybuild/ui/workouts/widget/template_picker_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class StartWorkoutDialog extends ConsumerWidget {
  const StartWorkoutDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workoutStateAsync = ref.watch(workoutManagerProvider);

    return workoutStateAsync.when(
      data: (state) {
        final hasActiveWorkout = state.activeWorkout != null;

        return AlertDialog(
          title: const Text('Start Workout'),
          content: Text(
            hasActiveWorkout
                ? 'You have an active workout. What would you like to do?'
                : 'What would you like to do?',
          ),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
            if (hasActiveWorkout) ...[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  context.goNamed('workout');
                },
                child: const Text('Resume Current'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _showTemplatePickerSheet(context);
                },
                child: const Text('Load Template'),
              ),
            ] else ...[
              TextButton(
                onPressed: () async {
                  Navigator.of(context).pop();
                  await ref.read(workoutManagerProvider.notifier).startWorkout();
                  if (context.mounted) {
                    context.goNamed('workout');
                  }
                },
                child: const Text('New Empty'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _showTemplatePickerSheet(context);
                },
                child: const Text('From Template'),
              ),
            ],
          ],
        );
      },
      loading: () => AlertDialog(
        title: const Text('Start Workout'),
        content: const SizedBox(height: 50, child: Center(child: CircularProgressIndicator())),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
        ],
      ),
      error: (error, stackTrace) => AlertDialog(
        title: const Text('Error'),
        content: Text('Failed to load workout state: $error'),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Close')),
        ],
      ),
    );
  }

  void _showTemplatePickerSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const TemplatePickerSheet(),
    );
  }
}
