import 'package:bodybuild/data/dataset/exercises.dart';
import 'package:bodybuild/data/dataset/equipment.dart';
import 'package:bodybuild/ui/exercises/widget/exercise_requitment_bar.dart';
import 'package:bodybuild/ui/programmer/widget/rating_icon.dart';
import 'package:flutter/material.dart';

class ExerciseTileList extends StatelessWidget {
  final List<Ex> exercises;
  final Function(String exerciseId) onExerciseSelected;
  final String? emptyMessage;

  /// Optional: ID of the currently selected exercise for highlighting
  final String? selectedExerciseId;

  /// Optional: Show header with exercise count
  final bool showHeader;

  /// Optional: Exercise count for header (defaults to exercises.length)
  final int? exerciseCount;

  /// Optional: Available equipment for filtering displayed equipment
  /// (not for exercises, those should already be filtered!)
  final Set<Equipment>? availableEquipment;

  const ExerciseTileList({
    super.key,
    required this.exercises,
    required this.onExerciseSelected,
    this.emptyMessage,
    this.selectedExerciseId,
    this.showHeader = false,
    this.exerciseCount,
    this.availableEquipment,
  });

  @override
  Widget build(BuildContext context) {
    if (exercises.isEmpty) {
      return _buildEmptyState(context);
    }

    final listView = ListView.builder(
      itemCount: exercises.length,
      itemBuilder: (context, index) {
        final exercise = exercises[index];
        return _buildExerciseTile(context, exercise);
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

  Widget _buildExerciseTile(BuildContext context, Ex exercise) {
    final isSelected = selectedExerciseId == exercise.id;

    return InkWell(
      onTap: () => onExerciseSelected(exercise.id),
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
            const SizedBox(width: 16),
            // Exercise details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Exercise name with ratings
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
                      const SizedBox(width: 8),
                      if (exercise.ratings.isNotEmpty)
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: exercise.ratings
                              .map((r) => r.score)
                              .toSet()
                              .map((score) => RatingIcon(score: score))
                              .toList(),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Tweak names
                  if (exercise.tweaks.isNotEmpty) ...[
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: exercise.tweaks.map((tweak) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            tweak.name,
                            style: TextStyle(
                              fontSize: 11,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 8),
                  ],

                  _buildEquipmentChips(context, exercise, availableEquipment),
                  const SizedBox(height: 8),
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

  Widget _buildEquipmentChips(
    BuildContext context,
    Ex exercise,
    Set<Equipment>? availableEquipmentFilter,
  ) {
    final tweakOnlyEquipment = exercise.getEquipmentForAnyTweaks().difference(
      exercise.equipment.toSet(),
    );

    // Filter to only show available equipment if filter is provided
    // (we don't need to do this for the exercise.equipment because that would have
    // caused the exercise to not be shown at all.)
    final displayTweakOnlyEquipment = (availableEquipmentFilter != null)
        ? tweakOnlyEquipment.where((eq) => availableEquipmentFilter.contains(eq)).toSet()
        : tweakOnlyEquipment;
    if (exercise.equipment.isEmpty && displayTweakOnlyEquipment.isEmpty) {
      return const SizedBox.shrink();
    }

    // Create combined equipment text with truncation
    const maxLength = 30;
    final fullText = displayTweakOnlyEquipment
        .map((eq) => eq.displayName.replaceAll(' Machine', ''))
        .join(' / ');
    final tweakOnlyEquipmentText = fullText.length > maxLength
        ? '${fullText.substring(0, maxLength - 3)}...'
        : fullText;

    return Wrap(
      spacing: 6,
      runSpacing: 4,
      children:
          [
                ...exercise.equipment.map((eq) => eq.displayName),
                if (tweakOnlyEquipmentText.isNotEmpty) tweakOnlyEquipmentText,
              ]
              .map(
                (str) => Container(
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
                    str,
                    style: TextStyle(fontSize: 11, color: Theme.of(context).colorScheme.onSurface),
                  ),
                ),
              )
              .toList(),
    );
  }
}
