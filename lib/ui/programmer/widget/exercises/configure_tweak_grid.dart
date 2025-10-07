import 'package:bodybuild/model/programmer/set_group.dart';
import 'package:bodybuild/ui/core/widget/configure_tweak_large.dart';
import 'package:bodybuild/ui/core/widget/configure_tweak_small.dart';
import 'package:bodybuild/util/string_extension.dart';
import 'package:flutter/material.dart';

const minItemWidth = 300.0;
const maxItemWidth = 450.0;
const spacing = 16.0;

// caller must ensure there are tweaks to configure
// tries to occupy the horizontal space as well as possible - by putting tweak configuration options
// next to each other - in order to minimize vertical space used
// could be more optimal (e.g. by putting tweak configs with similar heights on the same row,
// but i don't know how to do that)
class ConfigureTweakGrid extends StatelessWidget {
  const ConfigureTweakGrid({
    super.key,
    required this.sets,
    this.onChange,
    required this.showDetailedTweaks,
  });

  final Sets sets;
  final Function(Sets)? onChange;
  final bool showDetailedTweaks;

  // calculate the width needed to display all tweaks
  // this assumes we can fit all tweaks on one row. In practice, due to width constraints we
  // may wrap onto multiple rows. However, if there are not many tweaks (and the screen is large),
  // than this width may be less than the constraints, and then this becomes a useful parameter
  // to size up other widgets that are above or below this grid.
  static double idealWidth(Sets sets) {
    final spaceTweaks = sets.ex!.tweaks.length * maxItemWidth;
    final spaceSpacing = (sets.ex!.tweaks.length - 1) * spacing; // this assumes we have at least 1
    return spaceTweaks + spaceSpacing;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate optimal item width based on available space
        // We either make items wider to use leftover horizontal space (and make them less tall)
        // or make items narrower to fit more items on one row
        final availableWidth = constraints.maxWidth;

        // Determine how many items can fit per row
        int itemsPerRow = (availableWidth / (minItemWidth + spacing)).floor();
        itemsPerRow = itemsPerRow.clamp(1, sets.ex!.tweaks.length);

        // Calculate actual item width to fill available space
        final totalSpacing = (itemsPerRow - 1) * spacing;
        final calculatedWidth = (availableWidth - totalSpacing) / itemsPerRow;

        // Clamp to min/max bounds
        // Note that actual width used may be less than availableWidth
        // (if there are only few tweaks and there's a big screen). See idealWidth()
        final itemWidth = calculatedWidth.clamp(minItemWidth, maxItemWidth);

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: sets.ex!.tweaks
              .map(
                (tweak) => SizedBox(
                  width: itemWidth,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        tweak.name.capitalizeFirstOnlyButKeepAcronym(),
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      if (showDetailedTweaks)
                        ConfigureTweakLarge(
                          tweak,
                          sets,
                          onChange: onChange != null
                              ? (value) {
                                  onChange!(
                                    sets.copyWith(
                                      tweakOptions: {...sets.tweakOptions, tweak.name: value},
                                    ),
                                  );
                                }
                              : null,
                        )
                      else
                        ConfigureTweakSmall(
                          tweak,
                          sets,
                          onChange: onChange != null
                              ? (value) {
                                  onChange!(
                                    sets.copyWith(
                                      tweakOptions: {...sets.tweakOptions, tweak.name: value},
                                    ),
                                  );
                                }
                              : null,
                        ),
                    ],
                  ),
                ),
              )
              .toList(),
        );
      },
    );
  }
}
