import 'package:flutter/material.dart';
import 'package:ptc/backend/movements.dart';
import 'package:ptc/backend/muscles.dart';
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
      body: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(muscle.name.camelToTitle(),
                  style: Theme.of(context).textTheme.titleLarge),
              SizedBox(height: 16),
              if (muscle.nick.isNotEmpty)
                Text('nicknames: ${muscle.nick.join(', ')}'),
              if (muscle.pseudo) Text('note: this is a "pseudo" muscle'),
              Text('insertion: ' + muscle.insertion.name.camelToTitle()),
              SizedBox(height: 16),
              Text('heads', style: Theme.of(context).textTheme.titleLarge),
              SizedBox(height: 12),
              ...muscle.heads.values.map(
                (h) => MuscleHeadWidget(muscle: muscle, head: h),
              ),
            ],
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(head.name == 'whole' ? 'whole muscle' : '${head.name} head',
            style: Theme.of(context).textTheme.titleMedium),
        if (head.nick.isNotEmpty)
          Text('nicknames: ${(head.nick.map((n) => '$n head')).join(', ')}'),
        Text(
            'origins: ${head.origin.map((o) => o.name.camelToTitle()).join(', ')}'),
        switch (head.articular) {
          1 => const Text('mono-articulate'),
          2 => const Text('bi-articulate'),
          3 => const Text('tri-articulate'),
          int() => Text(
              'muscle $muscle has articulate ${head.articular} which is not supported'),
        },
        if (head.passiveInsufficiency != null &&
            head.passiveInsufficiency!.isNotEmpty)
          Text(
              'passive insufficiency: ${head.passiveInsufficiency!.map((i) => i.toString()).join(' + ')}'),
        if (head.activeInsuffiency != null &&
            head.activeInsuffiency!.isNotEmpty)
          Text(
              'active insufficiency: ${head.activeInsuffiency!.map((i) => i.toString()).join(' + ')}'),
      ],
    );
  }
}
