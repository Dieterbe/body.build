import 'package:bodybuild/data/dataset/tweak.dart';
import 'package:bodybuild/data/dataset/equipment.dart';
import 'package:bodybuild/model/programmer/set_group.dart';
import 'package:bodybuild/ui/core/markdown.dart';
import 'package:bodybuild/ui/core/util_ratings.dart';
import 'package:flutter/material.dart';

// only call this if sets.ex is not null
class ConfigureTweakLarge extends StatelessWidget {
  const ConfigureTweakLarge(
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          RadioGroup<String>(
            groupValue: sets.tweakOptions[tweak.name] ?? tweak.defaultVal,
            onChanged: (String? value) {
              if (onChange != null && value != null) {
                onChange!(value);
              }
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ...(tweak.opts.entries.toList()..sort((a, b) => a.key.compareTo(b.key))).map((opt) {
                  final optionDesc = opt.value.desc;
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

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RadioListTile<String>(
                        title: Row(
                          children: [
                            Text(
                              opt.key,
                              style: isAvailable
                                  ? const TextStyle(fontWeight: FontWeight.bold)
                                  : TextStyle(color: Theme.of(context).disabledColor),
                            ),
                            if (ratingIcon is! SizedBox) const SizedBox(width: 8),
                            ratingIcon,
                            if (opt.key == tweak.defaultVal) ...[
                              const SizedBox(width: 4),
                              Text(
                                '(default)',
                                style: TextStyle(
                                  color: Theme.of(context).hintColor,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          ],
                        ),
                        value: opt.key,
                        enabled: onChange != null && isAvailable,
                        contentPadding: EdgeInsets.zero,
                        subtitle: optionDesc.isNotEmpty ? markdown(optionDesc, context) : null,
                      ),
                    ],
                  );
                }),
              ],
            ),
          ),
          if (tweak.desc != null) ...[
            const SizedBox(height: 16),
            Padding(padding: const EdgeInsets.only(left: 2), child: markdown(tweak.desc!, context)),
          ],
        ],
      ),
    );
  }
}
