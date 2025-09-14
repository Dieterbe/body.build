import 'package:bodybuild/data/exercises/exercise_filter_provider.dart';
import 'package:bodybuild/data/programmer/exercises.dart';
import 'package:bodybuild/model/programmer/settings.dart';
import 'package:bodybuild/model/programmer/set_group.dart';
import 'package:bodybuild/model/programmer/parameters.dart';
import 'package:bodybuild/ui/exercises/widget/exercise_detail_panel.dart';
import 'package:bodybuild/ui/exercises/widget/exercise_requitment_bar.dart';
import 'package:bodybuild/ui/programmer/widget/rating_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ExerciseList extends ConsumerWidget {
  final Settings setupData;
  const ExerciseList(this.setupData, {super.key});

  /// Generate all variations for an exercise, similar to the "add set for" dialog
  /// but not specific to a PG, and not using "real" parameters for user
  /// this is just to display variations of an exercise in a generic way
  /// TODO: clean this up more
  List<Sets> _generateExerciseVariations(Ex exercise) {
    // If no modifiers create variations, return a single Sets with default values
    if (exercise.modifiers.isEmpty) {
      return [
        Sets(
          80,
          ex: exercise,
          modifierOptions: {},
        )
      ];
    }

    // Collect all modifier options that affect any program group
    Map<String, List<String>> modifierOptions = {};

    for (final modifier in exercise.modifiers) {
      modifierOptions[modifier.name] = modifier.opts.keys.toList();
    }

    // Generate all possible combinations of modifier options
    var allCombinations = [
      {for (var entry in modifierOptions.entries) entry.key: entry.value.first}
    ];

    modifierOptions.forEach((name, options) {
      allCombinations = allCombinations
          .expand((combo) => options.map((opt) => {...combo, name: opt}))
          .toList();
    });

    // Create a Sets object for each unique combination
    return allCombinations
        .map((modifiers) => Sets(
              80,
              ex: exercise,
              modifierOptions: modifiers,
            ))
        .toList();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filteredExercises = ref.watch(filteredExercisesProvider);
    final filterState = ref.watch(exerciseFilterProvider);
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
              final variations = _generateExerciseVariations(exercise);
              final isExpanded =
                  filterState.expandedExercises.contains(exercise.id);
              final hasVariations = variations.length > 1;

              return Column(
                children: [
                  // Base exercise item
                  Container(
                    decoration: BoxDecoration(
                      color: selectedExercise == exercise
                          ? Theme.of(context)
                              .colorScheme
                              .primary
                              .withValues(alpha: 0.1)
                          : null,
                      border: Border(
                        bottom: BorderSide(
                          color: Theme.of(context)
                              .dividerColor
                              .withValues(alpha: 0.1),
                        ),
                      ),
                    ),
                    child: ListTile(
                      leading: hasVariations
                          ? IconButton(
                              icon: Icon(
                                isExpanded
                                    ? Icons.expand_less
                                    : Icons.expand_more,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              onPressed: () {
                                ref
                                    .read(exerciseFilterProvider.notifier)
                                    .toggleExerciseExpansion(exercise.id);
                              },
                            )
                          : const SizedBox(width: 48),
                      title: Row(
                        children: [
                          Expanded(
                            child: Text(
                              exercise.id,
                              style: TextStyle(
                                fontWeight: selectedExercise == exercise
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                              ),
                            ),
                          ),
                          if (hasVariations)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                '${variations.length} variations',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                        ],
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
                        final newSelection =
                            selectedExercise == exercise ? null : exercise;
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
                  ),
                  // Variations (shown when expanded)
                  if (isExpanded && hasVariations)
                    ...variations.map((variation) => Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .surface
                                .withValues(alpha: 0.5),
                            border: Border(
                              bottom: BorderSide(
                                color: Theme.of(context)
                                    .dividerColor
                                    .withValues(alpha: 0.05),
                              ),
                              left: BorderSide(
                                color: Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withValues(alpha: 0.3),
                                width: 3,
                              ),
                            ),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.only(
                              left: 72, // Indent for variations
                              right: 16,
                              top: 8,
                              bottom: 8,
                            ),
                            title: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    exercise.id,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ),
                                if (variation.modifierOptions.isNotEmpty)
                                  Expanded(
                                    child: Wrap(
                                      spacing: 8,
                                      runSpacing: 4,
                                      children: variation
                                          .modifierOptions.entries
                                          .map((entry) {
                                        return Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 6,
                                            vertical: 2,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary
                                                .withValues(alpha: 0.1),
                                            borderRadius:
                                                BorderRadius.circular(4),
                                            border: Border.all(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary
                                                  .withValues(alpha: 0.3),
                                              width: 1,
                                            ),
                                          ),
                                          child: Text(
                                            '${entry.key}: ${entry.value}',
                                            style: TextStyle(
                                              fontSize: 10,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                              ],
                            ),
                            onTap: () {
                              // For variations, we still select the base exercise
                              // but could potentially store the variation info
                              ref
                                  .read(exerciseFilterProvider.notifier)
                                  .setSelectedExercise(exercise);

                              // On mobile and tablet, show modal dialog
                              if (MediaQuery.of(context).size.width <= 1024) {
                                _showExerciseDetailModal(setupData, context);
                              }
                            },
                          ),
                        )),
                ],
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
