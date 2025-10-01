import 'package:bodybuild/data/programmer/equipment.dart';
import 'package:bodybuild/data/programmer/groups.dart';
import 'package:bodybuild/ui/exercises/widget/equipment_filter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bodybuild/data/exercises/exercise_filter_provider.dart';

class FilterMobile extends ConsumerWidget {
  const FilterMobile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filterState = ref.watch(exerciseFilterProvider);
    final filterNotifier = ref.read(exerciseFilterProvider.notifier);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          bottom: BorderSide(color: Theme.of(context).dividerColor.withValues(alpha: 0.3)),
        ),
      ),
      child: Column(
        children: [
          // Search Bar
          TextFormField(
            initialValue: filterState.query,
            onChanged: filterNotifier.setQuery,
            decoration: InputDecoration(
              hintText: 'Search exercises...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              filled: true,
              fillColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.05),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
          ),
          const SizedBox(height: 12),
          // Quick Filters Row
          Row(
            children: [
              // Muscle Group Chip
              Expanded(
                child: GestureDetector(
                  onTap: () => _showMuscleGroupPicker(context, ref),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      border: Border.all(color: Theme.of(context).dividerColor),
                      borderRadius: BorderRadius.circular(8),
                      color: filterState.selectedMuscleGroup != null
                          ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.1)
                          : null,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.fitness_center, size: 16),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            filterState.selectedMuscleGroup?.displayNameShort ?? 'All muscles',
                            style: const TextStyle(fontSize: 12),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const Icon(Icons.arrow_drop_down, size: 16),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // Equipment Chip
              Expanded(
                child: GestureDetector(
                  onTap: () => _showEquipmentPicker(context, ref),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      border: Border.all(color: Theme.of(context).dividerColor),
                      borderRadius: BorderRadius.circular(8),
                      color:
                          filterState.selectedEquipmentCategories.isNotEmpty ||
                              filterState.selectedEquipment.isNotEmpty
                          ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.1)
                          : null,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.build, size: 16),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            _getEquipmentFilterText(filterState),
                            style: const TextStyle(fontSize: 12),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const Icon(Icons.arrow_drop_down, size: 16),
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

  void _showMuscleGroupPicker(BuildContext context, WidgetRef ref) {
    final filterNotifier = ref.read(exerciseFilterProvider.notifier);
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Select Muscle Group'),
        children: [
          SimpleDialogOption(
            onPressed: () {
              filterNotifier.setMuscleGroup(null);
              Navigator.pop(context);
            },
            child: const Text('All muscle groups'),
          ),
          ...ProgramGroup.values.map(
            (group) => SimpleDialogOption(
              onPressed: () {
                filterNotifier.setMuscleGroup(group);
                Navigator.pop(context);
              },
              child: Text(group.displayNameLong),
            ),
          ),
        ],
      ),
    );
  }

  void _showEquipmentPicker(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Equipment'),
        content: Container(
          width: double.maxFinite,
          child: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Equipment list
              Flexible(child: EquipmentFilter()),
            ],
          ),
        ),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Done'))],
      ),
    );
  }

  String _getEquipmentFilterText(ExerciseFilterState filterState) {
    final catBased = Equipment.values
        .where((eq) => filterState.selectedEquipmentCategories.contains(eq.category))
        .length;
    final count = filterState.selectedEquipment.length + catBased;

    if (count == Equipment.values.length) {
      return 'Equipment: all';
    }
    return 'Equipment: $count/${Equipment.values.length}';
  }
}
