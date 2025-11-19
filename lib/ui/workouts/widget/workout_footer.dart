import 'package:flutter/material.dart';
import 'package:bodybuild/model/workouts/workout.dart' as model;
import 'package:bodybuild/ui/workouts/widget/stopwatch.dart';

class WorkoutFooter extends StatelessWidget {
  const WorkoutFooter({super.key, required this.workout});

  final model.Workout workout;

  @override
  Widget build(BuildContext context) {
    if (!workout.sets.any((s) => s.completed) || !workout.isActive) {
      return Container();
    }
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(Icons.timer, color: Theme.of(context).colorScheme.onPrimaryContainer, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Approx. rest time',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
                Stopwatch(
                  start: workout.sets.where((s) => s.completed).lastOrNull!.timestamp,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
