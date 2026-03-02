import 'package:bodybuild/model/interchange/program_export.dart';
import 'package:bodybuild/model/programmer/program_state.dart';
import 'package:bodybuild/model/workouts/workout_template.dart';
import 'package:bodybuild/ui/interchange/export_program_dialog.dart';
import 'package:bodybuild/ui/workouts/widget/workout_scheduling_widget.dart';
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
  late final Map<String, (int timesPerPeriod, int periodWeeks)> _schedulingSettings;

  @override
  void initState() {
    super.initState();
    _selectedIds = widget.templates.map((t) => t.id).toSet();
    _nameController = TextEditingController(text: _inferProgramName());
    // Initialize scheduling settings with default values from templates
    _schedulingSettings = {
      for (var template in widget.templates)
        template.id: (template.workout.timesPerPeriod, template.workout.periodWeeks),
    };
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
    if (selected.isEmpty) throw Exception('Please select at least one workout to export');
    final name = _nameController.text.trim().isEmpty
        ? _inferProgramName()
        : _nameController.text.trim();

    // Apply scheduling settings to workouts
    final workouts = selected.map((t) {
      final scheduling = _schedulingSettings[t.id] ?? (1, 1);
      return t.workout.copyWith(timesPerPeriod: scheduling.$1, periodWeeks: scheduling.$2);
    }).toList();

    final program = ProgramState(name: name, workouts: workouts, builtin: false);
    return ProgramExport.fromProgram(program, exportedFrom: 'body.build mobile app');
  }

  @override
  Widget build(BuildContext context) {
    return ExportProgramDialog(
      onExport: _buildExport,
      canExport: () => _selectedIds.isNotEmpty,
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
          Text('Select workouts to include:', style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 8),
          ...widget.templates.map((t) {
            final isSelected = _selectedIds.contains(t.id);
            final scheduling = _schedulingSettings[t.id] ?? (1, 1);

            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.5)
                      : Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
                  width: isSelected ? 2 : 1,
                ),
                color: isSelected
                    ? Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.1)
                    : Theme.of(context).colorScheme.surface,
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        // Checkbox with its own tap area
                        InkWell(
                          onTap: () => setState(
                            () => isSelected ? _selectedIds.remove(t.id) : _selectedIds.add(t.id),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Checkbox(
                              value: isSelected,
                              onChanged: (v) => setState(
                                () =>
                                    v == true ? _selectedIds.add(t.id) : _selectedIds.remove(t.id),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Workout info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                t.name,
                                style: Theme.of(
                                  context,
                                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${t.toFlatSets().length} sets',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface.withValues(alpha: 0.7),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    // Scheduling controls (only when selected)
                    if (isSelected) ...[
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
                          ),
                        ),
                        child: WorkoutSchedulingWidget(
                          timesPerPeriod: scheduling.$1,
                          periodWeeks: scheduling.$2,
                          onChanged: (timesPerPeriod, periodWeeks) {
                            setState(() {
                              _schedulingSettings[t.id] = (timesPerPeriod, periodWeeks);
                            });
                          },
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
