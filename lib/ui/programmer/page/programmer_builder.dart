import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ptc/data/programmer/program.dart';
import 'package:ptc/model/programmer/set_group.dart';
import 'package:ptc/data/programmer/exercises.dart';
import 'package:ptc/data/programmer/groups.dart';
import 'package:ptc/ui/programmer/widget/equip_label.dart';
import 'package:ptc/ui/programmer/widget/set_group.dart';
import 'package:ptc/ui/programmer/util_groups.dart';
import 'package:ptc/ui/programmer/widget/headers.dart';
import 'package:ptc/ui/programmer/widget/legend.dart';
import 'package:ptc/ui/programmer/widget/totals.dart';
import 'package:ptc/ui/programmer/widget/widgets.dart';

class ProgrammerBuilder extends ConsumerWidget {
  ProgrammerBuilder({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final program = ref.watch(programProvider);
    final notifier = ref.read(programProvider.notifier);
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
              notifier.add(SetGroup(69));
            },
            icon: const Icon(Icons.add),
            // style: IconButton.styleFrom(
            //   minimumSize: const Size(40, 40),
            //   ),
          ),
          const Text('Exercise sets'),
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
                        title: Text('Add an exercise which recruits $g'),
                        children: [
                          const Text(
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
                                  .where((e) => e.recruitment(g) > 0)
                                  .where((e) => e.id.toLowerCase().contains(
                                      textEditingValue.text.toLowerCase()))
                                  .toList();
                              opts.sort((a, b) => (b.recruitment(g))
                                  .compareTo(a.recruitment(g)));
                              return opts;
                            },
                            onSelected: (e) {
                              context.pop();
                              notifier.add(SetGroup(69, ex: e));
                            },
                          )
                        ],
                      );
                    },
                  );
                },
                child:
                    const SizedBox(width: 30, child: Icon(Icons.add, size: 16)),
                //style: IconButton.styleFrom(
                //  maximumSize: const Size(30, 30),
                //),
              )))
        ],
      ),
      const Divider(),
      ...program.setGroups.mapIndexed((i, s) => Row(children: [
            DropdownButton<int>(
              value: s.n,
              items: List.generate(10, (index) => index + 1)
                  .map<DropdownMenuItem<int>>((int value) {
                return DropdownMenuItem<int>(
                  value: value,
                  child: Text(value.toString()),
                );
              }).toList(),
              onChanged: (int? newValue) {
                notifier.updateSetGroup(s, (s) {
                  s.n = newValue!;
                  return s;
                });
              },
            ),
            DropdownButton<int>(
              value: s.intensity,
              items: <int>[69, 70].map<DropdownMenuItem<int>>((int value) {
                return DropdownMenuItem<int>(
                  value: value,
                  child: Text(value.toString()),
                );
              }).toList(),
              onChanged: (int? newValue) {
                notifier.updateSetGroup(s, (s) {
                  s.intensity = newValue!;
                  return s;
                });
              },
            ),
            IconButton(
              onPressed: () {
                notifier.updateSetGroup(s, (s) {
                  s.ex = null;
                  return s;
                });
              },
              icon: const Icon(Icons.edit),
              style: IconButton.styleFrom(
                  //  minimumSize: const Size(40, 40), -- used to work
                  ),
            ),
            IconButton(
              onPressed: () {
                program.setGroups.remove(s);
              },
              icon: const Icon(Icons.delete),
              style: IconButton.styleFrom(
                  //  minimumSize: const Size(40, 40), -- used to work
                  ),
            ),
            SetGroupWidget(s, (ex) {
              program.setGroups[i].ex = ex;
            }),
            Expanded(child: Container()),
            if (s.ex != null) ...s.ex!.equipment.map((e) => EquipmentLabel(e)),
            ...ProgramGroup.values.map((g) => Container(
                height: 40,
                //  width: 40,
                color: bgColorForProgramGroup(g),
                child: Center(
                    child: muscleMark(
                        s.ex == null ? 0 : s.ex!.recruitment(g), context)))),
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
      TotalsWidget(program.setGroups),
    ]);
  }
}
