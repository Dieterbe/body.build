import 'package:bodybuild/model/workouts/workout_template.dart';
import 'package:bodybuild/ui/workouts/widget/set_group_row.dart';
import 'package:flutter/material.dart';

class TemplateExpandedContent extends StatelessWidget {
  const TemplateExpandedContent({super.key, required this.template});

  final WorkoutTemplate template;

  @override
  Widget build(BuildContext context) {
    final setGroups = template.workout.setGroups;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        for (var i = 0; i < setGroups.length; i++) SetGroupRow(setGroup: setGroups[i], index: i),
      ],
    );
  }
}
