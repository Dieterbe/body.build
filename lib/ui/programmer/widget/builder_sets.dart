import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bodybuild/data/programmer/groups.dart';
import 'package:bodybuild/data/programmer/rating.dart';
import 'package:bodybuild/model/programmer/set_group.dart';
import 'package:bodybuild/model/programmer/settings.dart';
import 'package:bodybuild/ui/programmer/util_groups.dart';
import 'package:bodybuild/ui/programmer/widget/equip_label.dart';
import 'package:bodybuild/ui/programmer/widget/widgets.dart';
import 'package:bodybuild/ui/programmer/widget/exercise_edit_dialog.dart';
import 'package:bodybuild/ui/programmer/widget/exercise_ratings_dialog.dart';
import 'package:bodybuild/ui/programmer/widget/rating_icon.dart';
import 'package:bodybuild/ui/programmer/widget/pulse_widget.dart';

class BuilderSets extends ConsumerStatefulWidget {
  final Sets sets;
  final Settings setup;
  final bool hasNewComboButton;
  final Function(Sets? sgNew) onChange;

  const BuilderSets(
      this.setup, this.sets, this.hasNewComboButton, this.onChange,
      {super.key});

  @override
  ConsumerState<BuilderSets> createState() => _BuilderSetsState();
}

class _BuilderSetsState extends ConsumerState<BuilderSets> {
  bool isExpanded = false;

