import 'package:bodybuild/data/programmer/tweak.dart';
import 'package:bodybuild/data/programmer/equipment.dart';
import 'package:bodybuild/model/programmer/set_group.dart';
import 'package:bodybuild/ui/core/util_ratings.dart';
import 'package:flutter/material.dart';

// only call this if sets.ex is not null

class ConfigureTweakSmall extends StatelessWidget {
  const ConfigureTweakSmall(
    this.tweak,
    this.sets, {
    super.key,
    this.onChange,
    this.availableEquipment,
  });
  final Tweak tweak;
  final Sets sets; // current set against which we apply the tweak
  final void Function(String)? onChange;
  final Set<Equipment>? availableEquipment; // If null, no equipment filtering

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: (tweak.opts.entries.toList()..sort((a, b) => a.key.compareTo(b.key))).map((opt) {
        final isSelected = (sets.tweakOptions[tweak.name] ?? tweak.defaultVal) == opt.key;
        final isConstraintAvailable = sets.ex!.isOptionAvailable(
          tweak.name,
          opt.key,
          sets.getFullTweakValues(),
        );

        // Check equipment availability
        final isEquipmentAvailable =
            availableEquipment == null ||
            opt.value.equipment == null ||
            availableEquipment!.contains(opt.value.equipment!);

        final isAvailable = isConstraintAvailable && isEquipmentAvailable;
        final ratingIcon = buildRatingIcon(sets, tweak.name, opt.key, context);

        return ChoiceChip(
          label: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                opt.key,
                style: !isAvailable ? TextStyle(color: Theme.of(context).disabledColor) : null,
              ),
              if (ratingIcon is! SizedBox) ...[const SizedBox(width: 6), ratingIcon],
            ],
          ),
          selected: isSelected,
          onSelected: (onChange != null && isAvailable)
              ? (selected) {
                  if (selected) {
                    onChange!(opt.key);
                  }
                }
              : null,
        );
      }).toList(),
    );
  }
}
