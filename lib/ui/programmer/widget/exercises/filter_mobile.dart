import 'package:bodybuild/data/programmer/equipment.dart';
import 'package:bodybuild/data/programmer/groups.dart';
import 'package:bodybuild/ui/programmer/widget/exercises/equipment_filter.dart';
import 'package:flutter/material.dart';

class FilterMobile extends StatelessWidget {
  const FilterMobile({
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
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).dividerColor.withValues(alpha: 0.3),
          ),
        ),
      ),
      child: Column(
        children: [
          // Search Bar
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
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
          ),
          const SizedBox(height: 12),
          // Quick Filters Row
          Row(
            children: [
              // Muscle Group Chip
              Expanded(
                child: GestureDetector(
                  onTap: () => _showMuscleGroupPicker(context),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      border: Border.all(color: Theme.of(context).dividerColor),
                      borderRadius: BorderRadius.circular(8),
                      color: selectedMuscleGroup != null
                          ? Theme.of(context)
                              .colorScheme
                              .primary
                              .withValues(alpha: 0.1)
                          : null,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.fitness_center, size: 16),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            selectedMuscleGroup?.displayName ?? 'All muscles',
                            style: const TextStyle(fontSize: 12),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Icon(Icons.arrow_drop_down, size: 16),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // Equipment Chip
              Expanded(
                child: GestureDetector(
                  onTap: () => _showEquipmentPicker(context),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      border: Border.all(color: Theme.of(context).dividerColor),
                      borderRadius: BorderRadius.circular(8),
                      color: selectedEquipmentCategories.isNotEmpty ||
                              selectedEquipment.isNotEmpty
                          ? Theme.of(context)
                              .colorScheme
                              .primary
                              .withValues(alpha: 0.1)
                          : null,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.build, size: 16),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            _getEquipmentFilterText(),
                            style: const TextStyle(fontSize: 12),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Icon(Icons.arrow_drop_down, size: 16),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showMuscleGroupPicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Select Muscle Group'),
        children: [
          SimpleDialogOption(
            onPressed: () {
              setMuscleGroup(null);
              Navigator.pop(context);
            },
            child: const Text('All muscle groups'),
          ),
          ...ProgramGroup.values.map((group) => SimpleDialogOption(
                onPressed: () {
                  setMuscleGroup(group);
                  Navigator.pop(context);
                },
                child: Text(group.displayName),
              )),
        ],
      ),
    );
  }

  void _showEquipmentPicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Select Equipment'),
          content: Container(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Equipment list
                Flexible(
                  child: EquipmentFilter(
                    selectedEquipment: selectedEquipment,
                    selectedEquipmentCategories: selectedEquipmentCategories,
                    onToggleEquipment: (equipment, selected) {
                      onToggleEquipment(equipment, selected);
                      setState(() {}); // Trigger dialog rebuild
                    },
                    onToggleEquipmentCategory: (category, selected) {
                      onToggleEquipmentCategory(category, selected);
                      setState(() {}); // Trigger dialog rebuild
                    },
                    setAllEquipment: () {
                      setAllEquipment();
                      setState(() {}); // Trigger dialog rebuild
                    },
                    setNoEquipment: () {
                      setNoEquipment();
                      setState(() {}); // Trigger dialog rebuild
                    },
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Done'),
            ),
          ],
        ),
      ),
    );
  }

  String _getEquipmentFilterText() {
    final catBased = Equipment.values
        .where((eq) => selectedEquipmentCategories.contains(eq.category))
        .length;
    final count = selectedEquipment.length + catBased;

    if (count == Equipment.values.length) {
      return 'Equipment: all';
    }
    return 'Equipment: $count/${Equipment.values.length}';
  }
}
