import 'package:bodybuild/data/dataset/equipment.dart';
import 'package:bodybuild/ui/exercises/widget/equipment_filter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bodybuild/data/exercises/exercise_filter_provider.dart';
import 'package:bodybuild/ui/core/exercise_search_bar.dart';
import 'package:bodybuild/ui/core/muscle_group_selector.dart';

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
          ExerciseSearchBar(initialValue: filterState.query, onChanged: filterNotifier.setQuery),
          const SizedBox(height: 12),
          // Quick Filters Row
          Row(
            children: [
              // Muscle Group Chip
              Expanded(
                child: MuscleGroupSelector(
                  selectedMuscleGroup: filterState.selectedMuscleGroup,
                  onChanged: filterNotifier.setMuscleGroup,
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
                      color: filterState.availEquipment.isNotEmpty
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

  void _showEquipmentPicker(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Equipment'),
        content: const SizedBox(
          width: double.maxFinite,
          child: Column(
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
    final count = filterState.availEquipment.length;

    if (count == Equipment.values.length) {
      return 'Equipment: all';
    }
    return 'Equipment: $count/${Equipment.values.length}';
  }
}
