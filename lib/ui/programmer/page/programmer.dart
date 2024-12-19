import 'package:flutter/material.dart';
import 'package:ptc/ui/mealplanner/page/mealplanner.dart';
import 'package:ptc/ui/programmer/page/programmer_builder.dart';
import 'package:ptc/ui/programmer/page/programmer_setup.dart';

class ProgrammerScreen extends StatefulWidget {
  const ProgrammerScreen({super.key});

  static const routeName = 'programmer';

  @override
  State<ProgrammerScreen> createState() => _ProgrammerScreenState();
}

class _ProgrammerScreenState extends State<ProgrammerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Programmer'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        bottom: const TabBar(
          tabs: [
            Tab(text: "Set up"),
            Tab(text: "Nutrition planner"),
            Tab(text: "Workout planner"),
          ],
        ),
      ),
      body: const TabBarView(
        children: [
          SingleChildScrollView(
            child: ProgrammerSetup(),
          ),
          SingleChildScrollView(
            child: MealPlanScreen(),
          ),
          SingleChildScrollView(
            child: Padding(
              padding:
                  EdgeInsets.only(left: 8, right: 28), // to fix header overflow
              child: ProgrammerBuilder(),
            ),
          ),
        ],
      ),
    );
  }
}



/*
volume distribution?
menno says: equal for all muscles
Jeff nippard says back quads glutes can handle more volume. https://youtu.be/ekQxEEjYLDI?si=KtMthjzxUAl4Md50 5:13
*/