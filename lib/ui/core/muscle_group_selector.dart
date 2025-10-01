import 'package:flutter/material.dart';
import 'package:bodybuild/data/programmer/groups.dart';

class MuscleGroupSelector extends StatelessWidget {
  final ProgramGroup? selectedMuscleGroup;
  final ValueChanged<ProgramGroup?> onChanged;

  const MuscleGroupSelector({
    super.key,
    required this.selectedMuscleGroup,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<ProgramGroup?>(
      initialValue: selectedMuscleGroup,
      onSelected: onChanged,
      itemBuilder: (context) => [
        const PopupMenuItem<ProgramGroup?>(value: null, child: Text('All muscle groups')),
        ...ProgramGroup.values.map(
          (group) => PopupMenuItem<ProgramGroup?>(value: group, child: Text(group.displayNameLong)),
        ),
      ],
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).dividerColor),
          borderRadius: BorderRadius.circular(8),
          color: selectedMuscleGroup != null
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
                selectedMuscleGroup?.displayNameShort ?? 'All muscles',
                style: const TextStyle(fontSize: 12),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const Icon(Icons.arrow_drop_down, size: 16),
          ],
        ),
      ),
    );
  }
}
