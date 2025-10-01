import 'package:bodybuild/data/workouts/workout_providers.dart';
import 'package:bodybuild/model/workouts/workout.dart' as model;
import 'package:bodybuild/ui/workouts/widget/mobile_app_only.dart';
import 'package:bodybuild/ui/workouts/widget/exercise_picker_sheet.dart';
import 'package:bodybuild/ui/workouts/widget/add_set_dialog.dart';
import 'package:bodybuild/ui/workouts/widget/set_log_widget.dart';
import 'package:bodybuild/ui/workouts/widget/stopwatch.dart';
import 'package:bodybuild/ui/workouts/widget/workout_header.dart';
import 'package:bodybuild/ui/workouts/widget/workout_footer.dart';
import 'package:bodybuild/ui/workouts/page/workouts_screen.dart';
import 'package:bodybuild/ui/workouts/widget/workout_popup_menu.dart';
import 'package:bodybuild/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class WorkoutScreen extends ConsumerStatefulWidget {
  final String workoutId;
  static const String routeNameNew = 'workouts/new';
  const WorkoutScreen({super.key, required this.workoutId});

  @override
  ConsumerState<WorkoutScreen> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends ConsumerState<WorkoutScreen> {
  final TextEditingController _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Handle "new" workout case
    if (isMobileApp() && widget.workoutId == 'new') {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _handleNewWorkout();
      });
    }
  }

  void _handleNewWorkout() async {
    try {
      // Check if there's already an active workout
      final workoutState = await ref.read(workoutManagerProvider.future);
      final activeWorkout = workoutState.activeWorkout;
      if (activeWorkout != null && mounted) {
        print('switching view to active workout ${activeWorkout.id}');

        // Resume existing active workout - replace current route to avoid back navigation issues
        context.replace('/${WorkoutsScreen.routeName}/${activeWorkout.id}');
        return;
      }

      // Create new workout
      final workoutManager = ref.read(workoutManagerProvider.notifier);
      final workoutId = await workoutManager.startWorkout();

      if (mounted) {
        print('switching view to new workout $workoutId');
        // Replace current route to avoid back navigation issues
        context.replace('/${WorkoutsScreen.routeName}/$workoutId');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error starting workout: $e'), backgroundColor: Colors.red),
        );
        // Fallback to workouts list
        context.goNamed(WorkoutsScreen.routeName);
      }
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
      return const MobileAppOnly(title: 'Workout tracking');
    }
    // Handle "new" workout case - show loading while we determine the actual workout ID
    if (widget.workoutId == 'new') {
      return _buildNewWorkoutLoading(context);
    }

    final workoutAsync = ref.watch(workoutByIdProvider(widget.workoutId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Workout'),
        backgroundColor: Theme.of(context).colorScheme.surface,
        actions: workoutAsync.when(
          data: (workout) => [
            if (workout?.isActive == true)
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Center(child: Stopwatch(start: workout!.startTime)),
              ),
            if (workout != null) WorkoutPopupMenu(workout, reRoute: '/workouts'),
          ],
          loading: () => null,
          error: (_, __) => null,
        ),
      ),
      body: workoutAsync.when(
        data: (workout) {
          if (workout == null) {
            return const Center(child: Text('Workout not found'));
          }

          return _buildWorkoutContent(workout);
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text('Error loading workout: $error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.invalidate(workoutByIdProvider(widget.workoutId)),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showExercisePicker(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildWorkoutContent(model.Workout workout) {
    return Column(
      children: [
        WorkoutHeader(workout: workout),
        Expanded(
          child: workout.sets.isEmpty ? _buildEmptyState(workout) : _buildSetsList(workout.sets),
        ),
        WorkoutFooter(workout: workout),
      ],
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
        workoutId: widget.workoutId,
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
  Widget _buildNewWorkoutLoading(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Starting Workout...'),
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Preparing your workout...'),
          ],
        ),
      ),
    );
  }
}
