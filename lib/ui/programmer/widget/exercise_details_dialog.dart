import 'package:bodybuild/ui/core/markdown.dart';
import 'package:bodybuild/ui/programmer/widget/exercise_recruitment_visualization.dart';
import 'package:bodybuild/ui/core/widget/configure_tweak_large.dart';
import 'package:bodybuild/ui/core/widget/configure_tweak_small.dart';
import 'package:bodybuild/util/string_extension.dart';
import 'package:flutter/material.dart';
import 'package:bodybuild/model/programmer/set_group.dart';
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
  bool showDetailedTweaks = false;

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
        const SizedBox(height: 16),
        Row(
          children: [
            Text(
              'Tweaks',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(color: Theme.of(context).colorScheme.secondary),
            ),
            if (localSets.ex?.tweaks.isNotEmpty ?? false) ...[
              Expanded(child: Container()),
              FilledButton.tonalIcon(
                onPressed: () => setState(() => showDetailedTweaks = !showDetailedTweaks),
                icon: Icon(showDetailedTweaks ? Icons.unfold_less : Icons.unfold_more),
                label: Text(showDetailedTweaks ? 'Less' : 'More'),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  visualDensity: VisualDensity.compact,
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 12),
        LayoutBuilder(
          builder: (context, constraints) {
            if (localSets.ex == null || localSets.ex!.tweaks.isEmpty) {
              return const SizedBox.shrink();
            }
            // Calculate optimal item width based on available space
            final availableWidth = constraints.maxWidth;
            const minItemWidth = 300.0;
            const maxItemWidth = 600.0;
            const spacing = 16.0;

            // Determine how many items can fit per row
            int itemsPerRow = (availableWidth / (minItemWidth + spacing)).floor();
            itemsPerRow = itemsPerRow.clamp(1, localSets.ex!.tweaks.length);

            // Calculate actual item width to fill available space
            final totalSpacing = (itemsPerRow - 1) * spacing;
            final calculatedWidth = (availableWidth - totalSpacing) / itemsPerRow;

            // Clamp to min/max bounds
            final itemWidth = calculatedWidth.clamp(minItemWidth, maxItemWidth);

            return Wrap(
              spacing: spacing,
              runSpacing: spacing,
              children:
                  localSets.ex?.tweaks
                      .map(
                        (tweak) => SizedBox(
                          width: itemWidth,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                tweak.name.capitalizeFirstOnlyButKeepAcronym(),
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  color: Theme.of(context).colorScheme.secondary,
                                ),
                              ),
                              const SizedBox(height: 12),
                              if (showDetailedTweaks)
                                ConfigureTweakLarge(
                                  tweak,
                                  localSets,
                                  onChange: widget.onChangeTweaks != null
                                      ? (value) {
                                          widget.onChangeTweaks!(
                                            localSets.copyWith(
                                              tweakOptions: {
                                                ...localSets.tweakOptions,
                                                tweak.name: value,
                                              },
                                            ),
                                          );
                                        }
                                      : null,
                                )
                              else
                                ConfigureTweakSmall(
                                  tweak,
                                  localSets,
                                  onChange: widget.onChangeTweaks != null
                                      ? (value) {
                                          widget.onChangeTweaks!(
                                            localSets.copyWith(
                                              tweakOptions: {
                                                ...localSets.tweakOptions,
                                                tweak.name: value,
                                              },
                                            ),
                                          );
                                        }
                                      : null,
                                ),
                            ],
                          ),
                        ),
                      )
                      .toList() ??
                  [],
            );
          },
        ),
        if (widget.showRecruitmentViz && localSets.ex != null) ...[
          const SizedBox(height: 16),
          Text(
            'Muscle Recruitment',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(color: Theme.of(context).colorScheme.secondary),
          ),
          const SizedBox(height: 12),
          ExerciseRecruitmentVisualization(
            exercise: localSets.ex!,
            tweakOptions: localSets.tweakOptions,
            setup: widget.setup,
          ),
        ],
      ],
    );
  }
}
