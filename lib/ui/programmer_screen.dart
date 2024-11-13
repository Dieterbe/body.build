import 'package:flutter/material.dart';
import 'package:ptc/ui/programmer_exercise_selection/programmer_exercise_selection.dart';
import 'package:ptc/ui/programmer_setup.dart';

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
            Tab(text: "Exercise selection"),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TabBarView(
          children: [
            SingleChildScrollView(child: ProgrammerSetup()),
            const SingleChildScrollView(child: ProgrammerExerciseSelection()),
          ],
        ),
      ),
    );
  }
}



/*
volume distribution?
menno says: equal for all muscles
Jeff nippard says back quads glutes can handle more volume. https://youtu.be/ekQxEEjYLDI?si=KtMthjzxUAl4Md50 5:13
*/