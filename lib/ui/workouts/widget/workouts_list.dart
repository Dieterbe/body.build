import 'package:bodybuild/model/workouts/workout.dart' as model;
import 'package:bodybuild/ui/workouts/widget/workout_card.dart';
import 'package:flutter/material.dart';

class WorkoutsList extends StatelessWidget {
  const WorkoutsList(this.workoutsAlll, {super.key});
  final List<model.Workout> workoutsAlll;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: workoutsAlll.length,
            itemBuilder: (context, index) {
              final workout = workoutsAlll[index];
              return WorkoutCard(workout);
            },
          ),
        ),
      ],
    );
  }
}