  void _showRatingsDialog(List<Rating> ratings, BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => ExerciseRatingsDialog(
        exerciseId: widget.sets.ex!.id,
        ratings: ratings,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final setRatings = widget.sets.getApplicableRatings().toList();
    return Column(
      children: [
        // this layout matches BuilderWorkoutSetsHeader
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
              bottomLeft: isExpanded ? Radius.zero : Radius.circular(8),
              bottomRight: isExpanded ? Radius.zero : Radius.circular(8),
            ),
          ),
          child: Row(children: [
            Flexible(
              flex: 45,
              child: Row(
                children: [
                  Flexible(flex: 15, child: _numSetsButton(context)),
                  Flexible(flex: 15, child: _intensityButton(context)),
                  Flexible(flex: 15, child: _exerciseEditButton(context)),
                  Flexible(flex: 10, child: _deleteButton(context)),
                  Flexible(flex: 70, child: _exerciseName(setRatings, context)),
                  Flexible(flex: 35, child: _equipment(context)),
                ],
              ),
            ),
            Flexible(flex: 55, child: _recruitmentMarkers(context)),
          ]),
        ),
        if (isExpanded) ...[
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(8),
                bottomRight: Radius.circular(8),
              ),
            ),
            child: ExerciseEditDialog(
              sets: widget.sets,
              setup: widget.setup,
              onChange: widget.onChange,
              onShowRatings: (ratings) => _showRatingsDialog(ratings, context),
            ),
          ),
        ],
      ],
    );
  }

  Widget _numSetsButton(BuildContext context) => DropdownButtonHideUnderline(
        child: Align(
          alignment: Alignment.centerLeft,
          child: DropdownButton<int>(
            value: widget.sets.n,
            icon: Icon(
              Icons.arrow_drop_down,
              color: Theme.of(context).colorScheme.primary,
              size: MediaQuery.sizeOf(context).width / 60,
            ),
            items: List.generate(10, (index) => index + 1)
                .map<DropdownMenuItem<int>>((int value) {
              return DropdownMenuItem<int>(
                value: value,
                child: Text(
                  value.toString(),
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.onSurface,
                    fontSize: MediaQuery.sizeOf(context).width / 80,
                  ),
                ),
              );
            }).toList(),
            onChanged: (int? newValue) {
              if (newValue == null) return;
              widget.onChange(widget.sets.copyWith(n: newValue));
            },
          ),
        ),
      );

  Widget _intensityButton(BuildContext context) => DropdownButtonHideUnderline(
        child: Align(
          alignment: Alignment.centerLeft,
          child: DropdownButton<int>(
            // if you go back and change the setup, we must reset the intensity to something that's allowed
            value: (widget.setup.paramFinal.intensities
                    .contains(widget.sets.intensity))
                ? widget.sets.intensity
                : widget.setup.paramFinal.intensities.first,
            icon: Icon(Icons.arrow_drop_down,
                color: Theme.of(context).colorScheme.primary,
                size: MediaQuery.sizeOf(context).width / 60),
            items: widget.setup.paramFinal.intensities
                .map<DropdownMenuItem<int>>((int value) {
              return DropdownMenuItem<int>(
                value: value,
                child: Text(
                  value.toString(),
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.onSurface,
                    fontSize: MediaQuery.sizeOf(context).width / 80,
                  ),
                ),
              );
            }).toList(),
            onChanged: (int? newValue) {
              if (newValue == null) return;
              widget.onChange(widget.sets.copyWith(intensity: newValue));
            },
          ),
        ),
      );

  Widget _exerciseEditButton(BuildContext context) {
    return IconButton(
      onPressed: () {
        setState(() {
          isExpanded = !isExpanded;
        });
      },
      icon: widget.sets.ex == null
          ? PulseWidget(
              pulse: !isExpanded,
              child: Icon(
                isExpanded ? Icons.expand_less : Icons.settings,
              ),
            )
          : Icon(
              isExpanded ? Icons.expand_less : Icons.settings,
            ),
      style: IconButton.styleFrom(
        backgroundColor:
            Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Widget _deleteButton(BuildContext context) => IconButton(
        onPressed: () {
          widget.onChange(null);
        },
        icon: Icon(
          Icons.delete_outline,
          size: MediaQuery.sizeOf(context).width / 60,
          color: Theme.of(context).colorScheme.error.withValues(alpha: 0.8),
        ),
        style: IconButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );

  Widget _exerciseName(List<Rating> setRatings, BuildContext context) => Align(
        alignment: Alignment.centerLeft,
        child: (widget.sets.ex != null)
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    Text(
                      widget.sets.ex!.id,
                      style: TextStyle(
                        fontSize: MediaQuery.sizeOf(context).width / 110,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.3,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    if (setRatings.isNotEmpty) ...[
                      const SizedBox(width: 8),
                      IconButton(
                        onPressed: () =>
                            _showRatingsDialog(setRatings, context),
                        icon: RatingIcon(
                          ratings: setRatings,
                          size: MediaQuery.sizeOf(context).width /
                              60, // made up number, should probably find something more elegant
                        ),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        splashRadius: 20,
                      ),
                    ],
                  ],
                ))
            : Container(),
      );

  Widget _equipment(BuildContext context) => Row(
        children: [
          if (widget.sets.ex != null) ...[
            ...widget.sets.ex!.equipment.map((e) => Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: EquipmentLabel(e,
                      err: !widget.setup.availEquipment.contains(e)),
                )),
          ],
          if (widget.hasNewComboButton)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.blue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: Colors.blue.withValues(alpha: 0.3)),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.merge_type, size: 16, color: Colors.blue),
                    SizedBox(width: 4),
                    Text('New ComboSet', style: TextStyle(color: Colors.blue)),
                  ],
                ),
              ),
            ),
        ],
      );

  Widget _recruitmentMarkers(BuildContext context) => Row(
        children:
            // muscle recruitment values
            ProgramGroup.values
                .map(
                  (g) => Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: bgColorForProgramGroup(g),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(4),
                        ),
                      ),
                      child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: muscleMark(
                              widget.sets.ex == null
                                  ? 0
                                  : widget.sets.ex!
                                      .recruitment(
                                          g, widget.sets.modifierOptions)
                                      .volume,
                              context)),
                    ),
                  ),
                )
                .toList(),
      );
}
