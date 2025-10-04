import 'package:bodybuild/ui/core/markdown.dart';
import 'package:bodybuild/ui/programmer/widget/exercise_ratings_dialog.dart';
import 'package:bodybuild/ui/programmer/widget/exercise_recruitment_visualization.dart';
import 'package:bodybuild/util/string_extension.dart';
import 'package:flutter/material.dart';
import 'package:bodybuild/model/programmer/set_group.dart';
import 'package:bodybuild/ui/programmer/widget/rating_icon_multi.dart';
import 'package:bodybuild/data/programmer/exercises.dart';
import 'package:bodybuild/model/programmer/settings.dart';

class ExerciseDetailsDialog extends StatefulWidget {
  final Sets sets;
  final Settings setup;
  final Function(Sets)? onChangeEx; // allow editng exercise name?
  final Function(Sets)? onChangeTweaks; // allow editng tweaks?
  final Function()? onClose; // if set, puts a close button
  final bool showRecruitmentViz;

  const ExerciseDetailsDialog({
    super.key,
    required this.sets,
    required this.setup,
    this.onChangeEx,
    this.onChangeTweaks,
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

  @override
  void didUpdateWidget(ExerciseDetailsDialog oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.sets != widget.sets) {
      localSets = widget.sets;
    }
  }

  Widget _buildRatingIcon({String? tweakName, String? tweakValue, required BuildContext context}) {
    if (localSets.ex == null) return const SizedBox.shrink();

    // Get ratings for current configuration
    final currentRatings = localSets.getApplicableRatingsForConfig(localSets.tweakOptions).toList();

    // Create a copy of current configuration
    final tweakConfig = Map<String, String>.of(localSets.tweakOptions);

    // Apply the specific option we're showing the rating for
    if (tweakName != null && tweakValue != null) {
      tweakConfig[tweakName] = tweakValue;
    }

    // Get ratings for this configuration
    final ratings = localSets.getApplicableRatingsForConfig(tweakConfig).toList();

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

    return RatingIconMulti(
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

  void onChangeTweaks(Sets newSets) {
    if (widget.onChangeTweaks == null) return;
    // update parent widget(s) which are in the background of our dialog
    widget.onChangeTweaks!(newSets);
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
              style: Theme.of(
                context,
              ).textTheme.headlineLarge?.copyWith(color: Theme.of(context).colorScheme.primary),
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
* Apply tweaks to the exercise.  They modify how the exercise is performed 

Tweaks may affect:
* muscle recruitment level (reflected in volume counts)
* muscle activation & growth stimulus
* equipment used
* technique
* development of secondary goals such as mobility, grip, core stability, etc

By applying tweaks you are effectively creating a modified exercise, which is presented
as such in the gym tracking app, as well as the upcoming analysis feature, which will
help you understand if any particular tweaks helped with your gains.

In the future, you'll be able to add your own custom tweaks as well.
''', context),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK')),
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
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(color: Theme.of(context).colorScheme.secondary),
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
        ] else
          Autocomplete<Ex>(
            displayStringForOption: (e) => e.id,
            optionsBuilder: (textEditingValue) =>
                widget.setup.getAvailableExercises(query: textEditingValue.text).toList(),
            onSelected: (Ex selection) {
              onChangeEx(localSets.copyWith(ex: selection, changeEx: false, tweakOptions: {}));
            },
            fieldViewBuilder: (context, controller, focusNode, onSubmitted) {
              return TextField(
                controller: controller,
                focusNode: focusNode,
                onEditingComplete: onSubmitted,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  hintText: 'Search exercise...',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.05),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
              );
            },
          ),
        const SizedBox(height: 24),
        if (widget.showRecruitmentViz && localSets.ex != null) ...[
          ExerciseRecruitmentVisualization(
            exercise: localSets.ex!,
            tweakOptions: localSets.tweakOptions,
            setup: widget.setup,
          ),
          const SizedBox(height: 24),
        ],
        if (localSets.ex?.tweaks.isEmpty == false)
          // ignore: prefer-null-aware-spread
          ...localSets.ex!.tweaks.map(
            (tweak) => Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Tweak: ${tweak.name.capitalizeFirstOnlyButKeepAcronym()}",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ...(tweak.opts.entries.toList()..sort((a, b) => a.key.compareTo(b.key)))
                            .map((opt) {
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
                                          tweakName: tweak.name,
                                          tweakValue: opt.key,
                                          context: context,
                                        ),
                                        if (opt.key == tweak.defaultVal) ...[
                                          const SizedBox(width: 4),
                                          Text(
                                            '(default)',
                                            style: TextStyle(
                                              fontSize: MediaQuery.of(context).size.width / 120,
                                              color: Theme.of(context).hintColor,
                                              fontStyle: FontStyle.italic,
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                    value: opt.key,
                                    groupValue:
                                        localSets.tweakOptions[tweak.name] ?? tweak.defaultVal,
                                    onChanged: widget.onChangeTweaks != null
                                        ? (value) {
                                            if (value != null) {
                                              onChangeTweaks(
                                                localSets.copyWith(
                                                  tweakOptions: {
                                                    ...localSets.tweakOptions,
                                                    tweak.name: value,
                                                  },
                                                ),
                                              );
                                            }
                                          }
                                        : null,
                                    contentPadding: EdgeInsets.zero,
                                  ),
                                  if (optionDesc.isNotEmpty)
                                    Padding(
                                      padding: const EdgeInsets.only(left: 56, bottom: 8),
                                      child: markdown(optionDesc, context),
                                    ),
                                ],
                              );
                            }),
                        if (tweak.desc != null) ...[
                          const SizedBox(height: 16),
                          Padding(
                            padding: const EdgeInsets.only(left: 2),
                            child: markdown(tweak.desc!, context),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
