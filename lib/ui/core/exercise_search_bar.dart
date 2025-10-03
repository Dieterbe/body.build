import 'package:flutter/material.dart';

class ExerciseSearchBar extends StatelessWidget {
  final String initialValue;
  final ValueChanged<String> onChanged;
  final String hintText;

  const ExerciseSearchBar({
    super.key,
    required this.initialValue,
    required this.onChanged,
    this.hintText = 'Search exercises...',
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: const Icon(Icons.search),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        filled: true,
        fillColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.05),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
    );
  }
}
