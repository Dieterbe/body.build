import 'package:bodybuild/ui/core/markdown.dart';
import 'package:bodybuild/util.dart';
import 'package:flutter/material.dart';
import 'package:bodybuild/data/programmer/modifier.dart';
import 'package:bodybuild/data/programmer/rating.dart';
import 'package:bodybuild/model/programmer/set_group.dart';
import 'package:bodybuild/ui/programmer/widget/rating_icon.dart';

class ExModifiersCuesWidget extends StatefulWidget {
  final Sets sets;
  final List<Modifier> modifiers;
  final Map<String, String> selectedOptions;
  final Function(String modifierName, String option) onOptionSelected;
  final Map<String, (bool, String)> cues;
  final Map<String, bool> cueOptions;
  final Function(String cueName, bool enabled) onCueToggled;
  final Function(List<Rating> ratings) onShowRatings;

  const ExModifiersCuesWidget({
    super.key,
    required this.sets,
    required this.modifiers,
    required this.selectedOptions,
    required this.onOptionSelected,
    required this.cues,
    required this.cueOptions,
    required this.onCueToggled,
    required this.onShowRatings,
  });

  @override
  State<ExModifiersCuesWidget> createState() => _ExModifiersCuesWidgetState();
}

class _ExModifiersCuesWidgetState extends State<ExModifiersCuesWidget> {
  late Map<String, bool> _localCueOptions;

  @override
  void initState() {
    super.initState();
    _localCueOptions = Map<String, bool>.from(widget.cueOptions);
  }

  Widget _buildRatingIcon({
    String? modifierName,
    String? modifierValue,
    String? cueName,
    bool? cueEnabled,
    required BuildContext context,
  }) {
    if (widget.sets.ex == null) return const SizedBox.shrink();

    // Get ratings for current configuration
    final currentRatings = widget.sets
        .getApplicableRatingsForConfig(
          widget.selectedOptions,
          widget.cueOptions,
        )
        .toList();

    // Create a copy of current configuration
    final modifierConfig = Map<String, String>.from(widget.selectedOptions);
    final cueConfig = Map<String, bool>.from(widget.cueOptions);

    // Apply the specific option we're showing the rating for
    if (modifierName != null && modifierValue != null) {
      modifierConfig[modifierName] = modifierValue;
    }
    if (cueName != null && cueEnabled != null) {
      cueConfig[cueName] = cueEnabled;
    }

    // Get ratings for this configuration
    final ratings = widget.sets
        .getApplicableRatingsForConfig(
          modifierConfig,
          cueConfig,
        )
        .toList();

    // Only show rating icon if this option changes the ratings
    if (ratings.length == currentRatings.length) {
      bool sameRatings = true;
      for (int i = 0; i < ratings.length; i++) {
        if (ratings[i].score != currentRatings[i].score) {
          sameRatings = false;
          break;
        }
      }
      if (sameRatings) return const SizedBox.shrink();
    }

    return RatingIcon(
      ratings: ratings,
      onTap: ratings.isEmpty ? null : () => widget.onShowRatings(ratings),
    );
  }

