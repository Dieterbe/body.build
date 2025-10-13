import 'package:bodybuild/data/developer_mode_provider.dart';
import 'package:bodybuild/data/workouts/workout_providers.dart';
import 'package:bodybuild/model/workouts/workout.dart' as model;
import 'package:bodybuild/ui/core/widget/err_widget.dart';
import 'package:bodybuild/ui/workouts/widget/mobile_app_only.dart';
import 'package:bodybuild/ui/workouts/widget/log_set_sheet.dart';
import 'package:bodybuild/ui/workouts/widget/exercise_set_group_widget.dart';
import 'package:bodybuild/ui/workouts/widget/stopwatch.dart';
import 'package:bodybuild/ui/workouts/widget/workout_header.dart';
import 'package:bodybuild/ui/workouts/widget/workout_footer.dart';
import 'package:bodybuild/ui/workouts/widget/workout_popup_menu.dart';
import 'package:bodybuild/ui/workouts/widget/workout_volume_summary.dart';
import 'package:bodybuild/ui/core/widget/navigation_drawer.dart';
import 'package:bodybuild/util/flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bodybuild/model/programmer/set_group.dart';

/// This screen is used as both:
/// - a top level screen (for the curently active workout)
/// - a detail view when coming from WorkoutsScreen (for any historical or current active workout)
class WorkoutScreen extends ConsumerStatefulWidget {
  final String? workoutId; // null for currently active workout, creating it if needed
  static const String routeNameActive = 'workout';
  const WorkoutScreen({super.key, this.workoutId});

  @override
  ConsumerState<WorkoutScreen> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends ConsumerState<WorkoutScreen> {
  final TextEditingController _notesController = TextEditingController();
  model.Workout? workout;

  @override
  void initState() {
    super.initState();
    // If no workoutId provided, we need to ensure an active workout exists
    if (widget.workoutId == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final workoutStateAsync = ref.read(workoutManagerProvider);
        workoutStateAsync.whenData((workoutState) {
          if (workoutState.activeWorkout == null) {
            ref.read(workoutManagerProvider.notifier).startWorkout();
          }
        });
      });
    }
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final devMode = ref.watch(developerModeProvider);
    if (!isMobileApp() && !devMode) {
      return const MobileAppOnly(title: 'Workout tracking & viewing');
    }

    // If workoutId is provided, show that specific workout
    if (widget.workoutId != null) {
      final workoutAsync = ref.watch(workoutByIdProvider(widget.workoutId!));
      return workoutAsync.when(
        data: (w) {
          workout = w;
          return (workout == null)
              // we don't support web where people can craft custom URL's
              // on mobile apps we should always have the correct ID and be able to load it
              ? Text('Error loading workout ${widget.workoutId!}!')
              : _buildForWorkout(context);
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const Center(child: Text('Error loading the requested workout')),
      );
    }

    // No workoutId provided - show the active workout, creating one if needed
    final workoutState = ref.watch(workoutManagerProvider);
    return workoutState.when(
      data: (state) {
        final activeWorkout = state.activeWorkout;
        if (activeWorkout != null) {
          workout = activeWorkout;
          return _buildForWorkout(context);
        }
        // No active workout: show loading state until initState() has completed creating one
        return _buildNewWorkoutLoading(context);
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => ErrWidget("Error loading workout state", error),
    );
  }

  // relies on this.workout being set to non-null
  Widget _buildForWorkout(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Workout'),
        backgroundColor: Theme.of(context).colorScheme.surface,
        actions: [
          if (workout!.isActive == true)
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Center(child: Stopwatch(start: workout!.startTime)),
            ),
          WorkoutPopupMenu(workout!, reRoute: '/workouts'),
        ],
      ),
      // this screen is used in two ways:
      // - top level screen needs a hamburger menu
      // - nested screen needs a back arrow
      drawer: widget.workoutId == null ? const AppNavigationDrawer() : null,
      body: Column(
        children: [
          WorkoutHeader(workout: workout!),
          Expanded(child: workout!.sets.isEmpty ? _buildEmptyState() : _buildSetsList()),
          WorkoutFooter(workout: workout!),
        ],
      ),
      floatingActionButton: !workout!.isActive
          ? null
          : FloatingActionButton.extended(
              onPressed: () => _showLogSetSheet(context),
              icon: const Icon(Icons.add),
              label: const Text('Log Set'),
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.fitness_center,
              size: 96,
              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 24),
            Text(
              workout!.isActive ? 'No Sets Yet' : 'No Sets in this workout',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            Text(
              workout!.isActive
                  ? 'Log your first exercise set with the button below'
                  : 'What a shame.',
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSetsList() {
    // Group sets by exercise and tweaks using the model
    final groups = model.ExerciseSetGroup.fromSets(workout!.sets);

    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 16),
      itemCount: groups.length + 1, // +1 for volume summary
      itemBuilder: (context, index) {
        // First item is the volume summary
        if (index == 0) {
          return WorkoutVolumeSummary(workout: workout!);
        }

        // Remaining items are exercise groups
        final group = groups[index - 1];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ExerciseSetGroupWidget(
            group: group,
            onUpdateSet: _updateSet,
            onUpdateExercise: _updateExerciseForGroup,
            onAddSet: _saveSet,
            onDeleteSet: _deleteSet,
          ),
        );
      },
    );
  }

  void _updateExerciseForGroup(model.ExerciseSetGroup group, Sets newSets) async {
    // Update all sets in the group with the new exercise and tweaks
    try {
      final workoutManager = ref.read(workoutManagerProvider.notifier);
      for (final set in group.sets) {
        final updatedSet = set.copyWith(exerciseId: newSets.ex!.id, tweaks: newSets.tweakOptions);
        await workoutManager.updateSet(updatedSet);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating exercise: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  void _showLogSetSheet(BuildContext context, {Sets? initialSets}) async {
    final result = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      builder: (context) => LogSetSheet(initialSets: initialSets),
    );

    if (result != null) {
      _saveSet(result);
    }
  }

  void _saveSet(Map<String, dynamic> data) async {
    final sets = data['sets'] as Sets;

    try {
      final workoutManager = ref.read(workoutManagerProvider.notifier);
      await workoutManager.addSet(
        workoutId: workout!.id,
        exerciseId: sets.ex!.id,
        tweaks: sets.tweakOptions,
        weight: data['weight'] as double?,
        reps: data['reps'] as int?,
        rir: data['rir'] as int?,
        comments: data['comments'] as String?,
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error adding set: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  void _updateSet(model.WorkoutSet updatedSet) async {
    try {
      final workoutManager = ref.read(workoutManagerProvider.notifier);
      await workoutManager.updateSet(updatedSet);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating set: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  void _deleteSet(String setId) async {
    try {
      final workoutManager = ref.read(workoutManagerProvider.notifier);
      await workoutManager.deleteSet(setId);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error deleting set: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  // this goes normally so fast that it's imperceptible
  // that's why we don't put too much content here, it would cause too much flickering
  Widget _buildNewWorkoutLoading(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Theme.of(context).colorScheme.surface),
      drawer: const AppNavigationDrawer(),
      body: const Center(child: CircularProgressIndicator()),
    );
  }
}
