import 'package:bodybuild/data/programmer/equipment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bodybuild/data/exercises/exercise_filter_provider.dart';
import 'package:bodybuild/model/programmer/set_group.dart';
import 'package:bodybuild/model/programmer/settings.dart';
import 'package:bodybuild/ui/programmer/widget/exercise_details_dialog.dart';

class ExerciseDetailPanel extends ConsumerWidget {
  final Settings setupData;
  final BuildContext? pop;

  const ExerciseDetailPanel({super.key, required this.setupData, this.pop});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(exerciseFilterProvider);

    if (filter.selectedExercise == null) return const SizedBox.shrink();

    return ExerciseDetailsDialog(
      sets: Sets(1, ex: filter.selectedExercise!, tweakOptions: filter.selectedTweakOptions),
      setup: setupData,
      onChangeTweaks: (sets) {
        // Update the selected exercise with new tweak options
        ref
            .read(exerciseFilterProvider.notifier)
            .setSelectedExercise(sets.ex, tweakOptions: sets.tweakOptions);
      },
      onClose: () {
        ref.read(exerciseFilterProvider.notifier).setSelectedExercise(null);
        if (pop != null) Navigator.pop(pop!);
      },
      scrollableTweakGrid: true,
      constrainWidth: true,
      // Note: in the "exercises browser", we have our own equipment filter,
      // so we don't use the one from setup
      availEquipment: filter.selectedEquipment.union(
        Equipment.values
            .where((equipment) => filter.selectedEquipmentCategories.contains(equipment.category))
            .toSet(),
      ),
    );
  }
}
