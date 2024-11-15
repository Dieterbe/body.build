import 'package:flutter/material.dart';
import 'package:ptc/data/programmer/exercises.dart';

class EquipmentLabel extends StatelessWidget {
  final Equipment e;
  const EquipmentLabel(this.e, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.tertiaryContainer,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        e.name,
        style: Theme.of(context).textTheme.bodySmall!.copyWith(
              color: Theme.of(context).colorScheme.onTertiaryContainer,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }
}
