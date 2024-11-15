import 'package:flutter/material.dart';
import 'package:ptc/data/anatomy/articulations.dart';
import 'package:ptc/model/anatomy/movements.dart';
import 'package:ptc/data/anatomy/muscles.dart';
import 'package:ptc/ui/anatomy/widget/articulation_button.dart';
import 'package:ptc/ui/anatomy/widget/insufficiency_widget.dart';
import 'package:ptc/ui/anatomy/widget/muscle_button.dart';
import 'package:ptc/ui/anatomy/widget/range_widget.dart';
import 'package:ptc/util.dart';

const double chartHeight = 100;

class ArticulationScreen extends StatelessWidget {
  static const routeName = 'articulation';
  final String id;
  const ArticulationScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    final articulation = Articulation.values.firstWhere((a) => a.name == id);
    final am = ArticulationMovements(articulation);
    final (direct, indirect) = relatedArticulations(articulation);
    final insufficientMuscles = muscles
        .expand((m) => m.heads.map((h) => MapEntry(m, h)))
        .where((mh) =>
            (mh.value.activeInsufficiency != null &&
                mh.value.activeInsufficiency!.factors
                    .any((f) => f.articulation == articulation)) ||
            (mh.value.passiveInsufficiency != null &&
                mh.value.passiveInsufficiency!.factors
                    .any((f) => f.articulation == articulation)));
    return Scaffold(
      appBar: AppBar(
        title: Text('Articulation: ${articulation.name.camelToTitle()}'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text('Related articulations',
                style: Theme.of(context).textTheme.titleLarge),
            const Divider(),
            const SizedBox(height: 8),
            Row(
              children: direct.map((a) => ArticulationButton(a)).toList(),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children:
                  indirect.map((a) => ArticulationButton(a, size: 10)).toList(),
            ),
            Text('Involved muscles',
                style: Theme.of(context).textTheme.titleLarge),
            const Divider(),
            const SizedBox(height: 8),
            ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 500),
                child: am.moves.isNotEmpty
                    ? RangeWidget(am)
                    : const Text('no moves for this articulation')),
            Text('Insufficient muscles/heads',
                style: Theme.of(context).textTheme.titleLarge),
            if (insufficientMuscles.isEmpty)
              const Text('no affected muscles/heads'),
            if (insufficientMuscles.isNotEmpty)
              Column(
                  children: insufficientMuscles
                      .map((m) => InsufficiencyWrapperWidget(
                            muscle: m.key,
                            head: m.value,
                            articulation: articulation,
                          ))
                      .toList()),
          ],
        ),
      ),
    );
  }
}

class InsufficiencyWrapperWidget extends StatelessWidget {
  const InsufficiencyWrapperWidget(
      {super.key,
      required this.muscle,
      required this.head,
      required this.articulation});
  final Muscle muscle;
  final Head head;
  final Articulation articulation;

  @override
  Widget build(BuildContext context) {
    final active = head.activeInsufficiency != null &&
        head.activeInsufficiency!.factors
            .any((f) => f.articulation == articulation);
    final passive = head.passiveInsufficiency != null &&
        head.passiveInsufficiency!.factors
            .any((f) => f.articulation == articulation);
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: MuscleButton(
                  muscle: muscle,
                  head: head.id,
                ),
              ),
              if (active)
                const Text('Active insufficiency',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              if (active)
                InsufficiencyWidget(
                    insufficiency: head.activeInsufficiency!,
                    articulation: articulation),
              if (passive)
                const Text('Passive insufficiency',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              if (passive)
                InsufficiencyWidget(
                    insufficiency: head.passiveInsufficiency!,
                    articulation: articulation),
            ],
          ),
        ),
      ),
    );
  }
}
