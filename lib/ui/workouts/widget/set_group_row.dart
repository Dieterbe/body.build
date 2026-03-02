import 'package:bodybuild/model/programmer/set_group.dart';
import 'package:bodybuild/ui/core/widget/exercise_id_text.dart';
import 'package:flutter/material.dart';

class SetGroupRow extends StatelessWidget {
  const SetGroupRow({super.key, required this.setGroup, required this.index});

  final SetGroup setGroup;
  final int index;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final sets = setGroup.sets;

    if (sets.isEmpty) return const SizedBox.shrink();

    final isComboSet = sets.length > 1;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 4,
        children: [
          if (isComboSet)
            Text(
              'combo set',
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          for (final s in sets)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      '${s.n}×',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: s.ex != null
                          ? ExerciseIdText(
                              exercise: s.ex!,
                              idStyle: theme.textTheme.bodySmall,
                              showAliases: true,
                            )
                          : Text('Unknown exercise', style: theme.textTheme.bodySmall),
                    ),
                  ],
                ),
                if (s.tweakOptions.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Wrap(
                    spacing: 4,
                    runSpacing: 2,
                    children: s.tweakOptions.entries.map((entry) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                            color: theme.colorScheme.primary.withValues(alpha: 0.5),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              entry.key,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                            const SizedBox(width: 2),
                            Text(
                              entry.value,
                              style: TextStyle(fontSize: 10, color: theme.colorScheme.primary),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ],
            ),
        ],
      ),
    );
  }
}
