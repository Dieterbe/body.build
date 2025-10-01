import 'package:bodybuild/data/programmer/exercises.dart';
import 'package:bodybuild/data/programmer/groups.dart';
import 'package:bodybuild/model/programmer/settings.dart';
import 'package:bodybuild/ui/programmer/util_groups.dart';
import 'package:flutter/material.dart';

class MuscleRecruitmentBar extends StatelessWidget {
  final Ex exercise;
  final Settings setup;
  const MuscleRecruitmentBar({super.key, required this.exercise, required this.setup});

  @override
  Widget build(BuildContext context) {
    final recruitmentData = <ProgramGroup, double>{};
    for (final group in ProgramGroup.values) {
      final recruitment = exercise.recruitment(group, {});
      if (recruitment.volume > 0) {
        recruitmentData[group] = recruitment.volume;
      }
    }

    if (recruitmentData.isEmpty) return const SizedBox.shrink();

    return Container(
      height: 10,
      margin: const EdgeInsets.only(top: 4),
      child: Row(
        children: recruitmentData.entries.map((entry) {
          final group = entry.key;
          final volume = entry.value;
          return Expanded(
            flex: (volume * 100).round(),
            child: Container(
              margin: const EdgeInsets.only(right: 0.5),
              decoration: BoxDecoration(
                color: bgColorForProgramGroup(group).withValues(alpha: 0.7),
                borderRadius: BorderRadius.circular(1),
              ),
              child: Tooltip(
                message: '${group.displayNameShort}: ${(volume * 100).toStringAsFixed(0)}%',
                child: Container(),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
