import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:bodybuild/data/programmer/exercises.dart';
import 'package:bodybuild/data/programmer/groups.dart';
import 'package:bodybuild/model/programmer/set_group.dart';
import 'package:bodybuild/model/programmer/settings.dart';
import 'package:bodybuild/model/programmer/workout.dart';
import 'package:bodybuild/ui/programmer/util_groups.dart';
import 'package:bodybuild/ui/programmer/widget/pulse_widget.dart';

class BuilderWorkoutSetsHeader extends StatelessWidget {
  final Workout workout;
  final Settings setup;
  final Function(Workout) onChange;
  const BuilderWorkoutSetsHeader(
    this.workout,
    this.setup, {
    required this.onChange,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
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
                  Flexible(flex: 20, child: Container()),
                  Flexible(flex: 70, child: _exerciseLabel(context)),
                  Flexible(flex: 35, child: _equipmentLabel(context)),
                ],
              )),
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
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return addSetDialog(
                              context,
                              setup,
                              g,
                            );
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

  Widget addSetDialog(BuildContext context, Settings setup, ProgramGroup g) =>
      SimpleDialog(
        contentPadding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Add set for: ${g.displayName}',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Exercises matching your equipment filter are shown in order of recruitment of the ${g.displayName}.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.7),
                  ),
            ),
            const Divider(height: 24),
          ],
        ),
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Autocomplete<Ex>(
                optionsBuilder: (textEditingValue) {
                  final opts = setup.availableExercises
                      .where((e) =>
                          e.recruitment(
                            g,
                            {
                              // TODO: add form modifiers
                            },
                          ).volume >
                          0)
                      .where((e) => e.id
                          .toLowerCase()
                          .contains(textEditingValue.text.toLowerCase()))
                      .toList();
                  opts.sort((a, b) => (b.recruitment(g, {}).volume)
                      .compareTo(a.recruitment(g, {}).volume));
                  return opts;
                },
                displayStringForOption: (e) => e.id,
                fieldViewBuilder:
                    (context, controller, focusNode, onSubmitted) {
                  return TextField(
                    controller: controller,
                    focusNode: focusNode,
                    onSubmitted: (value) => onSubmitted(),
                    decoration: InputDecoration(
                      hintText: 'Search exercises...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
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
                        constraints: const BoxConstraints(
                          maxHeight: 200,
                          maxWidth: 400,
                        ),
                        child: ListView.builder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          itemCount: options.length,
                          itemBuilder: (context, index) {
                            final option = options.elementAt(index);
                            final volume = option.recruitment(g, {}).volume;
                            return ListTile(
                              dense: true,
                              title: Text(option.id),
                              trailing: SizedBox(
                                width: 100,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Expanded(
                                      child: LinearProgressIndicator(
                                        value: volume,
                                        backgroundColor: Theme.of(context)
                                            .colorScheme
                                            .primary
                                            .withValues(alpha: 0.1),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      '${(volume * 100).toStringAsFixed(0)}%',
                                      style:
                                          Theme.of(context).textTheme.bodySmall,
                                    ),
                                  ],
                                ),
                              ),
                              onTap: () {
                                onSelected(option);
                                onChange(workout.copyWith(setGroups: [
                                  ...workout.setGroups,
                                  SetGroup([
                                    Sets(setup.paramFinal.intensities.first,
                                        ex: option)
                                  ])
                                ]));
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
