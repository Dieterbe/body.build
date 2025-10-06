import 'package:bodybuild/data/programmer/tweak.dart';
import 'package:bodybuild/model/programmer/set_group.dart';
import 'package:flutter/material.dart';

class ConfigureTweakSmall extends StatelessWidget {
  const ConfigureTweakSmall(this.tweak, this.sets, {super.key, this.onChange});
  final Tweak tweak;
  final Sets sets; // current set against which we apply the tweak
  final void Function(String)? onChange;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: (tweak.opts.entries.toList()..sort((a, b) => a.key.compareTo(b.key))).map((opt) {
        final isSelected = (sets.tweakOptions[tweak.name] ?? tweak.defaultVal) == opt.key;
        return ChoiceChip(
          label: Text(opt.key),
          selected: isSelected,
          onSelected: onChange != null
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
