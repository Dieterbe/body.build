import 'package:bodybuild/data/workouts/workout_providers.dart';
import 'package:bodybuild/model/workouts/template.dart';
import 'package:bodybuild/ui/core/widget/snackbars.dart';
import 'package:bodybuild/ui/workouts/page/workout_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class TemplateCard extends ConsumerWidget {
  const TemplateCard({super.key, required this.template});

  final WorkoutTemplate template;

  @override
  Widget build(BuildContext context, WidgetRef ref) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    child: Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _handleTemplateSelection(context, ref),
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
            template.isBuiltin ? Icons.star : Icons.bookmark,
            color: Theme.of(context).colorScheme.primary,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              template.name,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      if (template.description != null) ...[
        const SizedBox(height: 8),
        Text(
          template.description!,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
        ),
      ],
      const SizedBox(height: 12),
      Row(
        children: [
          Icon(
            Icons.fitness_center,
            size: 14,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 4),
          Text(
            '${template.sets.length} sets',
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
          ),
          const SizedBox(width: 16),
          Icon(Icons.list, size: 14, color: Theme.of(context).colorScheme.onSurfaceVariant),
          const SizedBox(width: 4),
          Text(
            '${template.sets.map((s) => s.exerciseId).toSet().length} exercises',
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
          ),
        ],
      ),
    ],
  );

  Future<void> _handleTemplateSelection(BuildContext context, WidgetRef ref) async {
    try {
      await ref.read(workoutManagerProvider.notifier).startWorkoutFromTemplate(template.id);
      if (!context.mounted) return;
      Navigator.of(context).pop();
      context.go('/${WorkoutScreen.routeNameActive}');
    } catch (e) {
      if (context.mounted) {
        showErrorSnackBar(context, 'Error loading template: $e');
      }
    }
  }
}
