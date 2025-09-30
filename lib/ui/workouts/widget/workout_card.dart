import 'package:bodybuild/data/workouts/workout_providers.dart';
import 'package:bodybuild/model/workouts/workout.dart' as model;
import 'package:bodybuild/ui/datetime.dart';
import 'package:bodybuild/ui/workouts/page/workouts_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WorkoutCard extends ConsumerWidget {
  const WorkoutCard(this.workout, {super.key});

  final model.Workout workout;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: workout.isActive ? Theme.of(context).colorScheme.primaryContainer : null,
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          backgroundColor: workout.isActive
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.primaryContainer,
          child: Text(
            '${workout.sets.length}',
            style: TextStyle(
              color: workout.isActive
                  ? Theme.of(context).colorScheme.onPrimary
                  : Theme.of(context).colorScheme.onPrimaryContainer,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          workout.isActive
              ? 'Resume Active Workout'
              : formatHumanDateTimeMinutely(workout.startTime),
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: workout.isActive ? Theme.of(context).colorScheme.onPrimaryContainer : null,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              '${workout.sets.length} sets • ${workout.exerciseIds.length} exercises',
              style: TextStyle(
                color: workout.isActive
                    ? Theme.of(context).colorScheme.onPrimaryContainer.withValues(alpha: 0.8)
                    : null,
              ),
            ),
            Text('Duration: ${formatHumanDuration2(workout.duration)}'),
            if (workout.notes?.isNotEmpty == true) ...[
              const SizedBox(height: 4),
              Text(
                workout.notes!,
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            switch (value) {
              case 'delete':
                _showDeleteConfirmation(context, ref, workout);
                break;
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete, color: Colors.red),
                  SizedBox(width: 8),
                  Text('Delete'),
                ],
              ),
            ),
          ],
        ),
        onTap: () => context.go('/${WorkoutsScreen.routeName}/${workout.id}'),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, WidgetRef ref, model.Workout workout) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Workout'),
        content: Text(
          'Are you sure you want to delete the workout from ${formatHumanDateTimeMinutely(workout.startTime)}? '
          'This action cannot be undone.',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              ref.read(workoutManagerProvider.notifier).deleteWorkout(workout.id);
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Workout deleted')));
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
