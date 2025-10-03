import 'package:bodybuild/ui/exercises/widget/exercise_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bodybuild/data/programmer/setup.dart';
import 'package:bodybuild/model/programmer/settings.dart';
import 'package:bodybuild/ui/core/widget/navigation_drawer.dart';
import 'package:bodybuild/data/exercises/exercise_filter_provider.dart';
import 'package:bodybuild/ui/exercises/widget/filter_mobile.dart';
import 'package:bodybuild/ui/exercises/widget/filter_panel.dart';
import 'package:bodybuild/ui/exercises/widget/exercise_detail_panel.dart';
import 'package:bodybuild/data/programmer/exercises.dart';
import 'package:bodybuild/util/url.dart';
import 'package:go_router/go_router.dart';

class ExercisesScreen extends ConsumerStatefulWidget {
  static const String routeName = 'exercises';
  final String? exerciseId;
  final Map<String, String>? tweakOptions;

  const ExercisesScreen({super.key, this.exerciseId, this.tweakOptions});

  @override
  ConsumerState<ExercisesScreen> createState() => _ExercisesScreenState();
}

class _ExercisesScreenState extends ConsumerState<ExercisesScreen> {
  @override
  void initState() {
    super.initState();
    // Delay URL initialization until after build completes to avoid Riverpod error:
    // "Tried to modify a provider while the widget tree was building"
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeFromUrl();
    });
  }

  void _initializeFromUrl() {
    if (widget.exerciseId != null) {
      final exercise = exes.cast<Ex?>().firstWhere(
        (ex) => ex?.id == widget.exerciseId,
        orElse: () => null,
      );
      if (exercise != null) {
        ref
            .read(exerciseFilterProvider.notifier)
            .setSelectedExercise(exercise, tweakOptions: widget.tweakOptions ?? {});
      }
    }
  }

  void _updateUrl(Ex? exercise, Map<String, String> tweakOptions) {
    if (exercise == null) {
      context.go('/exercises');
    } else {
      context.go(buildExerciseDetailUrl(exercise.id, tweakOptions));
    }
  }

  @override
  Widget build(BuildContext context) {
    // for now, only used by the ExerciseDetailsDialog.
    // perhaps we'll use this more at a later stage
    final setup = ref.watch(setupProvider);
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 1024;
    final isTablet = screenWidth > 768 && screenWidth <= 1024;

    // Listen to exercise selection changes and update URL
    ref.listen(exerciseFilterProvider, (previous, next) {
      if (previous?.selectedExercise != next.selectedExercise ||
          previous?.selectedTweakOptions != next.selectedTweakOptions) {
        _updateUrl(next.selectedExercise, next.selectedTweakOptions);
      }
    });

    // Listen for exercise selection on mobile/tablet to show modal
    if (!isDesktop) {
      ref.listen(exerciseFilterProvider.select((state) => state.selectedExercise), (
        previous,
        selectedExercise,
      ) {
        if (selectedExercise != null && previous != selectedExercise) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            setup.whenData((setupData) => _showExerciseDetailModal(setupData, context));
          });
        }
      });
    }

    return setup.when(
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (error, stack) => Scaffold(body: Center(child: Text('Error: $error'))),
      data: (setupData) => Scaffold(
        appBar: AppBar(
          title: const Text('Exercise Browser'),
          backgroundColor: Theme.of(context).colorScheme.surface,
          actions: [
            if (!isDesktop) ...[
              Consumer(
                builder: (context, ref, child) {
                  final showFilters = ref.watch(
                    exerciseFilterProvider.select((state) => state.showFilters),
                  );
                  return IconButton(
                    icon: Icon(showFilters ? Icons.filter_list_off : Icons.filter_list),
                    onPressed: () {
                      ref.read(exerciseFilterProvider.notifier).toggleShowFilters();
                    },
                  );
                },
              ),
            ],
          ],
        ),
        drawer: const AppNavigationDrawer(),
        body: isDesktop
            ? _buildDesktopLayout(setupData)
            : isTablet
            ? _buildTabletLayout()
            : _buildMobileLayout(),
      ),
    );
  }

  Widget _buildDesktopLayout(Settings setupData) {
    return Row(
      children: [
        // Filters Panel
        Container(
          width: 300,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            border: Border(
              right: BorderSide(color: Theme.of(context).dividerColor.withValues(alpha: 0.3)),
            ),
          ),
          child: const FilterPanel(),
        ),
        // Exercise List
        const Expanded(flex: 2, child: ExerciseList()),
        // Exercise Detail Panel
        Consumer(
          builder: (context, ref, child) {
            final selectedExercise = ref.watch(
              exerciseFilterProvider.select((state) => state.selectedExercise),
            );
            if (selectedExercise == null) return const SizedBox.shrink();
            return Container(
              width: 400,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                border: Border(
                  left: BorderSide(color: Theme.of(context).dividerColor.withValues(alpha: 0.3)),
                ),
              ),
              alignment: Alignment.topCenter,
              child: ExerciseDetailPanel(setupData: setupData),
            );
          },
        ),
      ],
    );
  }

  Widget _buildTabletLayout() {
    return Row(
      children: [
        // Collapsible Filters Panel
        Consumer(
          builder: (context, ref, child) {
            final showFilters = ref.watch(
              exerciseFilterProvider.select((state) => state.showFilters),
            );
            if (!showFilters) return const SizedBox.shrink();
            return Container(
              width: 280,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                border: Border(
                  right: BorderSide(color: Theme.of(context).dividerColor.withValues(alpha: 0.3)),
                ),
              ),
              child: const FilterPanel(),
            );
          },
        ),
        // Exercise List
        const Expanded(child: ExerciseList()),
      ],
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      children: [
        Consumer(
          builder: (context, ref, child) {
            final showFilters = ref.watch(
              exerciseFilterProvider.select((state) => state.showFilters),
            );
            if (!showFilters) return const SizedBox.shrink();
            return const FilterMobile();
          },
        ),
        const Expanded(child: ExerciseList()),
      ],
    );
  }

  void _showExerciseDetailModal(Settings setupData, BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => Dialog(
        insetPadding: const EdgeInsets.all(20),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 600, maxHeight: 700),
          padding: const EdgeInsets.all(16),
          child: ExerciseDetailPanel(setupData: setupData, pop: dialogContext),
        ),
      ),
    ).then((_) {
      // Clear selection when dialog is dismissed
      ref.read(exerciseFilterProvider.notifier).setSelectedExercise(null);
    });
  }
}
