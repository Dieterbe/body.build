import 'package:bodybuild/data/dataset/equipment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bodybuild/data/exercises/exercise_filter_provider.dart';

class EquipmentFilter extends ConsumerWidget {
  const EquipmentFilter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filterState = ref.watch(exerciseFilterProvider);
    final filterNotifier = ref.read(exerciseFilterProvider.notifier);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Presets
        Row(
          children: [
            ElevatedButton(onPressed: filterNotifier.setAllEquipment, child: const Text('All')),
            const SizedBox(width: 8),
            ElevatedButton(onPressed: filterNotifier.setNoEquipment, child: const Text('None')),
          ],
        ),
        const SizedBox(height: 12),

        // Individual Non-machine and General Machine equipment
        ...Equipment.values
            .where(
              (eq) =>
                  eq.category == EquipmentCategory.nonMachine ||
                  eq.category == EquipmentCategory.generalMachines,
            )
            .map((equipment) {
              return CheckboxListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                title: Text(equipment.displayName, style: const TextStyle(fontSize: 13)),
                value: filterState.selectedEquipment.contains(equipment),
                onChanged: (selected) => filterNotifier.toggleEquipment(equipment, selected),
              );
            }),

        const SizedBox(height: 12),

        // Grouped machine categories
        ...[
          EquipmentCategory.upperBodyMachines,
          EquipmentCategory.lowerBodyMachines,
          EquipmentCategory.coreAndGluteMachines,
        ].map(
          (category) => CheckboxListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            title: Text(
              category.displayName,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
            ),
            value: filterState.selectedEquipmentCategories.contains(category),
            onChanged: (selected) => filterNotifier.toggleEquipmentCategory(category, selected),
          ),
        ),
      ],
    );
  }
}
