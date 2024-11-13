import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ptc/programming/ex_set.dart';
import 'package:ptc/programming/exercises.dart';
import 'package:ptc/programming/groups.dart';
import 'package:ptc/ui/equip_label.dart';
import 'package:ptc/ui/ex_set.dart';
import 'package:ptc/ui/groups.dart';
import 'package:ptc/ui/programmer_exercise_selection/headers.dart';
import 'package:ptc/ui/programmer_exercise_selection/legend.dart';
import 'package:ptc/ui/programmer_exercise_selection/totals_widget.dart';
import 'package:ptc/ui/programmer_exercise_selection/widgets.dart';

class ProgrammerExerciseSelection extends StatefulWidget {
  const ProgrammerExerciseSelection({super.key});

  @override
  State<ProgrammerExerciseSelection> createState() =>
      _ProgrammerExerciseSelectionState();
}

class _ProgrammerExerciseSelectionState
    extends State<ProgrammerExerciseSelection> {
  List<ExSet> sets = [];

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(child: Container()),
          headers(),
        ],
      ),
      Row(
        children: [
          IconButton(
            onPressed: () {
              setState(() {
                sets.add(ExSet());
              });
            },
            icon: const Icon(Icons.add),
            // style: IconButton.styleFrom(
            //   minimumSize: const Size(40, 40),
            //   ),
          ),
          Text('Exercise sets'),
          Expanded(child: Container()),
          ...ProgramGroup.values.map((g) => Container(
              height: 30,
              // width: 30,
              color: bgColorForProgramGroup(g),
              child: GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return SimpleDialog(
                        title: Text('Add an exercise which recruits ${g}'),
                        children: [
                          Text(
                              'below are recommended exercises in order of recruitment'),
                          // ideally, user wants to preview the possible exercises within the program volume stats, so we could plonk them there
                          // in a special "WIP" section (e.g. hatched background)
                          // on the other hand, they also probably want to do a search to narrow it down to specific exercises, so they would
                          // need a text filter, and in the future maybe future filters
                          // putting all of that in the main UI seems a bit too much. let's just use a simple selection for now
                          Autocomplete<Ex>(
                            displayStringForOption: (e) => e.id,
                            optionsBuilder: (textEditingValue) {
                              final opts = exes
                                  .where((e) => (e.va.assign[g] ?? 0) > 0)
                                  .where((e) => e.id.toLowerCase().contains(
                                      textEditingValue.text.toLowerCase()))
                                  .toList();
                              opts.sort((a, b) => (b.va.assign[g] ?? 0)
                                  .compareTo(a.va.assign[g] ?? 0));
                              return opts;
                            },
                            onSelected: (e) {
                              context.pop();
                              setState(() {
                                sets.add(ExSet(ex: e));
                                print(e);
                              });
                            },
                          )
                        ],
                      );
                    },
                  );
                },
                child: Container(
                    width: 30, child: const Icon(Icons.add, size: 16)),
                //style: IconButton.styleFrom(
                //  maximumSize: const Size(30, 30),
                //),
              )))
        ],
      ),
      Divider(),
      ...sets.map((s) => Row(children: [
            IconButton(
              onPressed: () {
                setState(() {
                  s.ex = null;
                });
              },
              icon: const Icon(Icons.edit),
              style: IconButton.styleFrom(
                  //  minimumSize: const Size(40, 40), -- used to work
                  ),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  setState(() {
                    sets.remove(s);
                  });
                });
              },
              icon: const Icon(Icons.delete),
              style: IconButton.styleFrom(
                  //  minimumSize: const Size(40, 40), -- used to work
                  ),
            ),
            ExSetWidget(s, (ex) {
              setState(() {
                s.ex = ex;
              });
            }),
            Expanded(child: Container()),
            if (s.ex != null) ...s.ex!.equipment.map((e) => EquipmentLabel(e)),
            ...ProgramGroup.values.map((g) => Container(
                height: 40,
                //  width: 40,
                color: bgColorForProgramGroup(g),
                child: Center(
                    child: muscleMark(s.ex?.va.assign[g] ?? 0.0, context)))),
          ])),
      // if you want to show the actual volume assignment rules, uncomment this:
      /*
          ...volumeAssignments.map((e) => Row(children: [
                Text(e.match.map((e) => e.toString()).join(' OR ')),
                Expanded(child: Container()),
                ...ProgramGroup.values.map((g) => Container(
                    color: bgColorForProgramGroup(g),
                    child: muscleMark(e.assign[g] ?? 0.0, context))),
              ])),
              */
      const Divider(),
      const Legend(),
      const Divider(),
      TotalsWidget(sets),
    ]);
  }
}
