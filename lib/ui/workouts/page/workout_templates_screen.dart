import 'package:bodybuild/data/workouts/template_provider.dart';
import 'package:bodybuild/model/workouts/workout_template.dart';
import 'package:bodybuild/ui/core/widget/app_navigation_drawer.dart';
import 'package:bodybuild/ui/interchange/import_program_dialog.dart';
import 'package:bodybuild/ui/workouts/widget/empty_templates_view.dart';
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
            ? EmptyTemplatesView(onImport: () => _showImportDialog(context))
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
