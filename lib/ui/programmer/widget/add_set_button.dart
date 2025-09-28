import 'package:bodybuild/ui/programmer/widget/pulse_widget.dart';
import 'package:flutter/material.dart';

class AddSetButton extends StatelessWidget {
  final bool isEmpty;
  final VoidCallback onPressed;

  const AddSetButton(this.onPressed, {super.key, this.isEmpty = false});

  @override
  Widget build(BuildContext context) {
    return PulseMessageWidget(
      msg: 'Add a first set to this workout',
      pulse: isEmpty,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          backgroundColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
          foregroundColor: Theme.of(context).colorScheme.primary,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.add_circle_outline, size: 18, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 8),
            const Text(
              'Add Set',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, letterSpacing: 0.3),
            ),
          ],
        ),
      ),
    );
  }
}
