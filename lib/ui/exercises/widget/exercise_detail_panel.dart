import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bodybuild/data/exercises/exercise_filter_provider.dart';
import 'package:bodybuild/model/programmer/set_group.dart';
import 'package:bodybuild/model/programmer/settings.dart';
import 'package:bodybuild/ui/programmer/widget/exercise_details_dialog.dart';

class ExerciseDetailPanel extends ConsumerWidget {
  final Settings setupData;
  final BuildContext? pop;

  const ExerciseDetailPanel({
    super.key,
    required this.setupData,
    this.pop,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedExercise =
        ref.watch(exerciseFilterProvider.select((state) => state.selectedExercise));
    final selectedModifierOptions =
        ref.watch(exerciseFilterProvider.select((state) => state.selectedModifierOptions));

    if (selectedExercise == null) return const SizedBox.shrink();

    return SingleChildScrollView(
      child: ExerciseDetailsDialog(
        sets: Sets(1, ex: selectedExercise, modifierOptions: selectedModifierOptions),
        setup: setupData,
        onChangeModifiersCues: (sets) {
          // Update the selected exercise with new modifier options
          ref.read(exerciseFilterProvider.notifier).setSelectedExercise(
                sets.ex,
                modifierOptions: sets.modifierOptions,
              );
        },
        onClose: () {
          ref.read(exerciseFilterProvider.notifier).setSelectedExercise(null);
          if (pop != null) Navigator.pop(pop!);
        },
      ),
    );
  }
}
