import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bodybuild/data/programmer/exercises.dart';
import 'package:bodybuild/data/programmer/groups.dart';
import 'package:bodybuild/data/programmer/rating.dart';
import 'package:bodybuild/model/programmer/set_group.dart';
import 'package:bodybuild/model/programmer/settings.dart';
import 'package:bodybuild/ui/programmer/util_groups.dart';
import 'package:bodybuild/ui/programmer/widget/equip_label.dart';
import 'package:bodybuild/ui/programmer/widget/widgets.dart';
import 'package:bodybuild/ui/programmer/widget/ex_modifiers_cues_widget.dart';
import 'package:bodybuild/ui/programmer/widget/exercise_ratings_dialog.dart';
import 'package:bodybuild/ui/programmer/widget/rating_icon.dart';

class BuilderSets extends ConsumerWidget {
  void _showRatingsDialog(List<Rating> ratings, BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => ExerciseRatingsDialog(
        exerciseId: sets.ex!.id,
        ratings: ratings,
      ),
    );
  }

  final Sets sets;
  final Settings setup;
  final bool hasNewComboButton;

  final Function(Sets? sgNew) onChange;

  const BuilderSets(
      this.setup, this.sets, this.hasNewComboButton, this.onChange,
      {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final setRatings = sets.getApplicableRatings().toList();
    // this layout matches BuilderWorkoutSetsHeader
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16), // affects align
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(children: [
        Flexible(
          flex: 45,
          child: Row(
            children: [
              Flexible(flex: 15, child: _numSetsButton(context)),
              Flexible(flex: 15, child: _intensityButton(context)),
              Flexible(flex: 10, child: _editButton(context)),
              Flexible(
                  flex: 15,
                  child: (sets.ex == null)
                      ? Container()
                      : ExModifiersCuesWidget(
                          sets: sets,
                          modifiers: sets.ex!.modifiers,
                          selectedOptions: sets.modifierOptions,
                          onOptionSelected: (name, opt) =>
                              onChange(sets.copyWith(
                            modifierOptions: {
                              ...sets.modifierOptions,
                              name: opt
                            },
                          )),
                          cues: sets.ex!.cues,
                          cueOptions: sets.cueOptions,
                          onShowRatings: (ratings) =>
                              _showRatingsDialog(ratings, context),
                          onCueToggled: (name, enabled) =>
                              onChange(sets.copyWith(
                            cueOptions: {...sets.cueOptions, name: enabled},
                          )),
                        )),
              Flexible(flex: 10, child: _deleteButton(context)),
              Flexible(flex: 70, child: _exerciseName(setRatings, context)),
              // we squeeze the combo set button in with the equipment
              // not the most semantically correct, but it works for now
              Flexible(flex: 35, child: _equipment(context)),
            ],
          ),
        ),
        Flexible(flex: 55, child: _recruitmentMarkers(context)),
      ]),
    );
  }

  Widget _numSetsButton(BuildContext context) => DropdownButtonHideUnderline(
        child: Align(
          alignment: Alignment.centerLeft,
          child: DropdownButton<int>(
            value: sets.n,
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
              onChange(sets.copyWith(n: newValue));
            },
          ),
        ),
      );

  Widget _intensityButton(BuildContext context) => DropdownButtonHideUnderline(
        child: Align(
          alignment: Alignment.centerLeft,
          child: DropdownButton<int>(
            // if you go back and change the setup, we must reset the intensity to something that's allowed
            value: (setup.paramFinal.intensities.contains(sets.intensity))
                ? sets.intensity
                : setup.paramFinal.intensities.first,
            icon: Icon(Icons.arrow_drop_down,
                color: Theme.of(context).colorScheme.primary,
                size: MediaQuery.sizeOf(context).width / 60),
            items: setup.paramFinal.intensities
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
              onChange(sets.copyWith(intensity: newValue));
            },
          ),
        ),
      );

  Widget _editButton(BuildContext context) => IconButton(
        onPressed: () {
          onChange(sets.copyWith(changeEx: !sets.changeEx));
        },
        icon: Icon(
          Icons.edit,
          size: MediaQuery.sizeOf(context).width / 60,
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.8),
        ),
        style: IconButton.styleFrom(
          backgroundColor: sets.changeEx
              ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.1)
              : Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );

  Widget _deleteButton(BuildContext context) => IconButton(
        onPressed: () {
          onChange(null);
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
        child: (sets.ex != null && !sets.changeEx)
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    Text(
                      sets.ex!.id,
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
            : Autocomplete<Ex>(
                displayStringForOption: (e) => e.id,
                optionsBuilder: (textEditingValue) {
                  final filtered = setup.availableExercises
                      .where((e) => e.id
                          .toLowerCase()
                          .contains(textEditingValue.text.toLowerCase()))
                      .toList();
                  filtered.sort((a, b) => a.id.compareTo(b.id));
                  return filtered;
                },
                fieldViewBuilder:
                    (context, controller, focusNode, onSubmitted) {
                  return TextField(
                    controller: controller,
                    focusNode: focusNode,
                    onEditingComplete: onSubmitted,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
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
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: Theme.of(context)
                              .colorScheme
                              .primary
                              .withValues(alpha: 0.2),
                          width: 2,
                        ),
                      ),
                    ),
                  );
                },
                optionsViewBuilder: (context, onSelected, options) {
                  return Align(
                    alignment: Alignment.topLeft,
                    child: Material(
                      elevation: 4,
                      borderRadius: BorderRadius.circular(8),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxHeight: 200,
                          maxWidth: 400,
                        ),
                        child: ListView.builder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          itemCount: options.length,
                          itemBuilder: (context, index) {
                            final option = options.elementAt(index);

                            return ListTile(
                              dense: true,
                              title: Text(option.id),
                              onTap: () {
                                onSelected(option);
                                onChange(
                                    sets.copyWith(ex: option, changeEx: false));
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  );
                },
                onSelected: (Ex e) {
                  onChange(sets.copyWith(ex: e, changeEx: false));
                }),
      );

  Widget _equipment(BuildContext context) => Row(
        children: [
          if (sets.ex != null) ...[
            ...sets.ex!.equipment.map((e) => Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child:
                      EquipmentLabel(e, err: !setup.availEquipment.contains(e)),
                )),
          ],
          if (hasNewComboButton)
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
                              sets.ex == null
                                  ? 0
                                  : sets.ex!
                                      .recruitment(g, sets.modifierOptions)
                                      .volume,
                              context)),
                    ),
                  ),
                )
                .toList(),
      );
}
