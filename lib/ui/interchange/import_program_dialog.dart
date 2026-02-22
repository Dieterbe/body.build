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
/// [existingNames] is used to validate that the imported program name is unique.
class ImportProgramDialog extends ConsumerStatefulWidget {
  final Future<void> Function(ProgramState program, WidgetRef ref) onImport;
  final List<String> existingNames;

  const ImportProgramDialog({super.key, required this.onImport, this.existingNames = const []});

  @override
  ConsumerState<ImportProgramDialog> createState() => _ImportProgramDialogState();
}

class _ImportProgramDialogState extends ConsumerState<ImportProgramDialog> {
  bool _isImporting = false;
  String? _error;

  Future<String?> _showNameDialog(String suggestedName) {
    final controller = TextEditingController(text: suggestedName);
    final formKey = GlobalKey<FormFieldState>();

    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Import Program'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'A program with this name already exists. Please choose a different name:',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: controller,
              key: formKey,
              decoration: const InputDecoration(
                labelText: 'Program Name',
                hintText: 'Enter a unique name',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Name cannot be empty';
                }
                if (widget.existingNames.contains(value)) {
                  return 'This name already exists';
                }
                return null;
              },
              autovalidateMode: AutovalidateMode.onUserInteraction,
              autofocus: true,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          FilledButton(
            onPressed: () {
              if (formKey.currentState?.validate() ?? false) {
                Navigator.pop(context, controller.text);
              }
            },
            child: const Text('Import'),
          ),
        ],
      ),
    );
  }

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
      var program = export.migrateAndValidate();

      // Check if the program name already exists and show name dialog if needed
      String finalName = program.name;
      if (widget.existingNames.contains(program.name)) {
        final newName = await _showNameDialog('${program.name} (Imported)');
        if (newName == null) {
          // User cancelled the name dialog
          if (mounted) {
            setState(() => _isImporting = false);
          }
          return;
        }
        finalName = newName;
      }

      // Update the program name if it was changed
      if (finalName != program.name) {
        program = program.copyWith(name: finalName);
      }

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
