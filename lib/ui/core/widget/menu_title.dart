import 'package:flutter/material.dart';

/// A title widget for menus/dialogs with optional back button and icon
class MenuTitle extends StatelessWidget {
  /// The main title text
  final String title;

  /// Optional icon to display before the title (if onBack is null)
  final IconData? icon;

  /// Callback to use with a back button
  final VoidCallback? onBack;

  const MenuTitle({super.key, required this.title, this.icon, this.onBack});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              if (onBack != null) IconButton(icon: const Icon(Icons.arrow_back), onPressed: onBack),
              if (onBack == null && icon != null)
                Icon(icon, color: Theme.of(context).colorScheme.primary),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 1),
      ],
    );
  }
}
