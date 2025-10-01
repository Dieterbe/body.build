import 'package:bodybuild/data/workouts/workout_providers.dart';
import 'package:bodybuild/model/workouts/workout.dart' as model;
import 'package:bodybuild/ui/workouts/widget/mobile_app_only.dart';
import 'package:bodybuild/ui/workouts/widget/exercise_picker_sheet.dart';
import 'package:bodybuild/ui/workouts/widget/add_set_dialog.dart';
import 'package:bodybuild/ui/workouts/widget/set_log_widget.dart';
import 'package:bodybuild/ui/workouts/widget/stopwatch.dart';
import 'package:bodybuild/ui/workouts/widget/workout_header.dart';
import 'package:bodybuild/ui/workouts/widget/workout_footer.dart';
import 'package:bodybuild/ui/workouts/widget/workout_popup_menu.dart';
import 'package:bodybuild/ui/core/widget/navigation_drawer.dart';
import 'package:bodybuild/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    if (!isMobileApp()) {
      return const MobileAppOnly(title: 'Workout tracking & viewing');
    }

    // If workoutId is provided, show that specific workout
    if (widget.workoutId != null) {
      final workoutAsync = ref.watch(workoutByIdProvider(widget.workoutId!));
      return workoutAsync.when(
        data: (workout) => workout == null
            // we don't support web where people can craft custom URL's
            // on mobile apps we should always have the correct ID and be able to load it
            ? Text('Error loading workout ${widget.workoutId!}!')
            : _buildForWorkout(context, workout),
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
          return _buildForWorkout(context, activeWorkout);
        }
        // No active workout: show loading state until initState() has completed creating one
        return _buildNewWorkoutLoading(context);
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) => const Center(child: Text('Error loading workout state')),
    );
  }

  Widget _buildForWorkout(BuildContext context, model.Workout workout) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Workout'),
        backgroundColor: Theme.of(context).colorScheme.surface,
        actions: [
          if (workout.isActive == true)
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Center(child: Stopwatch(start: workout.startTime)),
            ),
          WorkoutPopupMenu(workout, reRoute: '/workouts'),
        ],
      ),
      // this screen is used in two ways:
      // - top level screen needs a hamburger menu
      // - nested screen needs a back arrow
      drawer: widget.workoutId == null ? const AppNavigationDrawer() : null,
      body: Column(
        children: [
          WorkoutHeader(workout: workout),
          Expanded(
            child: workout.sets.isEmpty ? _buildEmptyState(workout) : _buildSetsList(workout.sets),
          ),
          WorkoutFooter(workout: workout),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showExercisePicker(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildEmptyState(model.Workout workout) {
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
              workout.isActive ? 'No Sets Yet' : 'No Sets in this workout',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            Text(
              workout.isActive
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

  Widget _buildSetsList(List<model.WorkoutSet> sets) {
    // Group sets by exercise, modifiers, and cues
    final groupedSets = <String, List<model.WorkoutSet>>{};
    for (final set in sets) {
      // Create a composite key that includes exercise ID, modifiers, and cues
      final modifiersKey = set.modifiers.entries.map((e) => '${e.key}:${e.value}').toList()..sort();
      final cuesKey =
          set.cues.entries
              .where((e) => e.value) // Only include enabled cues
              .map((e) => e.key)
              .toList()
            ..sort();

      final groupKey = '${set.exerciseId}|${modifiersKey.join(',')}|${cuesKey.join(',')}';
      groupedSets.putIfAbsent(groupKey, () => []).add(set);
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: groupedSets.length,
      itemBuilder: (context, index) {
        final groupKey = groupedSets.keys.elementAt(index);
        final exerciseSets = groupedSets[groupKey]!;

        return _buildExerciseGroup(exerciseSets);
      },
    );
  }

  // sets is guaranteed to be non-empty, and all sets have the same exerciseId, cues and modifiers
  Widget _buildExerciseGroup(List<model.WorkoutSet> sets) {
    final exerciseId = sets.first.exerciseId;
    final cues = sets.first.cues;
    final modifiers = sets.first.modifiers;
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    exerciseId, // TODO: Get exercise name from exercise data
                    style: Theme.of(
                      context,
                    ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                TextButton.icon(
                  onPressed: () => _addSetForExercise(exerciseId, cues, modifiers),
                  icon: const Icon(Icons.add, size: 16),
                  label: const Text('Add Set'),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...sets.map(
              (set) => SetLogWidget(
                workoutSet: set,
                onUpdate: (updatedSet) => _updateSet(updatedSet),
                onDelete: () => _deleteSet(set.id),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showExercisePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => ExercisePickerSheet(
        onExerciseSelected: (exerciseId) {
          Navigator.of(context).pop();
          _addSetForExercise(exerciseId, {}, {});
        },
      ),
    );
  }

  void _addSetForExercise(
    String exerciseId,
    Map<String, bool> cues,
    Map<String, String> modifiers,
  ) async {
    // Show dialog to get set data
    final setData = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => const AddSetDialog(),
    );

    // If user cancelled the dialog, don't add the set
    if (setData == null) return;

    try {
      final workoutManager = ref.read(workoutManagerProvider.notifier);
      await workoutManager.addSet(
        workoutId: widget.workoutId!,
        exerciseId: exerciseId,
        modifiers: modifiers,
        cues: cues,
        weight: setData['weight'] as double?,
        reps: setData['reps'] as int?,
        rir: setData['rir'] as int?,
        comments: setData['comments'] as String?,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Set added')));
      }
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

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Set updated')));
      }
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

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Set deleted')));
      }
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
