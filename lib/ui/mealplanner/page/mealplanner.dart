import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ptc/ui/mealplanner/page/mealplanner_results.dart';
import 'mealplanner_setup.dart';

class MealPlanScreen extends ConsumerStatefulWidget {
  static const String routeName = 'meal-planner';

  const MealPlanScreen({super.key});

  @override
  ConsumerState<MealPlanScreen> createState() => _MealPlanScreenState();
}

class _MealPlanScreenState extends ConsumerState<MealPlanScreen> {
  @override
  Widget build(BuildContext context) {
    return const Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 1,
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: MealPlannerSetup(),
          ),
        ),
        Expanded(
          flex: 2,
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: MealPlannerResults(),
          ),
        ),
      ],
    );
  }
}
