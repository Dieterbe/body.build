import 'package:bodybuild/data/programmer/equipment.dart';
import 'package:bodybuild/ui/core/markdown.dart';
import 'package:bodybuild/ui/programmer/widget/exercise_recruitment_visualization.dart';
import 'package:bodybuild/ui/programmer/widget/exercises/configure_tweak_grid.dart';
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
  final bool scrollableTweakGrid; // if parent is already scrollable, avoid scroll inside of scroll
  final bool constrainWidth;
  final Set<Equipment>? availEquipment;

  const ExerciseDetailsDialog({
    super.key,
    required this.sets,
    required this.setup,
    this.onChangeEx,
    this.onChangeTweaks,
    this.onClose,
    this.showRecruitmentViz = true,
    this.scrollableTweakGrid = false,
    this.constrainWidth = false,
    this.availEquipment,
  });

  @override
  State<ExerciseDetailsDialog> createState() => _ExerciseDetailsDialogState();
}

class _ExerciseDetailsDialogState extends State<ExerciseDetailsDialog> {
  late Sets localSets;
  bool showDetailedTweaks = false;
  ScrollController? _tweakScrollController;

  @override
  void initState() {
    super.initState();
    localSets = widget.sets;
    // Only create scroll controller if we need scrollable tweak grid
    if (widget.scrollableTweakGrid) {
      _tweakScrollController = ScrollController();
    }
  }

  @override
  void dispose() {
    _tweakScrollController?.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(ExerciseDetailsDialog oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.sets != widget.sets) {
      localSets = widget.sets;
    }

    // Handle changes to scrollableTweakGrid
    if (oldWidget.scrollableTweakGrid != widget.scrollableTweakGrid) {
      if (widget.scrollableTweakGrid && _tweakScrollController == null) {
        _tweakScrollController = ScrollController();
      } else if (!widget.scrollableTweakGrid && _tweakScrollController != null) {
        _tweakScrollController!.dispose();
        _tweakScrollController = null;
      }
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
    return Container(
      // we have some Rows with widgets that want to right-align, therefore we use Expand() and a
      // max mainaxis size.
      // However, if we are put inside a dialog, have relatively few tweaks and a large screen,
      // than this results in a huge dialog that fills up the screen and has lots of empty space.
      // Therefore, we can constrain the width here.
      // If on the other hand we have many tweaks / a small screen than this will be
      // overridden by the "real" (smaller) constraint. So no harm done.
      // This can probably be done in a more idiomatic way (e.g. IntrinsicWidth) but I couldn't
      // figure it out.
      // (the workout programmer UI is full-width so there we actually don't want the constraint)
      constraints: widget.constrainWidth
          ? BoxConstraints(maxWidth: ConfigureTweakGrid.idealWidth(localSets))
          : null,
      child: Column(
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
                icon: Icon(Icons.info_outline, color: Theme.of(context).hintColor),
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
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(color: Theme.of(context).colorScheme.secondary),
          ),
          const SizedBox(height: 12),
          if (localSets.ex != null && !localSets.changeEx)
            Row(
              children: [
                Text(localSets.ex!.id),
                const Spacer(),
                if (widget.onChangeEx != null)
                  TextButton(
                    onPressed: () {
                      onChangeEx(localSets.copyWith(changeEx: true));
                    },
                    child: const Text('Change'),
                  ),
              ],
            )
          else
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
          if (localSets.ex?.desc.isNotEmpty ?? false) ...[
            const SizedBox(height: 16),
            markdown(localSets.ex!.desc, context),
          ],
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
          if (localSets.ex?.tweaks.isNotEmpty == true) ...[
            const SizedBox(height: 12),
            if (widget.scrollableTweakGrid && _tweakScrollController != null)
              Flexible(
                child: Scrollbar(
                  controller: _tweakScrollController!,
                  thumbVisibility: true,
                  child: SingleChildScrollView(
                    controller: _tweakScrollController!,
                    child: ConfigureTweakGrid(
                      sets: localSets,
                      onChange: onChangeTweaks,
                      showDetailedTweaks: showDetailedTweaks,
                      availableEquipment: widget.availEquipment,
                    ),
                  ),
                ),
              )
            else
              ConfigureTweakGrid(
                sets: localSets,
                onChange: onChangeTweaks,
                showDetailedTweaks: showDetailedTweaks,
                availableEquipment: widget.availEquipment,
              ),
          ],
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
      ),
    );
  }
}
