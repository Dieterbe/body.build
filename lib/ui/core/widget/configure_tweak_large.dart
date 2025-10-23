import 'package:bodybuild/data/programmer/tweak.dart';
import 'package:bodybuild/data/programmer/exercises.dart';
import 'package:bodybuild/model/programmer/set_group.dart';
import 'package:bodybuild/ui/core/markdown.dart';
import 'package:bodybuild/ui/core/util_ratings.dart';
import 'package:flutter/material.dart';

class ConfigureTweakLarge extends StatelessWidget {
  const ConfigureTweakLarge(this.tweak, this.sets, this.exercise, {super.key, this.onChange});
  final Tweak tweak;
  final Sets sets; // current set against which we apply the tweak
  final Ex exercise; // exercise to check constraints
  final void Function(String)? onChange;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ...(tweak.opts.entries.toList()..sort((a, b) => a.key.compareTo(b.key))).map((opt) {
            final optionDesc = opt.value.desc;
            final isAvailable = exercise.isOptionAvailable(tweak.name, opt.key, sets.tweakOptions);
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
                  groupValue: sets.tweakOptions[tweak.name] ?? tweak.defaultVal,
                  onChanged: (onChange != null && isAvailable)
                      ? (value) {
                          if (value != null) {
                            onChange!(value);
                          }
                        }
                      : null,

                  contentPadding: EdgeInsets.zero,
                  subtitle: optionDesc.isNotEmpty ? markdown(optionDesc, context) : null,
                ),
              ],
            );
          }),
          if (tweak.desc != null) ...[
            const SizedBox(height: 16),
            Padding(padding: const EdgeInsets.only(left: 2), child: markdown(tweak.desc!, context)),
          ],
        ],
      ),
    );
  }
}
