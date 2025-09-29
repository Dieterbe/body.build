import 'package:bodybuild/ui/workouts/page/workout_screen.dart';
import 'package:bodybuild/ui/workouts/widget/mobile_app_only.dart';
import 'package:bodybuild/ui/workouts/widget/workouts_list.dart';
import 'package:bodybuild/ui/workouts/widget/workouts_list_empty.dart';
import 'package:bodybuild/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:bodybuild/data/workouts/workout_providers.dart';
import 'package:bodybuild/ui/core/widget/navigation_drawer.dart';

class WorkoutsScreen extends ConsumerWidget {
  static const String routeName = 'workouts';

  const WorkoutsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!isMobileApp()) {
      return const MobileAppOnly(title: 'Workouts');
    }

    final workoutsAllAsync = ref.watch(workoutsAllProvider);
    final activeWorkoutAsync = ref.watch(activeWorkoutProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Workouts'),
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
      drawer: const AppNavigationDrawer(),
      body: workoutsAllAsync.when(
        data: (workouts) => workouts.isEmpty ? const WorkoutsListEmpty() : WorkoutsList(workouts),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text('Error loading workouts: $error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.invalidate(workoutsAllProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: activeWorkoutAsync.when(
        data: (activeWorkout) => activeWorkout != null
            ? null
            : FloatingActionButton.extended(
                onPressed: () {
                  context.goNamed(WorkoutScreen.routeNameNew);
                },
                icon: const Icon(Icons.play_arrow),
                label: const Text('Start Workout'),
              ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => null,
      ),
    );
  }
}
