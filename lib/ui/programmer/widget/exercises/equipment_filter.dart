import 'package:bodybuild/data/programmer/equipment.dart';
import 'package:flutter/material.dart';

class EquipmentFilter extends StatelessWidget {
  const EquipmentFilter({
    super.key,
    required this.selectedEquipment,
    required this.selectedEquipmentCategories,
    required this.onToggleEquipment,
    required this.onToggleEquipmentCategory,
    required this.setAllEquipment,
    required this.setNoEquipment,
  });

  final Set<Equipment> selectedEquipment;
  final Set<EquipmentCategory> selectedEquipmentCategories;
  final void Function(Equipment, bool?) onToggleEquipment;
  final void Function(EquipmentCategory, bool?) onToggleEquipmentCategory;
  final void Function() setAllEquipment;
  final void Function() setNoEquipment;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Presets
        Row(
          children: [
            ElevatedButton(
              onPressed: setAllEquipment,
              child: const Text('All'),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: setNoEquipment,
              child: const Text('None'),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Individual Non-machine and General Machine equipment
        ...Equipment.values
            .where((eq) =>
                eq.category == EquipmentCategory.nonMachine ||
                eq.category == EquipmentCategory.generalMachines)
            .map((equipment) {
          return CheckboxListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            title: Text(
              equipment.displayName,
              style: const TextStyle(fontSize: 13),
            ),
            value: selectedEquipment.contains(equipment),
            onChanged: (selected) => onToggleEquipment(equipment, selected),
          );
        }),

        const SizedBox(height: 12),

        // Grouped machine categories
        ...[
          EquipmentCategory.upperBodyMachines,
          EquipmentCategory.lowerBodyMachines,
          EquipmentCategory.coreAndGluteMachines,
        ].map((category) {
          final isSelected = selectedEquipmentCategories.contains(category);
          return CheckboxListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            title: Text(
              category.displayName,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
            ),
            value: isSelected,
            onChanged: (selected) =>
                onToggleEquipmentCategory(category, selected),
          );
        }),
      ],
    );
  }
}
