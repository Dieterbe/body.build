import 'package:bodybuild/model/programmer/parameters.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:bodybuild/data/programmer/exercises.dart';
import 'package:bodybuild/data/programmer/groups.dart';
import 'package:bodybuild/model/programmer/set_group.dart';
import 'package:bodybuild/model/programmer/settings.dart';
import 'package:bodybuild/model/programmer/workout.dart';
import 'package:bodybuild/ui/programmer/util_groups.dart';
import 'package:bodybuild/ui/programmer/widget/pulse_widget.dart';
import 'package:bodybuild/ui/programmer/widget/rating_icon.dart';
import 'package:posthog_flutter/posthog_flutter.dart';

class BuilderWorkoutSetsHeader extends StatelessWidget {
  final Workout workout;
  final Settings setup;
  final Function(Workout) onChange;
  const BuilderWorkoutSetsHeader(this.workout, this.setup, {required this.onChange, super.key});

  @override
  Widget build(BuildContext context) {
    // this layout matches BuilderSets
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16), // affects alignment
      child: Row(
        children: [
          Flexible(
            flex: 45,
            child: Row(
              children: [
                Flexible(flex: 15, child: _setsLabel(context)),
                Flexible(flex: 15, child: _intensityLabel(context)),
                Flexible(flex: 35, child: Container()),
                Flexible(flex: 70, child: _exerciseLabel(context)),
                Flexible(flex: 35, child: _equipmentLabel(context)),
              ],
            ),
          ),
          Flexible(flex: 55, child: _recruitmentLabels(context)),
        ],
      ),
    );
  }

  Widget _setsLabel(BuildContext context) => Align(
    alignment: Alignment.centerLeft,
    child: Text(
      'Sets',
      style: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: MediaQuery.sizeOf(context).width / 80,
        letterSpacing: 0.3,
        color: Theme.of(context).colorScheme.primary,
      ),
    ),
  );

  Widget _intensityLabel(BuildContext context) => Align(
    alignment: Alignment.centerLeft,
    child: Text(
      '%1RM',
      style: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: MediaQuery.sizeOf(context).width / 80,
        letterSpacing: 0.3,
        color: Theme.of(context).colorScheme.primary,
      ),
    ),
  );

  Widget _exerciseLabel(BuildContext context) => Align(
    alignment: Alignment.centerLeft,
    child: Text(
      'Exercise',
      style: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: MediaQuery.sizeOf(context).width / 80,
        letterSpacing: 0.3,
        color: Theme.of(context).colorScheme.primary,
      ),
    ),
  );

  Widget _equipmentLabel(BuildContext context) => Align(
    alignment: Alignment.centerLeft,
    child: Text(
      'Equipment',
      style: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: MediaQuery.sizeOf(context).width / 80,
        letterSpacing: 0.3,
        color: Theme.of(context).colorScheme.primary,
      ),
    ),
  );

  Widget _recruitmentLabels(BuildContext context) => Row(
    children: ProgramGroup.values
        .map(
          (g) => Expanded(
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: bgColorForProgramGroup(g),
                borderRadius: BorderRadius.circular(8),
              ),
              child: PulseWidget(
                pulse: workout.setGroups.isEmpty,
                child: GestureDetector(
                  onTap: () async {
                    await Posthog().capture(
                      eventName: 'AddSetButtonClicked',
                      properties: {'muscle': g.name, 'setgroups': workout.setGroups.length},
                    );

                    showDialog(
                      context: context,
                      builder: (context) {
                        return addSetDialog(context, setup, g);
                      },
                    );
                  },
                  child: Icon(
                    Icons.add_circle_outline,
                    size: 18,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ),
          ),
        )
        .toList(),
  );

  Iterable<Sets> toSetsFor(Ex ex, Parameters params, ProgramGroup g) {
    // For each modifier that affects this program group, collect all its options
    Map<String, List<String>> modifierOptions = {};

    // First pass: identify modifiers that cause variations in recruitment or ratings for this program group
    // Note: different modifiers may not actually result in different recruitment or ratings numbers, but them being included is
    // a good clue that they probably do differ.
    for (final modifier in ex.modifiers) {
      bool hasRecruitmentVariation = modifier.opts.entries.any(
        (entry) => entry.value.$1.containsKey(g),
      );
      bool hasRatingVariation = ex.ratings.any(
        (rating) => rating.pg.contains(g) && rating.modifiers.containsKey(modifier.name),
      );

      if (hasRecruitmentVariation || hasRatingVariation) {
        modifierOptions[modifier.name] = modifier.opts.keys.toList();
      }
    }

    // If no modifiers affect this group's recruitment or ratings, return a single Sets with default values
    if (modifierOptions.isEmpty) {
      return [Sets(params.intensities.first, ex: ex, modifierOptions: {})];
    }

    // Generate all possible combinations of modifier options
    var allCombinations = [
      {for (var entry in modifierOptions.entries) entry.key: entry.value.first},
    ];
    modifierOptions.forEach((name, options) {
      allCombinations = allCombinations
          .expand((combo) => options.map((opt) => {...combo, name: opt}))
          .toList();
    });

    // Create a Sets object for each unique combination
    return allCombinations.map(
      (modifiers) => Sets(params.intensities.first, ex: ex, modifierOptions: modifiers),
    );
  }

  Widget addSetDialog(BuildContext context, Settings setup, ProgramGroup g) => SimpleDialog(
    contentPadding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
    title: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Add set for: ${g.displayName}',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Text(
          'Exercises matching your equipment filter are shown in order of recruitment of the ${g.displayName}.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
        const Divider(height: 24),
      ],
    ),
    children: [
      ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 800),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Autocomplete<Sets>(
            optionsBuilder: (textEditingValue) {
              final opts = setup.availableExercises
                  .where(
                    (e) => e.id.toLowerCase().contains(
                      textEditingValue.text.toLowerCase().toLowerCase(),
                    ),
                  )
                  .expand((e) => toSetsFor(e, setup.paramFinal, g))
                  .where((e) => e.recruitmentFiltered(g, 0) > 0)
                  .toList();
              opts.sort((a, b) {
                // First compare by recruitment value
                final recruitmentCompare = b
                    .recruitmentFiltered(g, 0)
                    .compareTo(a.recruitmentFiltered(g, 0));
                if (recruitmentCompare != 0) return recruitmentCompare;

                // If recruitment is equal, compare by average rating
                final aRatings = a
                    .getApplicableRatings()
                    .where((r) => r.pg.contains(g))
                    .map((r) => r.score)
                    .toList();
                final bRatings = b
                    .getApplicableRatings()
                    .where((r) => r.pg.contains(g))
                    .map((r) => r.score)
                    .toList();

                final aAvg = aRatings.isEmpty
                    ? 0.0
                    : aRatings.reduce((sum, score) => sum + score) / aRatings.length;
                final bAvg = bRatings.isEmpty
                    ? 0.0
                    : bRatings.reduce((sum, score) => sum + score) / bRatings.length;

                final ratingCompare = bAvg.compareTo(aAvg);
                if (ratingCompare != 0) return ratingCompare;

                // If both recruitment and rating are equal, sort by exercise ID
                return a.ex!.id.compareTo(b.ex!.id);
              });
              return opts;
            },
            displayStringForOption: (e) => e.ex!.id,
            fieldViewBuilder: (context, controller, focusNode, onSubmitted) {
              return TextField(
                controller: controller,
                focusNode: focusNode,
                onSubmitted: (value) => onSubmitted(),
                decoration: InputDecoration(
                  hintText: 'Search exercises...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
              );
            },
            optionsViewBuilder: (context, onSelected, options) {
              return Align(
                alignment: Alignment.topLeft,
                child: Material(
                  elevation: 4,
                  borderRadius: BorderRadius.circular(8),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: 200, maxWidth: 800),
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemCount: options.length,
                      itemBuilder: (context, index) {
                        final option = options.elementAt(index);
                        final volume = option.recruitmentFiltered(g, 0);
                        return ListTile(
                          dense: true,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          title: Row(
                            children: [
                              Text(
                                option.ex!.id,
                                style: TextStyle(fontSize: MediaQuery.sizeOf(context).width / 110),
                              ),
                              if (option.modifierOptions.isNotEmpty) ...[
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Wrap(
                                    spacing: 8,
                                    runSpacing: 4,
                                    children: option.modifierOptions.entries.map((entry) {
                                      return Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.primary.withValues(alpha: 0.1),
                                          borderRadius: BorderRadius.circular(4),
                                          border: Border.all(
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.primary.withValues(alpha: 0.5),
                                            width: 1,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              entry.key,
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: Theme.of(context).colorScheme.primary,
                                              ),
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              entry.value,
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Theme.of(context).colorScheme.primary,
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          trailing: Builder(
                            builder: (context) {
                              final relevantRatings = option
                                  .getApplicableRatings()
                                  .where((r) => r.pg.contains(g))
                                  .toList();
                              return Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (relevantRatings.isNotEmpty) ...[
                                    Padding(
                                      padding: const EdgeInsets.only(right: 8),
                                      child: RatingIcon(
                                        ratings: relevantRatings,
                                        size: MediaQuery.sizeOf(context).width / 60,
                                      ),
                                    ),
                                  ],
                                  SizedBox(
                                    width: 100,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Expanded(
                                          child: LinearProgressIndicator(
                                            value: volume,
                                            backgroundColor: Theme.of(
                                              context,
                                            ).colorScheme.primary.withValues(alpha: 0.1),
                                            minHeight: 8,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          '${(volume * 100).toStringAsFixed(0)}%',
                                          style: Theme.of(context).textTheme.bodySmall,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                          onTap: () {
                            onSelected(option);
                            onChange(
                              workout.copyWith(
                                setGroups: [
                                  ...workout.setGroups,
                                  SetGroup([option]),
                                ],
                              ),
                            );
                            context.pop();
                          },
                        );
                      },
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    ],
  );
}
