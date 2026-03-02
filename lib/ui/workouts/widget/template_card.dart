import 'package:bodybuild/model/programmer/set_group.dart';
import 'package:bodybuild/model/workouts/workout_template.dart';
import 'package:bodybuild/ui/core/widget/exercise_id_text.dart';
import 'package:bodybuild/ui/core/widget/recruitment_bar_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TemplateCard extends ConsumerStatefulWidget {
  const TemplateCard({super.key, required this.template, this.onTap});

  final WorkoutTemplate template;

  /// If `null`, the card is not tappable.
  final void Function(String templateId)? onTap;

  @override
  ConsumerState<TemplateCard> createState() => _TemplateCardState();
}

class _TemplateCardState extends ConsumerState<TemplateCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    child: Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: widget.onTap == null
            ? () => setState(() => _expanded = !_expanded)
            : () => widget.onTap!(widget.template.id),
        onLongPress: widget.onTap != null ? () => setState(() => _expanded = !_expanded) : null,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
            borderRadius: BorderRadius.circular(12),
          ),
          child: _buildCardContent(context),
        ),
      ),
    ),
  );

  Widget _buildCardContent(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          Icon(
            widget.template.isBuiltin ? Icons.star : Icons.bookmark,
            color: Theme.of(context).colorScheme.primary,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              widget.template.name,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          Icon(
            _expanded ? Icons.expand_less : Icons.expand_more,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            size: 20,
          ),
        ],
      ),
      if (widget.template.description != null) ...[
        const SizedBox(height: 8),
        Text(
          widget.template.description!,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
        ),
      ],
      const SizedBox(height: 12),
      Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 4,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.fitness_center,
                    size: 14,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${widget.template.toFlatSets().length} sets',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Icon(Icons.list, size: 14, color: Theme.of(context).colorScheme.onSurfaceVariant),
                  const SizedBox(width: 4),
                  Text(
                    '${widget.template.toFlatSets().map((s) => s.exerciseId).toSet().length} exercises',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(child: RecruitmentBarChart(widget.template.calculateRecruitments(), 40)),
        ],
      ),
      if (_expanded) ...[
        const SizedBox(height: 12),
        Divider(color: Theme.of(context).colorScheme.outlineVariant, height: 1),
        const SizedBox(height: 12),
        _TemplateExpandedContent(template: widget.template),
      ],
    ],
  );
}

class _TemplateExpandedContent extends StatelessWidget {
  const _TemplateExpandedContent({required this.template});

  final WorkoutTemplate template;

  @override
  Widget build(BuildContext context) {
    final setGroups = template.workout.setGroups;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        for (var i = 0; i < setGroups.length; i++) _SetGroupRow(setGroup: setGroups[i], index: i),
      ],
    );
  }
}

class _SetGroupRow extends StatelessWidget {
  const _SetGroupRow({required this.setGroup, required this.index});

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
