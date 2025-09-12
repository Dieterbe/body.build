import 'package:bodybuild/ui/programmer/widget/exercises/filter_mobile.dart';
import 'package:bodybuild/ui/programmer/widget/exercises/filter_panel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bodybuild/data/programmer/exercises.dart';
import 'package:bodybuild/data/programmer/groups.dart';
import 'package:bodybuild/data/programmer/setup.dart';
import 'package:bodybuild/model/programmer/set_group.dart';
import 'package:bodybuild/ui/programmer/widget/exercise_details_dialog.dart';
import 'package:bodybuild/ui/programmer/widget/rating_icon.dart';
import 'package:bodybuild/ui/programmer/util_groups.dart';
import 'package:bodybuild/ui/core/widget/navigation_drawer.dart';
import 'package:bodybuild/data/exercises/exercise_filter_provider.dart';

class ExercisesScreen extends ConsumerStatefulWidget {
  static const String routeName = 'exercises';

  const ExercisesScreen({super.key});

  @override
  ConsumerState<ExercisesScreen> createState() => _ExercisesScreenState();
}

class _ExercisesScreenState extends ConsumerState<ExercisesScreen> {
  @override
  Widget build(BuildContext context) {
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

  Widget _buildDesktopLayout(setupData) {
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
          child: _buildExerciseList(setupData),
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
              child: _buildExerciseDetail(setupData),
            );
          },
        ),
      ],
    );
  }

  Widget _buildTabletLayout(setupData) {
    return Stack(
      children: [
        Row(
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
              child: _buildExerciseList(setupData),
            ),
          ],
        ),
        // Exercise Detail Modal
        Consumer(
          builder: (context, ref, child) {
            final selectedExercise = ref.watch(exerciseFilterProvider
                .select((state) => state.selectedExercise));
            if (selectedExercise == null) return const SizedBox.shrink();
            return _buildExerciseDetailModal(setupData);
          },
        ),
      ],
    );
  }

  Widget _buildMobileLayout(setupData) {
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
          child: _buildExerciseList(setupData),
        ),
      ],
    );
  }

  Widget _buildExerciseList(setupData) {
    return Consumer(
      builder: (context, ref, child) {
        final filteredExercises = ref.watch(filteredExercisesProvider);
        final selectedExercise = ref.watch(
            exerciseFilterProvider.select((state) => state.selectedExercise));

        return _buildExerciseListContent(
            filteredExercises, selectedExercise, setupData);
      },
    );
  }

  Widget _buildExerciseListContent(
      List<Ex> filteredExercises, Ex? selectedExercise, setupData) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            border: Border(
              bottom: BorderSide(
                color: Theme.of(context).dividerColor.withValues(alpha: 0.3),
              ),
            ),
          ),
          child: Row(
            children: [
              Text(
                'Exercises',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const Spacer(),
              Text(
                '${filteredExercises.length} exercises',
                style: TextStyle(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: filteredExercises.length,
            itemBuilder: (context, index) {
              final exercise = filteredExercises[index];
              final isSelected = selectedExercise == exercise;

              return Container(
                decoration: BoxDecoration(
                  color: isSelected
                      ? Theme.of(context)
                          .colorScheme
                          .primary
                          .withValues(alpha: 0.1)
                      : null,
                  border: Border(
                    bottom: BorderSide(
                      color:
                          Theme.of(context).dividerColor.withValues(alpha: 0.1),
                    ),
                  ),
                ),
                child: ListTile(
                  title: Text(
                    exercise.id,
                    style: TextStyle(
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (exercise.equipment.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Wrap(
                          spacing: 4,
                          children: exercise.equipment
                              .map((eq) => Chip(
                                    label: Text(
                                      eq.displayName,
                                      style: const TextStyle(fontSize: 10),
                                    ),
                                    materialTapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                    visualDensity: VisualDensity.compact,
                                  ))
                              .toList(),
                        ),
                      ],
                      const SizedBox(height: 4),
                      _buildMuscleRecruitmentBar(exercise, setupData),
                    ],
                  ),
                  trailing: exercise.ratings.isNotEmpty
                      ? RatingIcon(ratings: exercise.ratings)
                      : null,
                  onTap: () {
                    final newSelection = isSelected ? null : exercise;
                    ref
                        .read(exerciseFilterProvider.notifier)
                        .setSelectedExercise(newSelection);

                    // On mobile, show modal
                    if (MediaQuery.of(context).size.width <= 768 &&
                        newSelection != null) {
                      _showExerciseDetailModal(setupData);
                    }
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMuscleRecruitmentBar(Ex exercise, setupData) {
    final recruitmentData = <ProgramGroup, double>{};
    for (final group in ProgramGroup.values) {
      final recruitment = exercise.recruitment(group, {});
      if (recruitment.volume > 0) {
        recruitmentData[group] = recruitment.volume;
      }
    }

    if (recruitmentData.isEmpty) return const SizedBox.shrink();

    return Container(
      height: 10,
      margin: const EdgeInsets.only(top: 4),
      child: Row(
        children: recruitmentData.entries.map((entry) {
          final group = entry.key;
          final volume = entry.value;
          return Expanded(
            flex: (volume * 100).round(),
            child: Container(
              margin: const EdgeInsets.only(right: 0.5),
              decoration: BoxDecoration(
                color: bgColorForProgramGroup(group).withValues(alpha: 0.7),
                borderRadius: BorderRadius.circular(1),
              ),
              child: Tooltip(
                message:
                    '${group.displayName}: ${(volume * 100).toStringAsFixed(0)}%',
                child: Container(),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildExerciseDetail(setupData) {
    return Consumer(
      builder: (context, ref, child) {
        final selectedExercise = ref.watch(
            exerciseFilterProvider.select((state) => state.selectedExercise));
        if (selectedExercise == null) return const SizedBox.shrink();

        final exercise = selectedExercise;
        final dummySets = Sets(1, ex: exercise);

        return SingleChildScrollView(
          child: ExerciseDetailsDialog(
            sets: dummySets,
            setup: setupData,
            onClose: () {
              ref
                  .read(exerciseFilterProvider.notifier)
                  .setSelectedExercise(null);
            },
          ),
        );
      },
    );
  }

  Widget _buildExerciseDetailForModal(setupData, BuildContext dialogContext) {
    return Consumer(
      builder: (context, ref, child) {
        final selectedExercise = ref.watch(
            exerciseFilterProvider.select((state) => state.selectedExercise));
        if (selectedExercise == null) return const SizedBox.shrink();

        final exercise = selectedExercise;
        final dummySets = Sets(1, ex: exercise);

        return SingleChildScrollView(
          child: ExerciseDetailsDialog(
            sets: dummySets,
            setup: setupData,
            onClose: () {
              ref
                  .read(exerciseFilterProvider.notifier)
                  .setSelectedExercise(null);
              Navigator.pop(dialogContext);
            },
          ),
        );
      },
    );
  }

  Widget _buildExerciseDetailModal(setupData) {
    return Container(
      color: Colors.black54,
      child: Center(
        child: Container(
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.all(16),
          constraints: const BoxConstraints(maxWidth: 600, maxHeight: 700),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: _buildExerciseDetail(setupData),
        ),
      ),
    );
  }

  void _showExerciseDetailModal(setupData) {
    showDialog(
      context: context,
      builder: (dialogContext) => Dialog(
        insetPadding: const EdgeInsets.all(20),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 600, maxHeight: 700),
          padding: const EdgeInsets.all(16),
          child: _buildExerciseDetailForModal(setupData, dialogContext),
        ),
      ),
    );
  }
}
