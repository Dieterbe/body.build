import 'package:bodybuild/ui/workouts/page/workout_screen.dart';
import 'package:bodybuild/ui/workouts/widget/mobile_app_only.dart';
import 'package:bodybuild/ui/workouts/widget/workouts_list.dart';
import 'package:bodybuild/ui/workouts/widget/workouts_list_empty.dart';
import 'package:bodybuild/util/string_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:bodybuild/data/workouts/workout_providers.dart';
import 'package:bodybuild/ui/core/widget/navigation_drawer.dart';
import 'package:bodybuild/util/flutter.dart';

class WorkoutsScreen extends ConsumerWidget {
  static const String routeName = 'workouts';

  const WorkoutsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!isMobileApp()) {
      return const MobileAppOnly(title: 'Workouts');
    }

    final workoutStateAsync = ref.watch(workoutManagerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Workouts'),
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
      drawer: const AppNavigationDrawer(),
      body: workoutStateAsync.when(
        data: (state) =>
            state.allWorkouts.isEmpty ? const WorkoutsListEmpty() : WorkoutsList(state.allWorkouts),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) {
          debugPrint('WorkoutsScreen error: $error');
          debugPrintStack(stackTrace: stack);
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                Text('Error loading workouts: $error'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => ref.invalidate(workoutManagerProvider),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: workoutStateAsync.when(
        data: (state) => state.activeWorkout != null
            ? null
            : FloatingActionButton.extended(
                onPressed: () {
                  context.goNamed(WorkoutScreen.routeNameActive);
                },
                icon: const Icon(Icons.play_arrow),
                label: const Text('Start Workout'),
              ),
        loading: () => null,
        error: (error, stack) => null,
      ),
    );
  }
}
