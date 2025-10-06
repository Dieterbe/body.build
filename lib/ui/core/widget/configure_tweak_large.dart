import 'package:bodybuild/data/programmer/tweak.dart';
import 'package:bodybuild/model/programmer/set_group.dart';
import 'package:bodybuild/ui/core/markdown.dart';
import 'package:bodybuild/ui/programmer/widget/exercise_ratings_dialog.dart';
import 'package:bodybuild/ui/programmer/widget/rating_icon_multi.dart';
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
                      _buildRatingIcon(
                        tweakName: tweak.name,
                        tweakValue: opt.key,
                        context: context,
                      ),
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

  Widget _buildRatingIcon({String? tweakName, String? tweakValue, required BuildContext context}) {
    if (sets.ex == null) return const SizedBox.shrink();

    // Get ratings for current configuration
    final currentRatings = sets.getApplicableRatingsForConfig(sets.tweakOptions).toList();

    // Create a copy of current configuration
    final tweakConfig = Map<String, String>.of(sets.tweakOptions);

    // Apply the specific option we're showing the rating for
    if (tweakName != null && tweakValue != null) {
      tweakConfig[tweakName] = tweakValue;
    }

    // Get ratings for this configuration
    final ratings = sets.getApplicableRatingsForConfig(tweakConfig).toList();

    // Only show rating icon if this option changes the ratings
    if (ratings.length == currentRatings.length) {
      bool sameRatings = true;
      for (int i = 0; i < ratings.length; i++) {
        if (ratings[i].score != currentRatings[i].score) {
          sameRatings = false;
          break;
        }
      }
      if (sameRatings) return const SizedBox.shrink();
    }

    return RatingIconMulti(
      ratings: ratings,
      onTap: ratings.isEmpty ? null : () => {showRatingsDialog(sets.ex!.id, ratings, context)},
    );
  }
}
