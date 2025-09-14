import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:bodybuild/data/anatomy/articulations.dart';
import 'package:bodybuild/model/anatomy/movements.dart';
import 'package:bodybuild/data/anatomy/muscles.dart';
import 'package:bodybuild/ui/anatomy/widget/articulation_button.dart';
import 'package:bodybuild/ui/anatomy/colors.dart';
import 'package:bodybuild/ui/anatomy/widget/insufficiency_widget.dart';
import 'package:bodybuild/util.dart';

const double chartHeight = 100;

class MuscleScreen extends StatelessWidget {
  static const routeName = 'muscle';
  final String id;

  const MuscleScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    final cat = MuscleCategory.values.firstWhere((m) => m.name == id);

    return Scaffold(
      appBar: AppBar(
        title: Text('Muscle Category: ${cat.name.camelToTitle()}'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...muscles.where((m) => m.categories.contains(cat)).map(
                  (m) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: MuscleWidget(muscle: m),
                      ),
                    ),
                  ),
                ),
            const SizedBox(height: 16),
            const Center(child: Legend()),
          ],
        ),
      ),
    );
  }
}

class Legend extends StatelessWidget {
  const Legend({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 4,
      children: strengthStrings.indexed
          .map((e) => Column(
                children: [
                  Container(height: 10, width: 10, color: strengthColors[e.$1]),
                  Text(e.$2),
                ],
              ))
          .toList(),
    );
  }
}

Widget table({required List<DataRow> rows}) {
  return DataTable(
    horizontalMargin: 0,
    columnSpacing: 16,
    headingRowHeight: 0,
    dataRowMinHeight: 16,
    dataRowMaxHeight: double.infinity, // For dynamic row content height.
    dividerThickness: double.minPositive,
    columns: const [
      DataColumn(label: Text('')),
      DataColumn(label: Text('')),
    ],
    rows: rows,
  );
}

class MuscleWidget extends StatelessWidget {
  final Muscle muscle;
  const MuscleWidget({super.key, required this.muscle});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Center(child: Text(muscle.name, style: Theme.of(context).textTheme.titleLarge)),
      table(
        rows: [
          if (muscle.nick.isNotEmpty)
            DataRow(cells: [
              const DataCell(Text('nicknames')),
              DataCell(Text(muscle.nick.join(', '))),
            ]),
          if (muscle.insertion != null)
            DataRow(cells: [
              const DataCell(Text('insertion')),
              DataCell(Text(muscle.insertion!.name.camelToTitle())),
            ]),
          if (muscle is SingleHeadMuscle) ...headRows((muscle as SingleHeadMuscle).wholeHead),
        ],
      ),
      if (muscle.pseudo) const Text('note: this is a "pseudo" muscle'),
      const SizedBox(height: 16),
      if (muscle is MultiHeadMuscle) Text('Heads', style: Theme.of(context).textTheme.titleMedium),
      if (muscle is MultiHeadMuscle) const Divider(),
      if (muscle is MultiHeadMuscle) const SizedBox(height: 8),
      if (muscle is MultiHeadMuscle)
        ...(muscle as MultiHeadMuscle)
            .headsMap
            .values
            .map<Widget>((h) => MuscleHeadWidget(head: h))
            .insertBetween(
              const SizedBox(height: 8),
            ),
      const SizedBox(height: 16),
      Text('Movements', style: Theme.of(context).textTheme.titleMedium),
      const Divider(),
      const SizedBox(height: 8),
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          horizontalMargin: 0,
          columnSpacing: 16,
          columns: [
            const DataColumn(label: Text('Articulation')),
            ...muscle.heads
                .map((h) => DataColumn(label: Text(h.name.camelToTitle().replaceAll(", ", "\n")))),
          ],
          rows: muscle
              .getArticulations()
              .map<DataRow>((a) => DataRow(cells: [
                    DataCell(
                      ArticulationButton(a),
                    ),
                    ...muscle.heads.map(
                      (h) => DataCell(Center(child: _checkmarkForHead(muscle, h, a))),
                    )
                  ]))
              .toList(),
        ),
      ),
    ]);
  }
}

// return the movement for the muscle head, if any is found
// we first look at the head's own movements, and fallback to the
// ones for the whole muscle
Movement? _movementForHead(Muscle muscle, Head head, Articulation a) {
  final mo = muscle.heads
      .firstWhere((h) => h.name == head.name)
      .movements
      .firstWhereOrNull((m) => m.articulation == a);
  if (mo != null) {
    return mo;
  }
  if (muscle is MultiHeadMuscle) {
    return muscle.movements.firstWhereOrNull((m) => m.articulation == a);
  }
  return null;
}

Widget _checkmarkForHead(Muscle muscle, Head head, Articulation a) {
  final m = _movementForHead(muscle, head, a);
  return m != null ? Icon(Icons.check, color: strengthColors[m.strength - 1]) : const Offstage();
}

class MuscleHeadWidget extends StatelessWidget {
  final Head head;
  const MuscleHeadWidget({super.key, required this.head});

  @override
  Widget build(BuildContext context) {
    final title = head.name.capitalizeFirstOnly();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          table(rows: headRows(head)),
        ],
      ),
    );
  }
}

List<DataRow> headRows(Head head) {
  return [
    if (head.nick.isNotEmpty)
      DataRow(
        cells: [
          const DataCell(Text('nicknames')),
          DataCell(Text((head.nick.map((n) => '$n head')).join(', '))),
        ],
      ),
    DataRow(cells: [
      const DataCell(Text('origins')),
      DataCell(Text(head.origin.map((o) => o.name.camelToTitle()).join(', '))),
    ]),
    DataRow(cells: [
      const DataCell(Text('articulation')),
      DataCell(Text(articularString(head.articular))),
    ]),
    if (head.activeInsufficiency != null)
      DataRow(cells: [
        const DataCell(Text('active insufficiency')),
        DataCell(Padding(
          padding: const EdgeInsets.only(top: 8, bottom: 8),
          child: InsufficiencyWidget(
            insufficiency: head.activeInsufficiency!,
          ),
        )),
      ]),
    if (head.passiveInsufficiency != null)
      DataRow(cells: [
        const DataCell(Text('passive insufficiency')),
        DataCell(Padding(
          padding: const EdgeInsets.only(top: 8, bottom: 8),
          child: InsufficiencyWidget(
            insufficiency: head.passiveInsufficiency!,
          ),
        )),
      ]),
  ];
}

String articularString(int articular) {
  return switch (articular) {
    1 => 'mono-articulate',
    2 => 'bi-articulate',
    3 => 'tri-articulate',
    int() => 'articulate $articular is not supported',
  };
}
