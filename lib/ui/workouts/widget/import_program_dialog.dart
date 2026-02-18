import 'package:bodybuild/data/workouts/template_providers.dart';
import 'package:bodybuild/ui/core/widget/snackbars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Dialog for importing a workout program from JSON
class ImportProgramDialog extends ConsumerStatefulWidget {
  const ImportProgramDialog({super.key});

  @override
  ConsumerState<ImportProgramDialog> createState() => _ImportProgramDialogState();
}

class _ImportProgramDialogState extends ConsumerState<ImportProgramDialog> {
  final _controller = TextEditingController();
  bool _isImporting = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleImport() async {
    final jsonString = _controller.text.trim();
    if (jsonString.isEmpty) {
      if (mounted) {
        showErrorSnackBar(context, 'Please paste program JSON');
      }
      return;
    }

    setState(() => _isImporting = true);

    try {
      final result = await ref
          .read(templateManagerProvider.notifier)
          .importProgramFromJson(jsonString);

      if (!mounted) return;

      if (result.success) {
        Navigator.of(context).pop();
        showSuccessSnackBar(
          context,
          'Imported ${result.templates.length} workout${result.templates.length == 1 ? '' : 's'}',
        );

        if (result.migrationApplied) {
          showInfoSnackBar(context, 'Exercise migrations were applied');
        }
      } else {
        showErrorSnackBar(context, result.error ?? 'Import failed');
      }
    } catch (e) {
      if (mounted) {
        showErrorSnackBar(context, 'Import failed: $e');
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
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Paste the program JSON below:', style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 16),
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: '{"formatVersion": 1, "exerciseDatasetVersion": ...}',
                border: OutlineInputBorder(),
              ),
              maxLines: 10,
              enabled: !_isImporting,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isImporting ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _isImporting ? null : _handleImport,
          child: _isImporting
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Import'),
        ),
      ],
    );
  }
}
