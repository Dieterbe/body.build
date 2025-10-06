import 'package:bodybuild/data/programmer/tweak.dart';
import 'package:bodybuild/model/programmer/set_group.dart';
import 'package:bodybuild/ui/core/markdown.dart';
import 'package:bodybuild/ui/core/util_ratings.dart';
import 'package:flutter/material.dart';

class ConfigureTweakLarge extends StatelessWidget {
  const ConfigureTweakLarge(this.tweak, this.sets, {super.key, this.onChange});
  final Tweak tweak;
  final Sets sets; // current set against which we apply the tweak
  final void Function(String)? onChange;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ...(tweak.opts.entries.toList()..sort((a, b) => a.key.compareTo(b.key))).map((opt) {
            final optionDesc = opt.value.$2;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RadioListTile<String>(
                  title: Row(
                    children: [
                      Text(opt.key),
                      const SizedBox(width: 8),
                      buildRatingIcon(sets, tweak.name, opt.key, context),
                      if (opt.key == tweak.defaultVal) ...[
                        const SizedBox(width: 4),
                        Text(
                          '(default)',
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width / 120,
                            color: Theme.of(context).hintColor,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ],
                  ),
                  value: opt.key,
                  groupValue: sets.tweakOptions[tweak.name] ?? tweak.defaultVal,
                  onChanged: onChange != null
                      ? (value) {
                          if (value != null) {
                            onChange!(value);
                          }
                        }
                      : null,

                  contentPadding: EdgeInsets.zero,
                ),
                if (optionDesc.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(left: 56, bottom: 8),
                    child: markdown(optionDesc, context),
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
