import 'package:bodybuild/ui/datetime.dart';
import 'package:bodybuild/ui/workouts/widget/workout_stats_sheet.dart';
import 'package:bodybuild/ui/workouts/widget/stopwatch.dart';
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          workout.isActive ? Icons.play_circle_filled : Icons.check_circle,
                          color: workout.isActive
                              ? Theme.of(context).colorScheme.primary
                              : Colors.green,
                          size: 24,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          workout.isActive ? 'Active Workout' : 'Finished Workout',
                          style: Theme.of(
                            context,
                          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.only(left: 32),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Started: ${formatHumanDateTimeMinutely(workout.startTime)}',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          if (!workout.isActive && workout.endTime != null)
                            Text(
                              'Ended: ${formatHumanDateTimeMinutely(workout.endTime!)}',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (workout.isActive) ...[
                const SizedBox(width: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        spacing: 8,
                        children: [
                          Text(
                            'TOTAL',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Stopwatch(
                            start: workout.startTime,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                      if (workout.sets.any((s) => s.completed)) ...[
                        const SizedBox(height: 8),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          spacing: 8,
                          children: [
                            Text(
                              'REST',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Stopwatch(
                              start: workout.sets.where((s) => s.completed).lastOrNull!.timestamp,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: () => showWorkoutStatsSheet(context, workout),
            icon: const Icon(Icons.bar_chart),
            label: const Text('Workout Stats'),
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
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
