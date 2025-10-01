import 'package:bodybuild/data/programmer/exercises.dart';
import 'package:bodybuild/model/programmer/settings.dart';
import 'package:bodybuild/model/programmer/set_group.dart';
import 'package:bodybuild/ui/exercises/widget/exercise_requitment_bar.dart';
import 'package:bodybuild/ui/programmer/widget/rating_icon.dart';
import 'package:flutter/material.dart';

class ExerciseTileList extends StatelessWidget {
  final List<Ex> exercises;
  final Settings setup;
  final Function(String exerciseId, Map<String, String> modifiers) onExerciseSelected;
  final Set<String> expandedExercises;
  final Function(String exerciseId)? onToggleExpansion;
  final String? emptyMessage;

  const ExerciseTileList({
    super.key,
    required this.exercises,
    required this.setup,
    required this.onExerciseSelected,
    this.expandedExercises = const {},
    this.onToggleExpansion,
    this.emptyMessage,
  });

  /// Generate all variations for an exercise
  List<Sets> _generateExerciseVariations(Ex exercise) {
    if (exercise.modifiers.isEmpty) {
      return [Sets(80, ex: exercise, modifierOptions: {})];
    }

    Map<String, List<String>> modifierOptions = {};
    for (final modifier in exercise.modifiers) {
      modifierOptions[modifier.name] = modifier.opts.keys.toList();
    }

    var allCombinations = [
      {for (var entry in modifierOptions.entries) entry.key: entry.value.first},
    ];

    modifierOptions.forEach((name, options) {
      allCombinations = allCombinations
          .expand((combo) => options.map((opt) => {...combo, name: opt}))
          .toList();
    });

    return allCombinations
        .map((modifiers) => Sets(80, ex: exercise, modifierOptions: modifiers))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    if (exercises.isEmpty) {
      return _buildEmptyState(context);
    }

    return ListView.builder(
      itemCount: exercises.length,
      itemBuilder: (context, index) {
        final exercise = exercises[index];
        final variations = _generateExerciseVariations(exercise);
        final isExpanded = expandedExercises.contains(exercise.id);
        final hasVariations = variations.length > 1;

        return Column(
          children: [
            _buildExerciseTile(context, exercise, hasVariations, isExpanded),
            if (isExpanded && hasVariations)
              ...variations.map((variation) => _buildVariationTile(context, exercise, variation)),
          ],
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            emptyMessage ?? 'No exercises found',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your search or filter criteria',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExerciseTile(
    BuildContext context,
    Ex exercise,
    bool hasVariations,
    bool isExpanded,
  ) {
    return InkWell(
      onTap: () => onExerciseSelected(exercise.id, {}),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.5),
              width: 1,
            ),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Expand/collapse button for variations
            if (hasVariations && onToggleExpansion != null)
              IconButton(
                icon: Icon(
                  isExpanded ? Icons.expand_less : Icons.expand_more,
                  color: Theme.of(context).colorScheme.primary,
                ),
                onPressed: () => onToggleExpansion!(exercise.id),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              )
            else
              const SizedBox(width: 48),
            const SizedBox(width: 8),
            // Exercise details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Exercise name with ratings and variation count
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          exercise.id,
                          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                        ),
                      ),
                      if (hasVariations)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${_generateExerciseVariations(exercise).length} variations',
                            style: TextStyle(
                              fontSize: 12,
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      const SizedBox(width: 8),
                      if (exercise.ratings.isNotEmpty)
                        RatingIcon(ratings: exercise.ratings, size: 20),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Equipment chips
                  if (exercise.equipment.isNotEmpty) ...[
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: exercise.equipment.map((eq) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                              color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            eq.displayName,
                            style: TextStyle(
                              fontSize: 11,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 8),
                  ],

                  // Muscle recruitment bar
                  MuscleRecruitmentBar(exercise: exercise, setup: setup),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVariationTile(BuildContext context, Ex exercise, Sets variation) {
    return InkWell(
      onTap: () => onExerciseSelected(exercise.id, variation.modifierOptions),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.5),
          border: Border(
            bottom: BorderSide(color: Theme.of(context).dividerColor.withValues(alpha: 0.05)),
            left: BorderSide(
              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
              width: 3,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 56),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      exercise.id,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
                    ),
                  ),
                  if (variation.modifierOptions.isNotEmpty)
                    Expanded(
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 4,
                        children: variation.modifierOptions.entries.map((entry) {
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
                                width: 1,
                              ),
                            ),
                            child: Text(
                              '${entry.key}: ${entry.value}',
                              style: TextStyle(
                                fontSize: 10,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
