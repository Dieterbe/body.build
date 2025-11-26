import 'package:flutter/material.dart';
import 'package:bodybuild/model/programmer/set_group.dart';
import 'package:bodybuild/model/programmer/settings.dart';
import 'package:bodybuild/model/programmer/workout.dart';
import 'package:bodybuild/ui/programmer/state/drag_state.dart';
import 'package:bodybuild/ui/programmer/widget/builder_sets.dart';

class DraggableSets extends StatelessWidget {
  final Workout workout;
  final SetGroup sg;
  final Sets sets;
  final Settings setup;
  final bool hasNewComboButton;
  final Function(Workout) onChange;
  final bool isExpanded;
  final Function(bool)? onExpandedChanged;

  const DraggableSets(
    this.setup,
    this.workout,
    this.sg,
    this.sets,
    this.hasNewComboButton,
    this.onChange, {
    this.isExpanded = false,
    this.onExpandedChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final builderSets = BuilderSets(
      setup,
      sets,
      hasNewComboButton,
      (sNew) {
        if (sNew == null && sg.sets.length == 1) {
          // special case: if sNew needs to be removed, and it's the only one in the setgroup,
          // then the whole setGroup should be deleted
          onChange(workout.copyWith(setGroups: workout.setGroups.where((e) => (e != sg)).toList()));
          return;
        }
        final SetGroup sg2;
        if (sNew == null) {
          // remove this element from the setGroup:
          sg2 = SetGroup(sg.sets.where((s) => (s != sets)).toList());
        } else {
          sg2 = SetGroup(sg.sets.map((s) => (s == sets) ? sNew : s).toList());
        }
        onChange(
          workout.copyWith(setGroups: workout.setGroups.map((e) => (e == sg) ? sg2 : e).toList()),
        );
      },
      onExpandedChanged: onExpandedChanged,
      isExpanded: isExpanded,
    );

    // Don't allow dragging when the dialog is expanded
    if (isExpanded) {
      return builderSets;
    }

    return Draggable<MapEntry<Workout, Sets>>(
      data: MapEntry(workout, sets),
      onDragStarted: () {
        dragInProgressNotifier.value = true;
      },
      onDragEnd: (_) {
        dragInProgressNotifier.value = false;
      },
      onDraggableCanceled: (_, __) {
        dragInProgressNotifier.value = false;
      },
      feedback: Material(
        elevation: 4,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          color: Theme.of(context).colorScheme.surface,
          child: builderSets,
        ),
      ),
      childWhenDragging: Container(
        height: 60,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      onDragCompleted: () {
        dragInProgressNotifier.value = false;
        // We don't do any updates to the workout state here. that is left to the drop target
      },
      child: builderSets,
    );
  }
}
