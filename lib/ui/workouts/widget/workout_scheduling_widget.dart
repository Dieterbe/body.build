import 'package:flutter/material.dart';

/// Widget for setting workout frequency (timesPerPeriod and periodWeeks)
/// Similar to the UI in the workout programmer
class WorkoutSchedulingWidget extends StatelessWidget {
  final int timesPerPeriod;
  final int periodWeeks;
  final Function(int timesPerPeriod, int periodWeeks) onChanged;

  const WorkoutSchedulingWidget({
    super.key,
    required this.timesPerPeriod,
    required this.periodWeeks,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Times per period dropdown
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(6),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          child: DropdownButton<int>(
            value: timesPerPeriod,
            underline: Container(),
            isDense: true,
            icon: Icon(
              Icons.arrow_drop_down,
              size: 16,
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
            ),
            items: List.generate(7, (i) => i + 1)
                .map(
                  (i) => DropdownMenuItem(
                    value: i,
                    child: Text(
                      i.toString(),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ),
                )
                .toList(),
            onChanged: (value) {
              if (value != null) {
                onChanged(value, periodWeeks);
              }
            },
          ),
        ),
        const SizedBox(width: 8),
        Text(
          'times per',
          style: TextStyle(
            fontSize: 14,
            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 8),
        // Period weeks dropdown
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(6),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          child: DropdownButton<int>(
            value: periodWeeks,
            underline: Container(),
            isDense: true,
            icon: Icon(
              Icons.arrow_drop_down,
              size: 16,
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
            ),
            items: List.generate(4, (i) => i + 1)
                .map(
                  (i) => DropdownMenuItem(
                    value: i,
                    child: Text(
                      i == 1 ? 'week' : '$i weeks',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ),
                )
                .toList(),
            onChanged: (value) {
              if (value != null) {
                onChanged(timesPerPeriod, value);
              }
            },
          ),
        ),
      ],
    );
  }
}
