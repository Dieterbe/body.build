import 'package:bodybuild/data/workouts/template_provider.dart';
import 'package:bodybuild/model/workouts/template.dart';
import 'package:bodybuild/ui/core/widget/app_navigation_drawer.dart';
import 'package:bodybuild/ui/interchange/import_program_dialog.dart';
import 'package:bodybuild/ui/workouts/widget/export_program_dialog.dart';
import 'package:bodybuild/ui/workouts/widget/template_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WorkoutTemplatesScreen extends ConsumerWidget {
  static const String routeName = 'workout-templates';

  const WorkoutTemplatesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final templatesAsync = ref.watch(templateManagerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Workout Templates'),
        backgroundColor: Theme.of(context).colorScheme.surface,
        actions: [
          IconButton(
            icon: const Icon(Icons.file_download),
            tooltip: 'Import Program',
            onPressed: () => _showImportDialog(context),
          ),
          templatesAsync.when(
            data: (templates) => IconButton(
              icon: const Icon(Icons.file_upload),
              tooltip: 'Export Program',
              onPressed: templates.isEmpty ? null : () => _showExportDialog(context, templates),
            ),
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),
        ],
      ),
      drawer: const AppNavigationDrawer(),
      body: templatesAsync.when(
        data: (templates) => templates.isEmpty
            ? _EmptyTemplatesView(onImport: () => _showImportDialog(context))
            : ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: templates.length,
                itemBuilder: (context, index) => TemplateCard(template: templates[index]),
              ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error loading templates: $error')),
      ),
    );
  }

  void _showImportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => ImportProgramDialog(
        onImport: (program, ref) =>
            ref.read(templateManagerProvider.notifier).importTemplatesFromProgram(program),
      ),
    );
  }

  void _showExportDialog(BuildContext context, List<WorkoutTemplate> templates) {
    showExportProgramDialog(context, templates);
  }
}

class _EmptyTemplatesView extends StatelessWidget {
  final VoidCallback onImport;

  const _EmptyTemplatesView({required this.onImport});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.library_books_outlined,
              size: 64,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text('No workout templates yet', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(
              'Import a program from the workout programmer to get started.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: onImport,
              icon: const Icon(Icons.file_download),
              label: const Text('Import Program'),
            ),
          ],
        ),
      ),
    );
  }
}
