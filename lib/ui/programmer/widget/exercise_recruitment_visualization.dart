import 'package:bodybuild/data/programmer/exercises.dart';
import 'package:bodybuild/data/programmer/groups.dart';
import 'package:bodybuild/model/programmer/settings.dart';
import 'package:bodybuild/ui/programmer/util_groups.dart';
import 'package:flutter/material.dart';

class ExerciseRecruitmentVisualization extends StatelessWidget {
  final Ex exercise;
  final Map<String, String> tweakOptions;
  final Settings setup;
  final double cutoff;

  const ExerciseRecruitmentVisualization({
    super.key,
    required this.exercise,
    required this.tweakOptions,
    required this.setup,
    this.cutoff = 0,
  });

  @override
  Widget build(BuildContext context) {
    final recruitmentData = <ProgramGroup, double>{};

    // Calculate recruitment for each muscle group with current tweaks
    for (final group in ProgramGroup.values) {
      final recruitment = exercise.recruitment(group, tweakOptions);
      if (recruitment.volume > cutoff) {
        recruitmentData[group] = recruitment.volume;
      }
    }

    if (recruitmentData.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Theme.of(context).dividerColor, width: 1),
        ),
        child: Row(
          children: [
            Icon(Icons.info_outline, size: 16, color: Theme.of(context).hintColor),
            const SizedBox(width: 8),
            Text(
              'No muscle recruitment data available',
              style: TextStyle(color: Theme.of(context).hintColor, fontSize: 14),
            ),
          ],
        ),
      );
    }

    // Sort by recruitment volume (highest first)
    final sortedEntries = recruitmentData.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Detailed breakdown
        Wrap(
          spacing: 8,
          runSpacing: 6,
          children: sortedEntries.map((entry) {
            final group = entry.key;
            final volume = entry.value;
            final percentage = (volume * 100).round();

            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: bgColorForProgramGroup(group).withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: bgColorForProgramGroup(group).withValues(alpha: 0.6),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: bgColorForProgramGroup(group).withValues(alpha: 0.8),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    group.displayNameShort,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '$percentage%',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
