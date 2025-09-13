import 'package:bodybuild/ui/core/markdown.dart';
import 'package:bodybuild/ui/programmer/widget/exercise_ratings_dialog.dart';
import 'package:bodybuild/ui/programmer/widget/exercise_recruitment_visualization.dart';
import 'package:bodybuild/util.dart';
import 'package:flutter/material.dart';
import 'package:bodybuild/model/programmer/set_group.dart';
import 'package:bodybuild/ui/programmer/widget/rating_icon.dart';
import 'package:bodybuild/data/programmer/exercises.dart';
import 'package:bodybuild/model/programmer/settings.dart';

class ExerciseDetailsDialog extends StatefulWidget {
  final Sets sets;
  final Settings setup;
  final Function(Sets)? onChangeEx; // allow editng exercise name?
  final Function(Sets)? onChangeModifiersCues; // allow editng modifiers/cues?
  final Function()? onClose; // if set, puts a close button
  final bool showRecruitmentViz;

  const ExerciseDetailsDialog({
    super.key,
    required this.sets,
    required this.setup,
    this.onChangeEx,
    this.onChangeModifiersCues,
    this.onClose,
    this.showRecruitmentViz = true,
  });

  @override
  State<ExerciseDetailsDialog> createState() => _ExerciseDetailsDialogState();
}

class _ExerciseDetailsDialogState extends State<ExerciseDetailsDialog> {
  late Sets localSets;

  @override
  void initState() {
    super.initState();
    localSets = widget.sets;
  }

