import 'package:flutter/material.dart';
import 'package:bodybuild/ui/mealplanner/page/mealplanner.dart';
import 'package:bodybuild/ui/programmer/page/programmer_builder.dart';
import 'package:bodybuild/ui/programmer/page/programmer_setup.dart';

class ProgrammerScreen extends StatefulWidget {
  const ProgrammerScreen({super.key});

  static const routeName = 'programmer';

  @override
  State<ProgrammerScreen> createState() => _ProgrammerScreenState();
}

class _ProgrammerScreenState extends State<ProgrammerScreen> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    if (screenWidth < 1000) {
      return Scaffold(
        body: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 600),
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.fit_screen,
                  size: 64,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 24),
                Text(
                  'Screen Too Small',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 16),
                Text(
                  'This application requires a bigger screen.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.7),
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Please use a device with a screen width of at least 1000 pixels.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onBackground
                            .withOpacity(0.5),
                      ),
                ),
              ],
            ),
          ),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Programmer'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        bottom: const TabBar(
          tabs: [
            Tab(text: "Set up"),
            Tab(text: "Workout programmer"),
            //    Tab(text: "Nutrition planner"), // WIP
          ],
        ),
      ),
      body: const TabBarView(
        children: [
          SingleChildScrollView(
            child: ProgrammerSetup(),
          ),
          SingleChildScrollView(
            child: Padding(
              padding:
                  EdgeInsets.only(left: 8, right: 28), // to fix header overflow
              child: ProgrammerBuilder(),
            ),
          ),
          //  SingleChildScrollView(
          //   child: MealPlanScreen(),
          // ),
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