import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddSetDialog extends StatefulWidget {
  const AddSetDialog({super.key});

  @override
  State<AddSetDialog> createState() => _AddSetDialogState();
}

class _AddSetDialogState extends State<AddSetDialog> {
  final _formKey = GlobalKey<FormState>();
  final _weightController = TextEditingController();
  final _repsController = TextEditingController();
  final _rirController = TextEditingController();
  final _commentsController = TextEditingController();

  @override
  void dispose() {
    _weightController.dispose();
    _repsController.dispose();
    _rirController.dispose();
    _commentsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Set'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Weight input
            TextFormField(
              controller: _weightController,
              decoration: const InputDecoration(
                labelText: 'Weight (kg)',
                border: OutlineInputBorder(),
                isDense: true,
              ),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))],
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Weight is required';
                }
                final weight = double.tryParse(value);
                if (weight == null || weight <= 0) {
                  return 'Please enter a valid weight';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Reps input
            TextFormField(
              controller: _repsController,
              decoration: const InputDecoration(
                labelText: 'Reps',
                border: OutlineInputBorder(),
                isDense: true,
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Reps is required';
                }
                final reps = int.tryParse(value);
                if (reps == null || reps <= 0) {
                  return 'Please enter a valid number of reps';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // RIR input
            TextFormField(
              controller: _rirController,
              decoration: const InputDecoration(
                labelText: 'RIR (Reps in Reserve)',
                border: OutlineInputBorder(),
                isDense: true,
                helperText: 'How many more reps you could have done',
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'RIR is required';
                }
                final rir = int.tryParse(value);
                if (rir == null || rir < 0 || rir > 10) {
                  return 'Please enter a valid RIR (0-10)';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Comments input (optional)
            TextFormField(
              controller: _commentsController,
              decoration: const InputDecoration(
                labelText: 'Comments (optional)',
                border: OutlineInputBorder(),
                isDense: true,
              ),
              maxLines: 2,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
        ElevatedButton(onPressed: _saveSet, child: const Text('Add Set')),
      ],
    );
  }

  void _saveSet() {
    if (_formKey.currentState!.validate()) {
      final weight = double.parse(_weightController.text);
      final reps = int.parse(_repsController.text);
      final rir = int.parse(_rirController.text);
      final comments = _commentsController.text.trim();

      Navigator.of(context).pop({
        'weight': weight,
        'reps': reps,
        'rir': rir,
        'comments': comments.isEmpty ? null : comments,
      });
    }
  }
}
