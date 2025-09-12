import 'package:bodybuild/data/exercises/exercise_filter_provider.dart';
import 'package:bodybuild/model/programmer/settings.dart';
import 'package:bodybuild/ui/exercises/widget/exercise_detail_panel.dart';
import 'package:bodybuild/ui/exercises/widget/exercise_requitment_bar.dart';
import 'package:bodybuild/ui/programmer/widget/rating_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ExerciseList extends ConsumerWidget {
  final Settings setupData;
  const ExerciseList(this.setupData, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filteredExercises = ref.watch(filteredExercisesProvider);
    final selectedExercise = ref.watch(
        exerciseFilterProvider.select((state) => state.selectedExercise));

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
                      MuscleRecruitmentBar(
                          exercise: exercise, setup: setupData),
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

                    // On mobile and tablet, show modal dialog
                    if (MediaQuery.of(context).size.width <= 1024 &&
                        newSelection != null) {
                      _showExerciseDetailModal(setupData, context);
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
    );
  }
}
