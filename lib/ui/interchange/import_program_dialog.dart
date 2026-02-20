import 'package:bodybuild/data/dataset/exercise_versioning.dart';
import 'package:bodybuild/model/interchange/program_export.dart'
    show ProgramExport, programExportFormatVersion;
import 'package:bodybuild/model/programmer/program_state.dart';
import 'package:bodybuild/service/program_import_service.dart';
import 'package:flutter/material.dart';

/// Shared dialog for importing a program from a JSON file.
///
/// [onImport] receives the migrated+validated [ProgramState] and is responsible
/// for persisting it (e.g. as templates or as a programmer program).
/// It should throw on failure.
class ImportProgramDialog extends StatefulWidget {
  final Future<void> Function(ProgramState program) onImport;

  const ImportProgramDialog({super.key, required this.onImport});

  @override
  State<ImportProgramDialog> createState() => _ImportProgramDialogState();
}

class _ImportProgramDialogState extends State<ImportProgramDialog> {
  bool _isImporting = false;
  String? _error;

  Future<void> _handlePick() async {
    setState(() {
      _isImporting = true;
      _error = null;
    });

    try {
      final export = await ProgramImportService.pickFile();
      if (export == null) {
        if (mounted) setState(() => _isImporting = false);
        return;
      }

      final versionError = _checkVersions(export);
      if (versionError != null) {
        if (mounted) setState(() => _error = versionError);
        return;
      }

      // Apply exercise migration + validation (no DB needed)
      final result = ProgramImportService.migrateAndValidate(export);

      await widget.onImport(result.program);
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (mounted) setState(() => _error = 'Import failed: $e');
    } finally {
      if (mounted) setState(() => _isImporting = false);
    }
  }

  String? _checkVersions(ProgramExport export) {
    if (export.formatVersion > programExportFormatVersion) {
      return 'Export format v${export.formatVersion} is not supported '
          '(max: v$programExportFormatVersion). Please update the app.';
    }
    if (export.exerciseDatasetVersion > exerciseDatasetVersion) {
      return 'Export requires exercise dataset v${export.exerciseDatasetVersion}, '
          'but this app only supports v$exerciseDatasetVersion. Please update the app.';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Import Program'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select a .json file exported from body.build.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          if (_error != null) ...[
            const SizedBox(height: 12),
            Text(_error!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: _isImporting ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton.icon(
          onPressed: _isImporting ? null : _handlePick,
          icon: _isImporting
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.folder_open),
          label: const Text('Choose File'),
        ),
      ],
    );
  }
}
