import 'package:bodybuild/model/interchange/program_export.dart';
import 'package:bodybuild/model/programmer/program_state.dart';
import 'package:bodybuild/model/workouts/template.dart';
import 'package:bodybuild/ui/interchange/export_program_dialog.dart';
import 'package:flutter/material.dart';

/// Shows the export dialog for a list of workout templates.
void showExportProgramDialog(BuildContext context, List<WorkoutTemplate> templates) {
  showDialog(
    context: context,
    builder: (context) => _TemplateExportContent(templates: templates),
  );
}

/// Wraps the shared [ExportProgramDialog] with template-selection UI.
class _TemplateExportContent extends StatefulWidget {
  final List<WorkoutTemplate> templates;

  const _TemplateExportContent({required this.templates});

  @override
  State<_TemplateExportContent> createState() => _TemplateExportContentState();
}

class _TemplateExportContentState extends State<_TemplateExportContent> {
  late final TextEditingController _nameController;
  late final Set<String> _selectedIds;

  @override
  void initState() {
    super.initState();
    _selectedIds = widget.templates.map((t) => t.id).toSet();
    _nameController = TextEditingController(text: _inferProgramName());
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  String _inferProgramName() {
    if (widget.templates.isEmpty) return '';
    if (widget.templates.length == 1) return widget.templates.firstOrNull?.name ?? '';
    final names = widget.templates.map((t) => t.name).toList();
    final firstParts = names.firstOrNull?.split(' / ') ?? [];
    if (firstParts.length < 2) return '';
    final prefix = firstParts.firstOrNull ?? '';
    return names.every((n) => n.startsWith('$prefix / ')) ? prefix : '';
  }

  Future<ProgramExport> _buildExport() async {
    final selected = widget.templates.where((t) => _selectedIds.contains(t.id)).toList();
    if (selected.isEmpty) throw Exception('Please select at least one workout');
    final name = _nameController.text.trim().isEmpty
        ? _inferProgramName()
        : _nameController.text.trim();
    final workouts = selected.map((t) => t.workout).toList();
    final program = ProgramState(name: name, workouts: workouts, builtin: false);
    return ProgramExport.fromProgram(program, exportedFrom: 'body.build mobile app');
  }

  @override
  Widget build(BuildContext context) {
    return ExportProgramDialog(
      onExport: _buildExport,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Program Name (optional)',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          Text('Select workouts to export:', style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 8),
          ...widget.templates.map(
            (t) => CheckboxListTile(
              title: Text(t.name),
              subtitle: Text('${t.toFlatSets().length} sets'),
              value: _selectedIds.contains(t.id),
              onChanged: (v) =>
                  setState(() => v == true ? _selectedIds.add(t.id) : _selectedIds.remove(t.id)),
            ),
          ),
        ],
      ),
    );
  }
}
