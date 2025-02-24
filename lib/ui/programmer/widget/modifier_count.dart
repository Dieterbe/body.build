import 'package:flutter/material.dart';
import 'package:bodybuild/data/programmer/modifier.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';

class ModifierCount extends StatefulWidget {
  final List<Modifier> modifiers;
  final Map<String, String> selectedOptions;
  final Function(String modifierName, String option) onOptionSelected;
  final Map<String, (bool, String)> cues;
  final Map<String, bool> cueOptions;
  final Function(String cueName, bool enabled) onCueToggled;

  const ModifierCount({
    super.key,
    required this.modifiers,
    required this.selectedOptions,
    required this.onOptionSelected,
    required this.cues,
    required this.cueOptions,
    required this.onCueToggled,
  });

  @override
  State<ModifierCount> createState() => _ModifierCountState();
}

class _ModifierCountState extends State<ModifierCount> {
  late Map<String, bool> _localCueOptions;

  @override
  void initState() {
    super.initState();
    _localCueOptions = Map<String, bool>.from(widget.cueOptions);
  }

  @override
  void didUpdateWidget(ModifierCount oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.cueOptions != widget.cueOptions) {
      _localCueOptions = Map<String, bool>.from(widget.cueOptions);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.modifiers.isEmpty && widget.cues.isEmpty)
      return const SizedBox.shrink();

    final totalCount = widget.modifiers.length + widget.cues.length;
    
    final nonDefaultCount = widget.modifiers
        .where((m) =>
            widget.selectedOptions[m.name] != null &&
            widget.selectedOptions[m.name] != m.defaultVal)
        .length +
    widget.cues.entries
        .where((entry) =>
            widget.cueOptions[entry.key] != null &&
            widget.cueOptions[entry.key] != entry.value.$1)
        .length;

    return InkWell(
      onTap: () async {
        await showDialog<void>(
          context: context,
          builder: (context) => StatefulBuilder(
            builder: (context, dialogSetState) => AlertDialog(
              title: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Exercise Modifiers & Cues',
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
Exercise modifiers and cues let you customize how an exercise is performed.

Modifiers may affect:
* muscle recruitment level (reflected in volume counts)
* muscle activation & growth stimulus
* equipment used
* technique
* development of secondary goals such as mobility, grip, core stability, etc

Cues don't affect muscle recruitment but may affect activation (and therefore strength and size gains).  
They are in this application such that:
* you are reminded of your cues in the gym
* you will be able to analyze your stats separately based on cues, to see if any particular cues helped with your gains.


In the future, you'll be able to add any cues you can come up with.
''',
                            styleSheet: MarkdownStyleSheet(
                              p: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.width / 110,
                                color: Theme.of(context).colorScheme.onSurface,
                                height: 1.4,
                              ),
                              listBullet: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.width / 110,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                              listBulletPadding:
                                  const EdgeInsets.only(right: 6),
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
                  children: [
                    if (widget.modifiers.isNotEmpty) ...[
                      Text(
                        'Modifiers',
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width / 90,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ...widget.modifiers
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
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width /
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
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width /
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
                                      children:
                                          modifier.opts.keys.map((option) {
                                        final isSelected = option ==
                                            (widget.selectedOptions[
                                                    modifier.name] ??
                                                modifier.defaultVal);
                                        return TextButton(
                                          onPressed: () {
                                            widget.onOptionSelected(
                                                modifier.name, option);
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
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width /
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
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  110,
                                              color:
                                                  Theme.of(context).hintColor,
                                              height: 1.4,
                                            ),
                                            a: TextStyle(
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  110,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                              decoration: TextDecoration.none,
                                              fontWeight: FontWeight.w500,
                                            ),
                                            listBullet: TextStyle(
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  110,
                                              color:
                                                  Theme.of(context).hintColor,
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
                    ],
                    if (widget.cues.isNotEmpty) ...[
                      if (widget.modifiers.isNotEmpty)
                        const SizedBox(height: 24),
                      Text(
                        'Cues',
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width / 90,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ...widget.cues.entries.map((entry) => Container(
                            margin: const EdgeInsets.only(bottom: 24),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.surface,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: Theme.of(context).dividerColor,
                                width: 1,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        entry.key,
                                        style: TextStyle(
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              100,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    Switch(
                                      value: _localCueOptions[entry.key] ??
                                          entry.value.$1,
                                      onChanged: (value) {
                                        dialogSetState(() {
                                          setState(() {
                                            _localCueOptions[entry.key] = value;
                                          });
                                          widget.onCueToggled(entry.key, value);
                                        });
                                      },
                                    ),
                                  ],
                                ),
                                if (entry.value.$2.isNotEmpty) ...[
                                  const SizedBox(height: 8),
                                  MarkdownBody(
                                    data: entry.value.$2,
                                    onTapLink: (text, href, title) async {
                                      if (href != null) {
                                        final uri = Uri.parse(href);
                                        if (await canLaunchUrl(uri)) {
                                          await launchUrl(uri);
                                        }
                                      }
                                    },
                                    styleSheet: MarkdownStyleSheet(
                                      p: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.width /
                                                110,
                                        color: Theme.of(context).hintColor,
                                        height: 1.4,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          )),
                    ],
                  ],
                ),
              ),
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: nonDefaultCount > 0
              ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: nonDefaultCount > 0
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).dividerColor,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.tune,
              size: MediaQuery.of(context).size.width / 100,
              color: nonDefaultCount > 0
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).hintColor,
            ),
            const SizedBox(width: 4),
            Text(
              '$nonDefaultCount / $totalCount',
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.width / 110,
                fontWeight: FontWeight.w500,
                color: nonDefaultCount > 0
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).hintColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
