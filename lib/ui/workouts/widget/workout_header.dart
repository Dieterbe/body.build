import 'package:bodybuild/ui/datetime.dart';
import 'package:bodybuild/ui/workouts/widget/stat_chip.dart';
import 'package:flutter/material.dart';
import 'package:bodybuild/model/workouts/workout.dart' as model;

class WorkoutHeader extends StatelessWidget {
  const WorkoutHeader({super.key, required this.workout});

  final model.Workout workout;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        border: Border(
          bottom: BorderSide(color: Theme.of(context).dividerColor.withValues(alpha: 0.3)),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                workout.isActive ? Icons.play_circle_filled : Icons.check_circle,
                color: workout.isActive ? Theme.of(context).colorScheme.primary : Colors.green,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                workout.isActive ? 'Active Workout' : 'Completed Workout',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Started: ${formatHumanDateTimeMinutely(workout.startTime)}',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          if (!workout.isActive && workout.endTime != null)
            Text(
              'Ended: ${formatHumanDateTimeMinutely(workout.endTime!)}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          const SizedBox(height: 8),
          Row(
            children: [
              StatChip('${workout.sets.length} sets'),
              const SizedBox(width: 8),
              StatChip('${workout.exerciseIds.length} exercises'),
            ],
          ),
          if (workout.notes?.isNotEmpty == true) ...[
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                workout.notes!,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(fontStyle: FontStyle.italic),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
