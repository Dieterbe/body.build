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
  const DraggableSets(this.setup, this.workout, this.sg, this.sets,
      this.hasNewComboButton, this.onChange,
      {super.key});

  @override
  Widget build(BuildContext context) {
    final builderSets = BuilderSets(setup, sets, hasNewComboButton, (sNew) {
      if (sNew == null && sg.sets.length == 1) {
        // special case: if sNew needs to be removed, and it's the only one in the setgroup,
        // then the whole setGroup should be deleted
        onChange(workout.copyWith(
            setGroups: workout.setGroups.where((e) => (e != sg)).toList()));
        return;
      }
      final SetGroup sg2;
      if (sNew == null) {
        // remove this element from the setGroup:
        sg2 = SetGroup(
          sg.sets.where((s) => (s != sets)).toList(),
        );
      } else {
        sg2 = SetGroup(
          sg.sets.map((s) => (s == sets) ? sNew : s).toList(),
        );
      }
      onChange(workout.copyWith(
          setGroups:
              workout.setGroups.map((e) => (e == sg) ? sg2 : e).toList()));
    });

    // Wrap in a ListenableBuilder to rebuild when the expansion state changes
    return ListenableBuilder(
      listenable: builderSets.isExpandedNotifier,
      builder: (context, _) {
        // Get the current expansion state
        final isExpanded = builderSets.isExpandedNotifier.value;
        
        return Draggable<MapEntry<Workout, Sets>>(
          // Disable dragging if the menu is expanded
          maxSimultaneousDrags: isExpanded ? 0 : null,
          data: MapEntry(workout, sets),
          onDragStarted: () {
            // Only set drag in progress if not expanded
            if (!isExpanded) {
              dragInProgressNotifier.value = true;
            }
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
      },
    );
  }
}
