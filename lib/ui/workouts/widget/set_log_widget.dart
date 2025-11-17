import 'package:flutter/material.dart';
import 'package:bodybuild/model/workouts/workout.dart' as model;

/// Display a logged set in a workout
/// Format: [Set number] [weight] [reps] [rir]
/// Optional comment on next line
/// Shows visual distinction between planned (uncompleted) and completed sets
class SetLogWidget extends StatelessWidget {
  final model.WorkoutSet workoutSet;
  final VoidCallback? onTap;

  const SetLogWidget({super.key, required this.workoutSet, this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isPlanned = !workoutSet.completed;
    final opacity = isPlanned ? 0.5 : 1.0;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Opacity(
        opacity: opacity,
        child: InkWell(
          onTap: isPlanned ? onTap : null,
          borderRadius: BorderRadius.circular(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Main set info line with styled chips
              Row(
                children: [
                  // Checkbox icon
                  Icon(
                    isPlanned ? Icons.check_box_outline_blank : Icons.check_box,
                    size: 20,
                    color: isPlanned
                        ? theme.colorScheme.onSurface.withValues(alpha: 0.4)
                        : theme.colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  // Set number
                  Text(
                    '${workoutSet.setOrder}',
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),

                  /* Set time
              Text(
                '${formatHumanTimeMinutely(workoutSet.timestamp)}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  fontWeight: FontWeight.w500,
                ),
              ),
              */
                  const SizedBox(width: 12),
                  // Weight
                  Expanded(
                    child: _buildDataChip(
                      context: context,
                      icon: Icons.fitness_center,
                      value: isPlanned && workoutSet.weight == null
                          ? 'Tap to log'
                          : workoutSet.weight != null
                          ? '${workoutSet.weight!.toStringAsFixed(1)} kg'
                          : '-',
                    ),
                  ),
                  const SizedBox(width: 6),
                  // Reps
                  Expanded(
                    child: _buildDataChip(
                      context: context,
                      icon: Icons.repeat,
                      value: workoutSet.reps?.toString() ?? '-',
                    ),
                  ),
                  const SizedBox(width: 6),
                  // RIR
                  Expanded(
                    child: _buildDataChip(
                      context: context,
                      icon: Icons.battery_3_bar,
                      value: workoutSet.rir != null ? 'RIR ${workoutSet.rir}' : '-',
                    ),
                  ),
                ],
              ),
              // Optional comment line
              if (workoutSet.comments?.isNotEmpty == true) ...[
                const SizedBox(height: 6),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    workoutSet.comments!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDataChip({
    required BuildContext context,
    required IconData icon,
    required String value,
  }) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 4,
        children: [
          Icon(icon, size: 14, color: theme.colorScheme.onSurface.withValues(alpha: 0.7)),
          Flexible(
            child: Text(
              value,
              style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
