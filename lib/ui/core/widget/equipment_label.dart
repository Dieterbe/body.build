import 'package:flutter/material.dart';
import 'package:bodybuild/data/dataset/equipment.dart';

class EquipmentLabel extends StatelessWidget {
  final Equipment e;
  final bool err;
  const EquipmentLabel(this.e, {super.key, this.err = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: err
            ? Theme.of(context).colorScheme.error
            : Theme.of(context).colorScheme.tertiaryContainer,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        e.displayName.replaceAll(' Machine', ''),
        style: Theme.of(context).textTheme.bodySmall!.copyWith(
          fontSize: MediaQuery.sizeOf(context).width / 140,
          color: err
              ? Theme.of(context).colorScheme.onError
              : Theme.of(context).colorScheme.onTertiaryContainer,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
