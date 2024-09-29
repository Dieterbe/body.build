import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ptc/backend/movements.dart';
import 'package:ptc/backend/muscles.dart';
import 'package:ptc/ui/articulation_screen.dart';
import 'package:ptc/util.dart';

const double chartHeight = 100;

class MuscleScreen extends StatelessWidget {
  static const routeName = 'muscle';
  final String id;

  const MuscleScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    final muscle = Muscle.values.firstWhere((m) => m.name == id);
    final moves = movements.where((m) => m.muscle == muscle).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Muscle: ${muscle.name.camelToTitle()}'),
      ),
      body: SingleChildScrollView(
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(muscle.name.camelToTitle(),
                    style: Theme.of(context).textTheme.titleLarge),
                const Divider(),
                //SizedBox(height: 8),
                DataTable(
                  headingRowHeight: 0,
                  dividerThickness: double.minPositive,
                  columns: const [
                    DataColumn(label: Text('')),
                    DataColumn(label: Text('')),
                  ],
                  rows: [
                    if (muscle.nick.isNotEmpty)
                      DataRow(cells: [
                        const DataCell(Text('nicknames')),
                        DataCell(Text(muscle.nick.join(', '))),
                      ]),
                    DataRow(cells: [
                      const DataCell(Text('insertion')),
                      DataCell(Text(muscle.insertion.name.camelToTitle())),
                    ]),
                  ],
                ),
                if (muscle.pseudo)
                  const Text('note: this is a "pseudo" muscle'),
                const SizedBox(height: 16),
                Text('Heads', style: Theme.of(context).textTheme.titleLarge),
                const Divider(),
                const SizedBox(height: 8),
                ...muscle.heads.values
                    .map<Widget>(
                        (h) => MuscleHeadWidget(muscle: muscle, head: h))
                    .insertBetween(
                      const SizedBox(height: 8),
                    ),
                const SizedBox(height: 16),
                Text('Movements',
                    style: Theme.of(context).textTheme.titleLarge),
                const Divider(),
                const SizedBox(height: 8),
                ...moves.map((m) => Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          child: ElevatedButton(
                            onPressed: () => context.pushNamed(
                              ArticulationScreen.routeName,
                              pathParameters: {"id": m.articulation.name},
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // const Iconify(IconParkOutline.muscle, size: 20),
                                Text(m.articulation.name.camelToTitle()),
                              ],
                            ),
                          ),
                        ),
                        if (m.head != null) Text('${m.head!} head only'),
                      ],
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MuscleHeadWidget extends StatelessWidget {
  final Muscle muscle;
  final Head head;
  const MuscleHeadWidget({super.key, required this.muscle, required this.head});

  @override
  Widget build(BuildContext context) {
    final title = (head.name == 'whole' ? 'whole muscle' : '${head.name} head')
        .capitalize();
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            if (head.nick.isNotEmpty)
              Text(
                  'nicknames: ${(head.nick.map((n) => '$n head')).join(', ')}'),
            Text(
                'origins: ${head.origin.map((o) => o.name.camelToTitle()).join(', ')}'),
            switch (head.articular) {
              1 => const Text('mono-articulate'),
              2 => const Text('bi-articulate'),
              3 => const Text('tri-articulate'),
              int() => Text(
                  'muscle $muscle has articulate ${head.articular} which is not supported'),
            },
            if (head.passiveInsufficiency != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: InsufficiencyWidget(
                  type: "active",
                  insufficiency: head.passiveInsufficiency!,
                ),
              ),
            if (head.activeInsufficiency != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: InsufficiencyWidget(
                  type: "passive",
                  insufficiency: head.activeInsufficiency!,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class InsufficiencyWidget extends StatelessWidget {
  const InsufficiencyWidget(
      {super.key, required this.type, required this.insufficiency});
  final String type;
  final Insufficiency insufficiency;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$type insufficiency:',
            style: Theme.of(context).textTheme.titleSmall),
        if (insufficiency.comment != null) Text('(${insufficiency.comment!})'),
        const Text('Conditions:'),
        ...insufficiency.factors.map((i) => Text(i.toString())),
      ],
    );
  }
}