  @override
  void didUpdateWidget(ExModifiersCuesWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.cueOptions != widget.cueOptions) {
      _localCueOptions = Map<String, bool>.from(widget.cueOptions);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.modifiers.isEmpty && widget.cues.isEmpty) {
      return const SizedBox.shrink();
    }

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
                          content: markdown('''# Exercise modifiers
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
''', context),
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
                      const SizedBox(height: 16),
                      ...widget.modifiers.map((modifier) => Padding(
                            padding: const EdgeInsets.only(bottom: 24),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  modifier.name.capitalizeFirstOnly(),
                                  style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.width / 90,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color:
                                        Theme.of(context).colorScheme.surface,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: Theme.of(context)
                                          .dividerColor
                                          .withValues(alpha: 0.5),
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      ...modifier.opts.entries.map((opt) {
                                        final isSelected = opt.key ==
                                            (widget.selectedOptions[
                                                    modifier.name] ??
                                                modifier.defaultVal);
                                        final optionDesc = opt.value.$2;
                                        return Material(
                                            color: Colors.transparent,
                                            child: InkWell(
                                                onTap: () {
                                                  widget.onOptionSelected(
                                                      modifier.name, opt.key);
                                                  Navigator.pop(context);
                                                },
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                child: Container(
                                                  margin: const EdgeInsets.only(
                                                      bottom: 8),
                                                  padding:
                                                      const EdgeInsets.all(12),
                                                  decoration: BoxDecoration(
                                                    color: isSelected
                                                        ? Theme.of(context)
                                                            .colorScheme
                                                            .primary
                                                            .withValues(
                                                                alpha: 0.08)
                                                        : Colors.transparent,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            6),
                                                  ),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Container(
                                                            width: 20,
                                                            height: 20,
                                                            decoration:
                                                                BoxDecoration(
                                                              shape: BoxShape
                                                                  .circle,
                                                              border:
                                                                  Border.all(
                                                                color: isSelected
                                                                    ? Theme.of(
                                                                            context)
                                                                        .colorScheme
                                                                        .primary
                                                                    : Theme.of(
                                                                            context)
                                                                        .dividerColor,
                                                                width: 1.5,
                                                              ),
                                                            ),
                                                            child: isSelected
                                                                ? Center(
                                                                    child:
                                                                        Container(
                                                                      width: 12,
                                                                      height:
                                                                          12,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        shape: BoxShape
                                                                            .circle,
                                                                        color: Theme.of(context)
                                                                            .colorScheme
                                                                            .primary,
                                                                      ),
                                                                    ),
                                                                  )
                                                                : null,
                                                          ),
                                                          const SizedBox(
                                                              width: 12),
                                                          Row(
                                                            children: [
                                                              Text(
                                                                opt.key,
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width /
                                                                      110,
                                                                  fontWeight: isSelected
                                                                      ? FontWeight
                                                                          .w500
                                                                      : FontWeight
                                                                          .normal,
                                                                  color: Theme.of(
                                                                          context)
                                                                      .colorScheme
                                                                      .onSurface,
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                  width: 8),
                                                              _buildRatingIcon(
                                                                modifierName:
                                                                    modifier
                                                                        .name,
                                                                modifierValue:
                                                                    opt.key,
                                                                context:
                                                                    context,
                                                              ),
                                                              if (opt.key ==
                                                                  modifier
                                                                      .defaultVal) ...[
                                                                const SizedBox(
                                                                    width: 4),
                                                                Text(
                                                                  '(default)',
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize: MediaQuery.of(context)
                                                                            .size
                                                                            .width /
                                                                        120,
                                                                    color: Theme.of(
                                                                            context)
                                                                        .hintColor,
                                                                    fontStyle:
                                                                        FontStyle
                                                                            .italic,
                                                                  ),
                                                                ),
                                                              ],
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                      if (optionDesc.isNotEmpty)
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  left: 32,
                                                                  top: 6),
                                                          child: markdown(
                                                              optionDesc,
                                                              context),
                                                        ),
                                                    ],
                                                  ),
                                                )));
                                      }),
                                      if (modifier.desc != null) ...[
                                        const SizedBox(height: 16),
                                        Padding(
                                            padding:
                                                const EdgeInsets.only(left: 2),
                                            child: markdown(
                                                modifier.desc!, context)),
                                      ],
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )),
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
                                      child: Row(
                                        children: [
                                          Text(
                                            entry.key,
                                            style: TextStyle(
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  100,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          _buildRatingIcon(
                                            cueName: entry.key,
                                            cueEnabled:
                                                _localCueOptions[entry.key] ??
                                                    entry.value.$1,
                                            context: context,
                                          ),
                                        ],
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
                                  markdown(
                                    entry.value.$2,
                                    context,
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
