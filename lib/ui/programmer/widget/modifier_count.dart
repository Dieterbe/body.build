import 'package:flutter/material.dart';
import 'package:bodybuild/data/programmer/modifier.dart';

class ModifierCount extends StatelessWidget {
  final List<Modifier> modifiers;
  final Map<String, String> selectedOptions;
  final Function(String modifierName, String option) onOptionSelected;

  const ModifierCount({
    super.key,
    required this.modifiers,
    required this.selectedOptions,
    required this.onOptionSelected,
  });

  @override
  Widget build(BuildContext context) {
    if (modifiers.isEmpty) return const SizedBox.shrink();

    return InkWell(
      onTap: () {
        showDialog<void>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(
              'Exercise Modifiers',
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.width / 100,
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: modifiers.map((modifier) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          modifier.name,
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width / 110,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '(default: ${modifier.defaultValue})',
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width / 110,
                            color: Theme.of(context).hintColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: modifier.opts.keys.map((option) {
                        final isSelected = option ==
                            (selectedOptions[modifier.name] ??
                                modifier.defaultValue);
                        return TextButton(
                          onPressed: () {
                            onOptionSelected(modifier.name, option);
                            Navigator.pop(context);
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: isSelected
                                ? Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withValues(alpha: 0.1)
                                : null,
                            side: BorderSide(
                              color: isSelected
                                  ? Theme.of(context).colorScheme.primary
                                  : Colors.transparent,
                            ),
                          ),
                          child: Text(
                            option,
                            style: TextStyle(
                              fontSize: MediaQuery.of(context).size.width / 110,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                  ],
                );
              }).toList(),
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.tune,
              size: MediaQuery.of(context).size.width / 110,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 2),
            Text(
              '${modifiers.length}',
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.width / 110,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
