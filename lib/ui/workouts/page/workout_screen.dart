import 'package:bodybuild/data/core/developer_mode_provider.dart';
import 'package:bodybuild/data/workouts/workout_providers.dart';
import 'package:bodybuild/model/workouts/workout.dart' as model;
import 'package:bodybuild/ui/core/widget/snackbars.dart';
import 'package:bodybuild/ui/workouts/widget/mobile_app_only.dart';
import 'package:bodybuild/ui/workouts/widget/edit_exercise_set_group_sheet.dart';
import 'package:bodybuild/ui/workouts/widget/exercise_set_group_widget.dart';
import 'package:bodybuild/ui/workouts/widget/stopwatch.dart';
import 'package:bodybuild/ui/workouts/widget/workout_header.dart';
import 'package:bodybuild/ui/workouts/widget/workout_footer.dart';
import 'package:bodybuild/ui/workouts/widget/workout_popup_menu.dart';
import 'package:bodybuild/ui/core/widget/app_navigation_drawer.dart';
import 'package:bodybuild/ui/core/widget/err_widget.dart';
import 'package:bodybuild/util/flutter.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// This screen is used as both:
/// - a top level screen (for the curently active workout)
/// - a detail view when coming from WorkoutsScreen (for any historical or current active workout)
class WorkoutScreen extends ConsumerStatefulWidget {
  final String? workoutId; // null to mean currently active workout, creating it if needed
  static const String routeNameActive = 'workout';
  const WorkoutScreen({super.key, this.workoutId});

  @override
  ConsumerState<WorkoutScreen> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends ConsumerState<WorkoutScreen> {
  final TextEditingController _notesController = TextEditingController();
  model.Workout? workout;
  // When we are launched without a workoutId (meaning "current active workout"),
  // we store the concrete id here as soon as the manager tells us which workout is active.
  String? _resolvedWorkoutId;
  // Guards the auto-start block so we only attempt to create one workout per entry.
  bool _attemptedAutoStart = false;
  // Manual subscription so we can keep listening even if build() isn't called yet.
  ProviderSubscription<AsyncValue<model.WorkoutState>>? _workoutStateSub;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      await ref.read(workoutManagerProvider.notifier).closeStaleActiveWorkout();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Lazily install the listener the first time dependencies are resolved. We keep it for the
    // lifetime of this State because WorkoutManager is keepAlive and we want continuous updates.
    _workoutStateSub ??= ref.listenManual<AsyncValue<model.WorkoutState>>(
      workoutManagerProvider,
      (_, next) => _handleWorkoutState(next),
    );

    final currentState = ref.read(workoutManagerProvider);
    if (currentState.hasValue) {
      // Handle whatever data is already cached so we don't wait for the next stream emission.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _handleWorkoutState(currentState);
      });
    }
  }

  void _handleWorkoutState(AsyncValue<model.WorkoutState> asyncState) {
    if (!mounted || !asyncState.hasValue) return;
    final state = asyncState.asData!.value;
    final activeWorkout = state.activeWorkout;
    if (activeWorkout != null) {
      // We now know exactly which workout is active; remember it locally and reset flags.
      setState(() {
        _resolvedWorkoutId = activeWorkout.id;
        workout = activeWorkout;
        _attemptedAutoStart = false;
      });
      return;
    }

    // If our previously resolved workout is no longer active (it was auto-closed somewhere),
    // then going back to "start/resume workout" would show the workout that was active but has just
    // been auto-closed.
    // We could try to work around this with something like the below:
    // clear local state so we can start fresh and create a new active workout, instead of
    // showing the older auto-closed workout that was previously active.
    // However in this form, this creates a loop where we keep creating new workouts and
    // auto-closing them.  So we would then need to track if we already created a new workout or not
    // or something like that. But that's all getting a bit clunky.  One could argue just as well
    // that it's desirable to show the workout that was active but has just been auto-closed. So
    // we will just stick with that for now.
    /*
    if (widget.workoutId == null && _resolvedWorkoutId != null) {
      final resolved = state.allWorkouts.firstWhereOrNull(
        (w) => w.id == _resolvedWorkoutId && w.isActive,
      );
      if (resolved == null) {
        setState(() {
          _resolvedWorkoutId = null;
          workout = null;
        });
      }
    }
    */

    if (widget.workoutId == null && _resolvedWorkoutId == null && !_attemptedAutoStart) {
      // No active workout exists and we are the "start/resume" route. Spin up a new session once.
      _attemptedAutoStart = true;
      Future.microtask(() async {
        final id = await ref.read(workoutManagerProvider.notifier).startWorkout();
        if (!mounted) return;
        // Remember the new workout id so build() can render it once the stream emits.
        setState(() {
          _resolvedWorkoutId = id;
        });
      });
    }
  }

  @override
  void dispose() {
    _workoutStateSub?.close();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final devMode = ref.watch(developerModeProvider);
    if (!isMobileApp() && !devMode) {
      return const MobileAppOnly(title: 'Workout tracking & viewing');
    }

    final workoutStateAsync = ref.watch(workoutManagerProvider);
    return workoutStateAsync.when(
      data: (state) {
        // Prefer the explicit route id, fall back to whatever we resolved from the manager,
        // and finally fall back to the currently active workout if one exists.
        final activeWorkout = state.activeWorkout;
        final targetWorkoutId = widget.workoutId ?? _resolvedWorkoutId ?? activeWorkout?.id;
        if (targetWorkoutId == null) {
          // We are still waiting for the manager to either create or surface a workout.
          return _buildNewWorkoutLoading(context);
        }

        // Grab the matching workout from the manager's cached list so we stay in sync with it.
        final targetWorkout =
            state.allWorkouts.firstWhereOrNull((w) => w.id == targetWorkoutId) ?? activeWorkout;
        if (targetWorkout == null) {
          // Extremely defensive: manager has no record yet, keep the loading UI instead of crashing.
          return _buildNewWorkoutLoading(context);
        }

        workout = targetWorkout;
        return _buildForWorkout(context);
      },
      loading: () => _buildNewWorkoutLoading(context),
      error: (error, stackTrace) => ErrWidget('Error loading workout state', error),
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
      // - top level screen (no workout id specified) needs a hamburger menu
      // - nested screen (workout id specified) needs a back arrow
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
      padding: const EdgeInsets.all(16),
      itemCount: groups.length,
      itemBuilder: (context, index) {
        final group = groups[index];
        return ExerciseSetGroupWidget(group: group);
      },
    );
  }

  Future<void> _showLogSetSheet(BuildContext context) async {
    final result = await showModalBottomSheet<EditExerciseSetGroupSheetResponse>(
      context: context,
      isScrollControlled: true,
      builder: (context) => EditExerciseSetGroupSheet(workout!.id, group: null),
    );

    if (result != null) {
      try {
        final workoutManager = ref.read(workoutManagerProvider.notifier);

        // Add all the new sets that were created
        for (final set in result.sets) {
          await workoutManager.addSet(set);
        }
      } catch (e) {
        if (!mounted) return;
        showErrorSnackBar(context, 'Error adding sets: $e');
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
