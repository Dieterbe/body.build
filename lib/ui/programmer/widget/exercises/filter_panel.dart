import 'package:bodybuild/data/programmer/equipment.dart';
import 'package:bodybuild/data/programmer/groups.dart';
import 'package:bodybuild/ui/programmer/widget/exercises/equipment_filter.dart';
import 'package:flutter/material.dart';

class FilterPanel extends StatelessWidget {
  const FilterPanel({
    super.key,
    required this.searchController,
    required this.setQuery,
    required this.setAllEquipment,
    required this.setNoEquipment,
    required this.selectedMuscleGroup,
    required this.setMuscleGroup,
    required this.selectedEquipment,
    required this.selectedEquipmentCategories,
    required this.onToggleEquipment,
    required this.onToggleEquipmentCategory,
  });

  final TextEditingController searchController;
  final void Function(String) setQuery;
  final void Function() setAllEquipment;
  final void Function() setNoEquipment;
  final void Function(ProgramGroup?) setMuscleGroup;
  final ProgramGroup? selectedMuscleGroup;
  final Set<Equipment> selectedEquipment;
  final Set<EquipmentCategory> selectedEquipmentCategories;
  final void Function(Equipment, bool?) onToggleEquipment;
  final void Function(EquipmentCategory, bool?) onToggleEquipmentCategory;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Filters',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(height: 16),

        // Search Filter
        TextField(
          controller: searchController,
          onChanged: setQuery,
          decoration: InputDecoration(
            hintText: 'Search exercises...',
            prefixIcon: const Icon(Icons.search),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            filled: true,
            fillColor:
                Theme.of(context).colorScheme.primary.withValues(alpha: 0.05),
          ),
        ),
        const SizedBox(height: 24),

        // Muscle Group Filter
        Text(
          'Muscle Group',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).dividerColor),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<ProgramGroup?>(
              value: selectedMuscleGroup,
              hint: const Text('All muscle groups'),
              isExpanded: true,
              items: [
                const DropdownMenuItem<ProgramGroup?>(
                  value: null,
                  child: Text('All muscle groups'),
                ),
                ...ProgramGroup.values.map((group) => DropdownMenuItem(
                      value: group,
                      child: Text(group.displayName),
                    )),
              ],
              onChanged: setMuscleGroup,
            ),
          ),
        ),

        const SizedBox(height: 24),

        // Equipment Filter
        Text(
          'Equipment',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: SingleChildScrollView(
            child: EquipmentFilter(
              selectedEquipment: selectedEquipment,
              selectedEquipmentCategories: selectedEquipmentCategories,
              onToggleEquipment: onToggleEquipment,
              onToggleEquipmentCategory: onToggleEquipmentCategory,
              setAllEquipment: setAllEquipment,
              setNoEquipment: setNoEquipment,
            ),
          ),
        ),
      ],
    );
  }
}
