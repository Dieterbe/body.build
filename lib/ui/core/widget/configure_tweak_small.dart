import 'package:bodybuild/data/programmer/tweak.dart';
import 'package:bodybuild/model/programmer/set_group.dart';
import 'package:bodybuild/ui/core/util_ratings.dart';
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
        final ratingIcon = buildRatingIcon(sets, tweak.name, opt.key, context);
        return ChoiceChip(
          label: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(opt.key),
              if (ratingIcon is! SizedBox) ...[const SizedBox(width: 6), ratingIcon],
            ],
          ),
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
