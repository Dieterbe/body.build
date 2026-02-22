import 'package:bodybuild/model/interchange/program_export.dart';
import 'package:bodybuild/model/programmer/program_state.dart';
import 'package:bodybuild/ui/interchange/program_file_io.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Shared dialog for importing a program from a JSON file.
///
/// [onImport] receives the migrated+validated [ProgramState] and a [WidgetRef]
/// for persisting it (e.g. as templates or as a programmer program).
/// It should throw on failure.
class ImportProgramDialog extends ConsumerStatefulWidget {
  final Future<void> Function(ProgramState program, WidgetRef ref) onImport;

  const ImportProgramDialog({super.key, required this.onImport});

  @override
  ConsumerState<ImportProgramDialog> createState() => _ImportProgramDialogState();
}

class _ImportProgramDialogState extends ConsumerState<ImportProgramDialog> {
  bool _isImporting = false;
  String? _error;

  Future<void> _handlePick() async {
    // Prevent multiple simultaneous imports
    if (_isImporting) return;

    setState(() {
      _isImporting = true;
      _error = null;
    });

    ProgramExport? export;

    try {
      export = await pickProgramFile();
    } catch (e, stackTrace) {
      if (mounted) {
        setState(() {
          _error = 'Failed to read file: $e';
          _isImporting = false;
        });
        debugPrint('File picker error: $e\n$stackTrace');
      }
      return;
    }

    if (export == null) {
      debugPrint('User cancelled file picker: export is null');
      if (mounted) {
        setState(() => _isImporting = false);
      }
      return;
    }

    if (!mounted) {
      debugPrint('User cancelled file picker: UI has disappeared');
      return;
    }

    try {
      final program = export.migrateAndValidate();

      // Check if still mounted before calling onImport which might use providers
      if (!mounted) {
        debugPrint('User cancelled file picker: UI has disappeared');
        return;
      }
      await widget.onImport(program, ref);

      // Check again before popping
      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e, stackTrace) {
      if (mounted) {
        setState(() {
          _error = 'Import error: $e';
        });
        debugPrint('Import error: $e\n$stackTrace');
      }
    } finally {
      if (mounted) {
        setState(() => _isImporting = false);
      }
    }
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
            'Select a body.build program .json file',
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
