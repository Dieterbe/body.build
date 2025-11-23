import 'package:bodybuild/data/workouts/template_providers.dart';
import 'package:bodybuild/model/workouts/template.dart';
import 'package:bodybuild/ui/core/widget/handle_bar.dart';
import 'package:bodybuild/ui/core/widget/menu_title.dart';
import 'package:bodybuild/ui/workouts/widget/template_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TemplatePickerSheet extends ConsumerWidget {
  /// If true, shows as inline content (no bottom sheet styling). Default: false
  final bool isInline;

  /// Optional back button callback for inline mode
  final VoidCallback? onBack;

  const TemplatePickerSheet({super.key, this.isInline = false, this.onBack});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final templatesAsync = ref.watch(templateManagerProvider);

    return isInline
        ? Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              MenuTitle(title: 'Load Template', onBack: onBack),
              Expanded(child: _buildTemplatesList(context, templatesAsync, null)),
            ],
          )
        : DraggableScrollableSheet(
            initialChildSize: 0.6,
            minChildSize: 0.3,
            maxChildSize: 0.9,
            expand: false,
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                ),
                child: Column(
                  children: [
                    const HandleBar(),
                    const MenuTitle(title: 'Load Template', icon: Icons.fitness_center),
                    Expanded(child: _buildTemplatesList(context, templatesAsync, scrollController)),
                  ],
                ),
              );
            },
          );
  }

  Widget _buildTemplatesList(
    BuildContext context,
    AsyncValue<List<WorkoutTemplate>> templatesAsync,
    ScrollController? scrollController,
  ) {
    return templatesAsync.when(
      data: (templates) {
        if (templates.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.library_books_outlined,
                    size: 48,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(height: 16),
                  Text('No templates available', style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
            ),
          );
        }
        return ListView.builder(
          controller: scrollController,
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: templates.length,
          itemBuilder: (context, index) {
            return TemplateCard(template: templates[index]);
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error, size: 48, color: Theme.of(context).colorScheme.error),
              const SizedBox(height: 16),
              Text('Error loading templates: $error'),
            ],
          ),
        ),
      ),
    );
  }
}

void showTemplatePickerSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => const TemplatePickerSheet(),
  );
}
