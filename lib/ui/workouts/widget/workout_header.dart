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
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        border: Border(
          bottom: BorderSide(color: Theme.of(context).colorScheme.outlineVariant, width: 2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (workout.isActive) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 4,
                    children: [
                      Text(
                        'TOTAL TIME',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.2,
                        ),
                      ),
                      Stopwatch(
                        start: workout.startTime,
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.w900,
                          color: Theme.of(context).colorScheme.onSurface,
                          height: 1.1,
                        ),
                      ),
                    ],
                  ),
                ),
                if (workout.sets.any((s) => s.completed)) ...[
                  const SizedBox(width: 24),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    spacing: 4,
                    children: [
                      Text(
                        'REST',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.2,
                        ),
                      ),
                      Stopwatch(
                        start: workout.sets.where((s) => s.completed).lastOrNull!.timestamp,
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.w900,
                          color: Theme.of(context).colorScheme.onSurface,
                          height: 1.1,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
            const SizedBox(height: 16),
            Container(height: 1, color: Theme.of(context).colorScheme.outlineVariant),
            const SizedBox(height: 16),
          ],
          Text(
            'Started: ${formatHumanDateTimeMinutely(workout.startTime)}',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (!workout.isActive && workout.endTime != null)
            Text(
              'Ended: ${formatHumanDateTimeMinutely(workout.endTime!)}',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: () => showWorkoutStatsSheet(context, workout),
              icon: const Icon(Icons.bar_chart, size: 20),
              label: const Text(
                'STATS',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900, letterSpacing: 1.2),
              ),
              style: FilledButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
            ),
          ),
          if (workout.notes?.isNotEmpty == true) ...[
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainer,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                workout.notes!,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontSize: 13,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
