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

class ExercisesScreen extends ConsumerStatefulWidget {
  static const String routeName = 'exercises';

  const ExercisesScreen({super.key});

  @override
  ConsumerState<ExercisesScreen> createState() => _ExercisesScreenState();
}

class _ExercisesScreenState extends ConsumerState<ExercisesScreen> {
  @override
  Widget build(BuildContext context) {
    // for now, only used by the ExerciseDetailsDialog.
    // perhaps we'll use this more at a later stage
    final setup = ref.watch(setupProvider);
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 1024;
    final isTablet = screenWidth > 768 && screenWidth <= 1024;

    return setup.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => Scaffold(
        body: Center(child: Text('Error: $error')),
      ),
      data: (setupData) => Scaffold(
        appBar: AppBar(
          title: const Text('Exercise Browser'),
          backgroundColor: Theme.of(context).colorScheme.surface,
          actions: [
            if (!isDesktop) ...[
              Consumer(
                builder: (context, ref, child) {
                  final showFilters = ref.watch(exerciseFilterProvider
                      .select((state) => state.showFilters));
                  return IconButton(
                    icon: Icon(showFilters
                        ? Icons.filter_list_off
                        : Icons.filter_list),
                    onPressed: () {
                      ref
                          .read(exerciseFilterProvider.notifier)
                          .toggleShowFilters();
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
                ? _buildTabletLayout(setupData)
                : _buildMobileLayout(setupData),
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
              right: BorderSide(
                color: Theme.of(context).dividerColor.withValues(alpha: 0.3),
              ),
            ),
          ),
          child: const FilterPanel(),
        ),
        // Exercise List
        Expanded(
          flex: 2,
          child: ExerciseList(setupData),
        ),
        // Exercise Detail Panel
        Consumer(
          builder: (context, ref, child) {
            final selectedExercise = ref.watch(exerciseFilterProvider
                .select((state) => state.selectedExercise));
            if (selectedExercise == null) return const SizedBox.shrink();
            return Container(
              width: 400,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                border: Border(
                  left: BorderSide(
                    color:
                        Theme.of(context).dividerColor.withValues(alpha: 0.3),
                  ),
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

  Widget _buildTabletLayout(Settings setupData) {
    return Row(
      children: [
        // Collapsible Filters Panel
        Consumer(
          builder: (context, ref, child) {
            final showFilters = ref.watch(exerciseFilterProvider
                .select((state) => state.showFilters));
            if (!showFilters) return const SizedBox.shrink();
            return Container(
              width: 280,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                border: Border(
                  right: BorderSide(
                    color: Theme.of(context)
                        .dividerColor
                        .withValues(alpha: 0.3),
                  ),
                ),
              ),
              child: const FilterPanel(),
            );
          },
        ),
        // Exercise List
        Expanded(
          child: ExerciseList(setupData),
        ),
      ],
    );
  }

  Widget _buildMobileLayout(Settings setupData) {
    return Column(
      children: [
        Consumer(
          builder: (context, ref, child) {
            final showFilters = ref.watch(
                exerciseFilterProvider.select((state) => state.showFilters));
            if (!showFilters) return const SizedBox.shrink();
            return const FilterMobile();
          },
        ),
        Expanded(
          child: ExerciseList(setupData),
        ),
      ],
    );
  }
}
