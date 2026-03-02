import 'package:bodybuild/model/interchange/program_export.dart';
import 'package:bodybuild/ui/interchange/program_file_io.dart';
import 'package:flutter/material.dart';

/// Shared dialog for exporting a program to a JSON file.
///
/// [onExport] is called when the user confirms — it should return the
/// [ProgramExport] to save (e.g. built from selected templates or from the
/// current programmer state). It may show its own UI before returning.
/// Throw to cancel with an error.
///
/// [canExport] optionally controls whether the export button should be enabled.
/// If null, the button is always enabled (default behavior).
class ExportProgramDialog extends StatefulWidget {
  final Future<ProgramExport> Function() onExport;
  final Widget content;
  final bool Function()? canExport;

  const ExportProgramDialog({
    super.key,
    required this.onExport,
    required this.content,
    this.canExport,
  });

  @override
  State<ExportProgramDialog> createState() => _ExportProgramDialogState();
}

class _ExportProgramDialogState extends State<ExportProgramDialog> {
  bool _isExporting = false;
  String? _error;

  Future<void> _handleExport() async {
    setState(() {
      _isExporting = true;
      _error = null;
    });

    try {
      final export = await widget.onExport();
      await saveProgramFile(export);
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (mounted) setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _isExporting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final canExport = widget.canExport?.call() ?? true;

    return AlertDialog(
      title: const Text('Export Program'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          widget.content,
          if (_error != null) ...[
            const SizedBox(height: 12),
            Text(_error!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: _isExporting ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton.icon(
          onPressed: (_isExporting || !canExport) ? null : _handleExport,
          icon: _isExporting
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.save_alt),
          label: const Text('Save File'),
        ),
      ],
    );
  }
}
