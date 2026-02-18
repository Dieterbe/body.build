import 'package:bodybuild/data/workouts/template_providers.dart';
import 'package:bodybuild/model/workouts/template.dart';
import 'package:bodybuild/ui/core/widget/snackbars.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Dialog for exporting workout templates as a program
class ExportProgramDialog extends ConsumerStatefulWidget {
  final List<WorkoutTemplate> templates;

  const ExportProgramDialog({super.key, required this.templates});

  @override
  ConsumerState<ExportProgramDialog> createState() => _ExportProgramDialogState();
}

class _ExportProgramDialogState extends ConsumerState<ExportProgramDialog> {
  final _programNameController = TextEditingController();
  final Set<String> _selectedTemplateIds = {};
  bool _isExporting = false;

  @override
  void initState() {
    super.initState();
    _selectedTemplateIds.addAll(widget.templates.map((t) => t.id));
    _programNameController.text = _inferProgramName();
  }

  @override
  void dispose() {
    _programNameController.dispose();
    super.dispose();
  }

  String _inferProgramName() {
    if (widget.templates.isEmpty) return '';
    if (widget.templates.length == 1) return widget.templates.first.name;

    final names = widget.templates.map((t) => t.name).toList();
    final firstParts = names.first.split(' / ');

    if (firstParts.length < 2) return '';

    final programPrefix = firstParts.first;
    final allMatch = names.every((name) => name.startsWith('$programPrefix / '));

    return allMatch ? programPrefix : '';
  }

  Future<void> _handleExport(ExportMode mode) async {
    final selectedTemplates = widget.templates
        .where((t) => _selectedTemplateIds.contains(t.id))
        .toList();

    if (selectedTemplates.isEmpty) {
      if (mounted) {
        showErrorSnackBar(context, 'Please select at least one template');
      }
      return;
    }

    setState(() => _isExporting = true);

    try {
      final programName = _programNameController.text.trim().isEmpty
          ? null
          : _programNameController.text.trim();

      if (mode == ExportMode.share) {
        await ref
            .read(templateManagerProvider.notifier)
            .exportAndShareTemplates(templates: selectedTemplates, programName: programName);
        if (mounted) {
          Navigator.of(context).pop();
        }
      } else {
        final jsonString = ref
            .read(templateManagerProvider.notifier)
            .exportTemplatesAsJson(templates: selectedTemplates, programName: programName);

        await Clipboard.setData(ClipboardData(text: jsonString));
        if (mounted) {
          Navigator.of(context).pop();
          showSuccessSnackBar(context, 'Program JSON copied to clipboard');
        }
      }
    } catch (e) {
      if (mounted) {
        showErrorSnackBar(context, 'Export failed: $e');
      }
    } finally {
      if (mounted) {
        setState(() => _isExporting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Export Program'),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _programNameController,
              decoration: const InputDecoration(
                labelText: 'Program Name (optional)',
                border: OutlineInputBorder(),
              ),
              enabled: !_isExporting,
            ),
            const SizedBox(height: 16),
            Text('Select workouts to export:', style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 8),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: widget.templates.length,
                itemBuilder: (context, index) {
                  final template = widget.templates[index];
                  return CheckboxListTile(
                    title: Text(template.name),
                    subtitle: Text('${template.toFlatSets().length} sets'),
                    value: _selectedTemplateIds.contains(template.id),
                    enabled: !_isExporting,
                    onChanged: (selected) {
                      setState(() {
                        if (selected == true) {
                          _selectedTemplateIds.add(template.id);
                        } else {
                          _selectedTemplateIds.remove(template.id);
                        }
                      });
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isExporting ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: _isExporting ? null : () => _handleExport(ExportMode.copy),
          child: const Text('Copy JSON'),
        ),
        FilledButton.icon(
          onPressed: _isExporting ? null : () => _handleExport(ExportMode.share),
          icon: _isExporting
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.share),
          label: const Text('Share'),
        ),
      ],
    );
  }
}

enum ExportMode { copy, share }
