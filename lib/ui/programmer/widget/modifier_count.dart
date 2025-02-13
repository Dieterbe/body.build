import 'package:flutter/material.dart';
import 'package:bodybuild/data/programmer/modifier.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';

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
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Exercise Modifiers',
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width / 80,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  visualDensity: VisualDensity.compact,
                  icon: Icon(
                    Icons.info_outline,
                    size: MediaQuery.of(context).size.width / 100,
                    color: Theme.of(context).hintColor,
                  ),
                  onPressed: () {
                    showDialog<void>(
                      context: context,
                      builder: (context) => AlertDialog(
                        content: MarkdownBody(
                          data: '''# Exercise modifiers
Exercise modifiers let you customize how an exercise is performed.
These modifiers may affect:

* muscle recruitment level (reflected in volume counts)
* muscle activation & growth stimulus
* equipment used
* technique
* development of secondary goals such as mobility, grip, core stability, etc
''',
                          styleSheet: MarkdownStyleSheet(
                            p: TextStyle(
                              fontSize: MediaQuery.of(context).size.width / 110,
                              color: Theme.of(context).colorScheme.onSurface,
                              height: 1.4,
                            ),
                            listBullet: TextStyle(
                              fontSize: MediaQuery.of(context).size.width / 110,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                            listBulletPadding: const EdgeInsets.only(right: 6),
                            listIndent: 12,
                            blockSpacing: 8,
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
            titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
            contentPadding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: modifiers
                    .map((modifier) => Container(
                          margin: const EdgeInsets.only(bottom: 24),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Theme.of(context)
                                  .dividerColor
                                  .withValues(alpha: 0.5),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    modifier.name,
                                    style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.width /
                                              100,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    '(default: ${modifier.defaultVal})',
                                    style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.width /
                                              110,
                                      color: Theme.of(context).hintColor,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Wrap(
                                spacing: 12,
                                runSpacing: 8,
                                children: modifier.opts.keys.map((option) {
                                  final isSelected = option ==
                                      (selectedOptions[modifier.name] ??
                                          modifier.defaultVal);
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
                                            ? Theme.of(context)
                                                .colorScheme
                                                .primary
                                            : Colors.transparent,
                                        width: 1.5,
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 8,
                                      ),
                                    ),
                                    child: Text(
                                      option,
                                      style: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.width /
                                                110,
                                        fontWeight: isSelected
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                        color: isSelected
                                            ? Theme.of(context)
                                                .colorScheme
                                                .primary
                                            : Theme.of(context)
                                                .colorScheme
                                                .onSurface,
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                              if (modifier.desc != null) ...[
                                const SizedBox(height: 16),
                                Padding(
                                  padding: const EdgeInsets.only(left: 2),
                                  child: MarkdownBody(
                                    data: modifier.desc!,
                                    styleSheet: MarkdownStyleSheet(
                                      p: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.width /
                                                110,
                                        color: Theme.of(context).hintColor,
                                        height: 1.4,
                                      ),
                                      a: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.width /
                                                110,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        decoration: TextDecoration.none,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      listBullet: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.width /
                                                110,
                                        color: Theme.of(context).hintColor,
                                      ),
                                      listBulletPadding:
                                          const EdgeInsets.only(right: 6),
                                      listIndent: 12,
                                      blockSpacing: 8,
                                    ),
                                    onTapLink: (text, href, title) {
                                      if (href != null) {
                                        launchUrl(Uri.parse(href));
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ))
                    .toList(),
              ),
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
