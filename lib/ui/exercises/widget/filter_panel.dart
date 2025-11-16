import 'package:bodybuild/data/dataset/groups.dart';
import 'package:bodybuild/ui/exercises/widget/equipment_filter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bodybuild/data/exercises/exercise_filter_provider.dart';

class FilterPanel extends ConsumerWidget {
  const FilterPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filterState = ref.watch(exerciseFilterProvider);
    final filterNotifier = ref.read(exerciseFilterProvider.notifier);
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
        TextFormField(
          initialValue: filterState.query,
          onChanged: filterNotifier.setQuery,
          decoration: InputDecoration(
            hintText: 'Search exercises...',
            prefixIcon: const Icon(Icons.search),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            filled: true,
            fillColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.05),
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
              value: filterState.selectedMuscleGroup,
              hint: const Text('All muscle groups'),
              isExpanded: true,
              items: [
                const DropdownMenuItem<ProgramGroup?>(
                  value: null,
                  child: Text('All muscle groups'),
                ),
                ...ProgramGroup.values.map(
                  (group) => DropdownMenuItem(value: group, child: Text(group.displayNameShort)),
                ),
              ],
              onChanged: filterNotifier.setMuscleGroup,
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
        const Expanded(child: SingleChildScrollView(child: EquipmentFilter())),
      ],
    );
  }
}
