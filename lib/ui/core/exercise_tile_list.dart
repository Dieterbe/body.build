import 'package:bodybuild/data/programmer/exercises.dart';
import 'package:bodybuild/model/programmer/set_group.dart';
import 'package:bodybuild/ui/exercises/widget/exercise_requitment_bar.dart';
import 'package:bodybuild/ui/programmer/widget/rating_icon.dart';
import 'package:flutter/material.dart';

// advantages of having the expandable/collapsablie variations here:
// 1. main results immediatey show more breadth of exercise library
// 2. can search "into" an exercise, e.g. user might type "incline bench" and we could take them
//    into the corresponding variation(s) directly, not showing the rest
// 3. we wouldn't want to show all variations as distinct search hits, that gets excessive
//    due to many small tweaks like bench angles etc
// However this system also has definite downsides:
// 1. when you select an exercise, you can change all tweaks anyway
//    (and we will have more room to visualize their recruitments)
// 2. for different variations, we would ideally also show their different
//    recruitments here, but space is already cramped.
// 3. navigation/selection behavior is a bit broken on desktop/web, e.g.
//    selecting different variations doesn't update the UI properly, it unselects
// 4. the dropdown button needs a lot of space on mobile

class ExerciseTileList extends StatelessWidget {
  final List<Ex> exercises;
  final Function(String exerciseId, Map<String, String> tweaks) onExerciseSelected;
  final Set<String> expandedExercises;
  final Function(String exerciseId)? onToggleExpansion;
  final String? emptyMessage;

  /// Optional: ID of the currently selected exercise for highlighting
  final String? selectedExerciseId;

  /// Optional: Show header with exercise count
  final bool showHeader;

  /// Optional: Exercise count for header (defaults to exercises.length)
  final int? exerciseCount;

  const ExerciseTileList({
    super.key,
    required this.exercises,
    required this.onExerciseSelected,
    this.expandedExercises = const {},
    this.onToggleExpansion,
    this.emptyMessage,
    this.selectedExerciseId,
    this.showHeader = false,
    this.exerciseCount,
  });

  /// Generate all variations for an exercise, similar to the "add set for" dialog
  /// but not specific to a PG, and not using "real" parameters for user
  /// this is just to display variations of an exercise in a generic way
  /// HERE generate variations
  List<Sets> _generateExerciseVariations(Ex exercise) {
    // If no tweaks create variations, return a single Sets with default values
    if (exercise.tweaks.isEmpty) {
      return [Sets(80, ex: exercise, tweakOptions: {})];
    }

    // Collect all tweak options that affect any program group
    Map<String, List<String>> tweakOptions = {};
    for (final tweak in exercise.tweaks) {
      tweakOptions[tweak.name] = tweak.opts.keys.toList();
    }
    // Generate all possible combinations of tweak options
    var allCombinations = [
      {for (var entry in tweakOptions.entries) entry.key: entry.value.first},
    ];

    tweakOptions.forEach((name, options) {
      allCombinations = allCombinations
          .expand((combo) => options.map((opt) => {...combo, name: opt}))
          .toList();
    });
    // Create a Sets object for each unique combination
    return allCombinations.map((tweaks) => Sets(80, ex: exercise, tweakOptions: tweaks)).toList();
  }

  @override
  Widget build(BuildContext context) {
    if (exercises.isEmpty) {
      return _buildEmptyState(context);
    }

    final listView = ListView.builder(
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

    if (!showHeader) {
      return listView;
    }

    return Column(
      children: [
        _buildHeader(context),
        Expanded(child: listView),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          bottom: BorderSide(color: Theme.of(context).dividerColor.withValues(alpha: 0.3)),
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
            '${exerciseCount ?? exercises.length} exercises',
            style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7)),
          ),
        ],
      ),
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
    final isSelected = selectedExerciseId == exercise.id;

    return InkWell(
      onTap: () => onExerciseSelected(exercise.id, {}),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.1) : null,
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
                // without this, material will use:
                // - 48x48 on mobile (need sufficiently large touch target),
                // - 24x24 on desktop (mouse pointers are more precise)
                // we enforce the same style everywhere so we can give non-expandable tiles
                // the same padding to align to the expandable ones
                style: IconButton.styleFrom(
                  // Flutter 3.7+ (Material 3)
                  minimumSize: const Size.square(48), // or 48 for strict Material
                  tapTargetSize:
                      MaterialTapTargetSize.shrinkWrap, // optional, to avoid auto-48 on touch
                  padding: EdgeInsets.zero, // makes the size driven by minimumSize
                ),
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
                          style: TextStyle(
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                            fontSize: 16, // TODO: needed?
                          ),
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
                  MuscleRecruitmentBar(exercise: exercise),
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
      onTap: () => onExerciseSelected(exercise.id, variation.tweakOptions),
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
                  if (variation.tweakOptions.isNotEmpty)
                    Expanded(
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 4,
                        children: variation.tweakOptions.entries.map((entry) {
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
