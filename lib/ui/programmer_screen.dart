import 'dart:math';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ptc/programming/ex_set.dart';
import 'package:ptc/programming/exercises.dart';
import 'package:ptc/programming/groups.dart';
import 'package:ptc/ui/equip_label.dart';
import 'package:ptc/ui/ex_set.dart';
import 'package:ptc/ui/groups.dart';
import 'package:ptc/ui/label_bar.dart';
import 'package:ptc/ui/programmer_config.dart';
import 'package:ptc/util.dart';

class ProgrammerScreen extends StatefulWidget {
  const ProgrammerScreen({super.key});

  static const routeName = 'programmer';

  @override
  State<ProgrammerScreen> createState() => _ProgrammerScreenState();
}

class _ProgrammerScreenState extends State<ProgrammerScreen> {
  List<ExSet> sets = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Programmer'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(children: [
            const LabelBar("Set up"),
            const ProgrammerConfig(),
            const LabelBar("Exercise selector"),
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
                        print('clicked');
                        showDialog(
                          context: context,
                          builder: (context) {
                            return SimpleDialog(
                              title:
                                  Text('Add an exercise which recruits ${g}'),
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
                                        .where((e) => e.id
                                            .toLowerCase()
                                            .contains(textEditingValue.text
                                                .toLowerCase()))
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
                  if (s.ex != null)
                    ...s.ex!.equipment.map((e) => EquipmentLabel(e)),
                  ...ProgramGroup.values.map((g) => Container(
                      height: 40,
                      //  width: 40,
                      color: bgColorForProgramGroup(g),
                      child: Center(
                          child:
                              muscleMark(s.ex?.va.assign[g] ?? 0.0, context)))),
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
          ]),
        ),
      ),
    );
  }
}

Widget rotatedText(String text) {
  return FittedBox(
    fit: BoxFit.cover,
    child: Transform.rotate(
      angle: 45 / 180 * 3.14,
      child: Text(text),
    ),
  );
}

Widget muscleMark(double recruitment, BuildContext context) {
  return Container(
    // padding: const EdgeInsets.all(2.0),
    width: 30,
    height: 30,
    color: Theme.of(context).colorScheme.primary.withOpacity(recruitment),
  );
}

Widget headers() {
  // when column headers are horizontal, they take too much space
  // when they are vertical, you have to twist your neck to read them
  // so we want 45 degree rotation to make them more compact horizontally, but still readable.
  // However:
  // * RotationTransition(turns: AlwaysStoppedAnimation(7/8)) and Transform.rotate keep the original width (making the rotation pointless)
  // * RotatedBox uses width/height afer rotation, during layout - perfect for what we need - but only supports 90degree rotations, not 45.
  // * OverflowBox(Transform.rotate) results in errors
  // So the solution is to first vertically rotate the with RotatedBox, so the layout engine uses the constraints of tall&narrow text boxes,
  // and after layouting, turn it by 45 degrees to make it more legible
//
// hack: create a stack of (invisible) text boxes on top of each other
// the resulting widget will have the width of whichever is the longest of the text boxes
// therefore, by stacking each entry on top of this stack, they all have the same length
// and therefore, consistent rotation origins
  /* final all = ProgramGroup.values
      .map((e) => Opacity(
            opacity: 0,
            child: Text(
              e.name.camelToTitle(),
            ),
          ))
      .toList();
      */
  // better hack which reduces the number of widgets: just manually define the longest one...
  const dummy = Opacity(
    opacity: 0,
    child: Text('Quads Rectus Femoris'),
  );
  return Transform.translate(
    offset: const Offset(
        0, -10), // because we pivot around bottom center, raise text up a bit
    child: Row(
        children: ProgramGroup.values
            .map((e) => Transform.rotate(
                alignment: Alignment.bottomCenter,
                angle: pi / 4,
                child: RotatedBox(
                  quarterTurns: 3,
                  child: Container(
                    color: bgColorForProgramGroup(e),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Stack(children: [
                        SizedBox(
                          height: 26,
                          child: Text(e.name.camelToTitle()),
                        ),
                        dummy,
                      ]),
                    ),
                  ),
                )))
            .toList()),
  );
}

class Legend extends StatelessWidget {
  const Legend({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      const Spacer(),
      const Text('Legend'),
      const SizedBox(width: 30),
      const Text('0.25'),
      const SizedBox(width: 4),
      muscleMark(0.25, context),
      const SizedBox(width: 30),
      const Text('0.5'),
      const SizedBox(width: 4),
      muscleMark(0.5, context),
      const SizedBox(width: 30),
      const Text('0.75'),
      const SizedBox(width: 4),
      muscleMark(0.75, context),
      const SizedBox(width: 30),
      const Text('1.0'),
      const SizedBox(width: 4),
      muscleMark(1.0, context),
    ]);
  }
}

class TotalsWidget extends StatelessWidget {
  final List<ExSet> sets;
  const TotalsWidget(this.sets, {super.key});

// return a map with for each program group, the volume, summed from all the exercises found in our sets
// if any of the values exceeds `normalize`, we normalize wrt. to that value
// volumes < cutoff are counted as 0
  (double, Map<ProgramGroup, double>) _compute(
      double cutoff, double normalize) {
    final assignments =
        sets.where((s) => s.ex != null).map((s) => s.ex!.va.assign);
    final totals = assignments.fold<Map<ProgramGroup, double>>(
        {for (var group in ProgramGroup.values) group: 0.0},
        (totals, assign) => {
              for (var group in ProgramGroup.values)
                group: totals[group]! +
                    ((assign[group] ?? 0.0) >= cutoff ? assign[group]! : 0.0)
            });
    final maxVal = totals.values.reduce(max);
    if (maxVal <= normalize) {
      return (maxVal, totals);
    }
    // if maxVal is 6 and normalize is 3, we need to divide every value by 2
    // i.o.w. each value in totals needs to be divided by `maxVal` and multiplied by `normalize`
    return (
      normalize,
      Map.fromEntries(totals.entries
          .map((e) => MapEntry(e.key, (e.value / maxVal) * normalize)))
    );
  }

  @override
  Widget build(BuildContext context) {
    final (maxVal, totals) = _compute(0.5, 2);
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: Container()),
            GestureDetector(
              onTap: () {
                print('clicked');
              },
              child: const Text(
                "Total volume\n(only counts volumes >=0.5)",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
            const SizedBox(width: 30),
            ...ProgramGroup.values
                .map((g) => Stack(alignment: Alignment.bottomCenter, children: [
                      Container(
                        width: 30,
                        height: max(40 * maxVal, 40),
                        color: bgColorForProgramGroup(g),
                      ),
                      Container(
                        width: 30,
                        height: 40 * totals[g]!,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ]))
          ],
        ),
        Row(
          children: [
            Expanded(child: Container()),
            ...ProgramGroup.values.map((g) => Container(
                  width: 30,
                  height: 40,
                  color: bgColorForProgramGroup(g),
                  child: totals[g]! == 0
                      ? const Offstage()
                      : Center(
                          child: Text(
                          totals[g]!.toStringAsFixed(1),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        )),
                ))
          ],
        )
      ],
    );
  }
}

/*
volume distribution?
menno says: equal for all muscles
Jeff nippard says back quads glutes can handle more volume. https://youtu.be/ekQxEEjYLDI?si=KtMthjzxUAl4Md50 5:13
*/