  Widget _buildRatingIcon({
    String? modifierName,
    String? modifierValue,
    String? cueName,
    bool? cueEnabled,
    required BuildContext context,
  }) {
    if (localSets.ex == null) return const SizedBox.shrink();

    // Get ratings for current configuration
    final currentRatings = localSets
        .getApplicableRatingsForConfig(
          localSets.modifierOptions,
          localSets.cueOptions,
        )
        .toList();

    // Create a copy of current configuration
    final modifierConfig = Map<String, String>.from(localSets.modifierOptions);
    final cueConfig = Map<String, bool>.from(localSets.cueOptions);

    // Apply the specific option we're showing the rating for
    if (modifierName != null && modifierValue != null) {
      modifierConfig[modifierName] = modifierValue;
    }
    if (cueName != null && cueEnabled != null) {
      cueConfig[cueName] = cueEnabled;
    }

    // Get ratings for this configuration
    final ratings = localSets
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
      onTap: ratings.isEmpty
          ? null
          : () => {showRatingsDialog(widget.sets.ex!.id, ratings, context)},
    );
  }

  void onChangeEx(Sets newSets) {
    if (widget.onChangeEx == null) return;
    // update parent widget(s) which are in the background of our dialog
    widget.onChangeEx!(newSets);
    // update our local state (which isn't automatically updated after our parent has launched the dialog)
    setState(() {
      localSets = newSets;
    });
  }

  void onChangeModifiersCues(Sets newSets) {
    if (widget.onChangeModifiersCues == null) return;
    // update parent widget(s) which are in the background of our dialog
    widget.onChangeModifiersCues!(newSets);
    // update our local state (which isn't automatically updated after our parent has launched the dialog)
    setState(() {
      localSets = newSets;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Exercise Details',
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
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
                    content: markdown('''# Exercise settings
This dialog lets you customize your exercise and how it's performed.

You can:
* Change the exercise
* Modify how the exercise is performed (affects muscle recruitment)
* Add cues to help with form and technique

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
            if (widget.onClose != null) ...[
              Expanded(child: Container()),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  widget.onClose!();
                },
              ),
            ],
          ],
        ),
        const SizedBox(height: 16),
        Text(
          'Exercise',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Theme.of(context).colorScheme.secondary,
              ),
        ),
        const SizedBox(height: 12),
        if (localSets.ex != null && !localSets.changeEx) ...[
          Row(
            children: [
              Text(
                localSets.ex!.id,
                /*   style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width / 90,
                  fontWeight: FontWeight.bold,
                ),
                */
              ),
              const Spacer(),
              if (widget.onChangeEx != null)
                TextButton(
                  onPressed: () {
                    onChangeEx(localSets.copyWith(changeEx: true));
                  },
                  child: const Text('Change'),
                ),
            ],
          ),
        ] else ...[
          Autocomplete<Ex>(
            displayStringForOption: (e) => e.id,
            optionsBuilder: (textEditingValue) {
              final filtered = widget.setup.availableExercises
                  .where((e) => e.id
                      .toLowerCase()
                      .contains(textEditingValue.text.toLowerCase()))
                  .toList();
              filtered.sort((a, b) => a.id.compareTo(b.id));
              return filtered;
            },
            onSelected: (Ex selection) {
              onChangeEx(localSets.copyWith(
                ex: selection,
                changeEx: false,
                modifierOptions: {},
                cueOptions: {},
              ));
            },
            fieldViewBuilder: (context, controller, focusNode, onSubmitted) {
              return TextField(
                controller: controller,
                focusNode: focusNode,
                onEditingComplete: onSubmitted,
                decoration: InputDecoration(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  hintText: 'Search exercise...',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Theme.of(context)
                      .colorScheme
                      .primary
                      .withValues(alpha: 0.05),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
              );
            },
          ),
        ],
        const SizedBox(height: 24),
        if (widget.showRecruitmentViz) ...[
          ExerciseRecruitmentVisualization(
            exercise: localSets.ex!,
            modifierOptions: localSets.modifierOptions,
            setup: widget.setup,
          ),
          const SizedBox(height: 24),
        ],
        if (localSets.ex?.modifiers.isEmpty == false) ...[
          ...localSets.ex!.modifiers.map((modifier) => Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Modifier: ${modifier.name.capitalizeFirstOnly()}",
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          ...(modifier.opts.entries.toList()
                                ..sort((a, b) => a.key.compareTo(b.key)))
                              .map((opt) {
                            final isSelected = opt.key ==
                                (localSets.modifierOptions[modifier.name] ??
                                    modifier.defaultVal);
                            final optionDesc = opt.value.$2;
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                RadioListTile<String>(
                                  title: Row(
                                    children: [
                                      Text(opt.key),
                                      const SizedBox(width: 8),
                                      _buildRatingIcon(
                                        modifierName: modifier.name,
                                        modifierValue: opt.key,
                                        context: context,
                                      ),
                                      if (opt.key == modifier.defaultVal) ...[
                                        const SizedBox(width: 4),
                                        Text(
                                          '(default)',
                                          style: TextStyle(
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                120,
                                            color: Theme.of(context).hintColor,
                                            fontStyle: FontStyle.italic,
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                  value: opt.key,
                                  groupValue: localSets
                                          .modifierOptions[modifier.name] ??
                                      modifier.defaultVal,
                                  onChanged: widget.onChangeModifiersCues !=
                                          null
                                      ? (value) {
                                          if (value != null) {
                                            onChangeModifiersCues(
                                                localSets.copyWith(
                                              modifierOptions: {
                                                ...localSets.modifierOptions,
                                                modifier.name: value
                                              },
                                            ));
                                          }
                                        }
                                      : null,
                                  contentPadding: EdgeInsets.zero,
                                ),
                                if (optionDesc.isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 56, bottom: 8),
                                    child: markdown(optionDesc, context),
                                  ),
                              ],
                            );
                          }),
                          if (modifier.desc != null) ...[
                            const SizedBox(height: 16),
                            Padding(
                              padding: const EdgeInsets.only(left: 2),
                              child: markdown(modifier.desc!, context),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              )),
        ],
        if (localSets.ex?.cues.isEmpty == false) ...[
          if (localSets.ex!.modifiers.isNotEmpty) const SizedBox(height: 24),
          Text(
            'Cues',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Theme.of(context).colorScheme.secondary,
                ),
          ),
          const SizedBox(height: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ...localSets.ex!.cues.entries.map((entry) {
                final isEnabled =
                    localSets.cueOptions[entry.key] ?? entry.value.$1;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Text(
                                entry.key,
                              ),
                              const SizedBox(width: 8),
                              _buildRatingIcon(
                                cueName: entry.key,
                                cueEnabled: isEnabled,
                                context: context,
                              ),
                            ],
                          ),
                        ),
                        Switch(
                          value: isEnabled,
                          onChanged: widget.onChangeModifiersCues != null
                              ? (value) {
                                  onChangeModifiersCues(localSets.copyWith(
                                    cueOptions: {
                                      ...localSets.cueOptions,
                                      entry.key: value,
                                    },
                                  ));
                                }
                              : null,
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
                );
              }),
            ],
          ),
        ],
      ],
    );
  }
}
