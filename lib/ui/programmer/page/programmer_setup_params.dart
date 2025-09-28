import 'package:bodybuild/data/programmer/groups.dart';
import 'package:bodybuild/ui/core/text_style.dart';
import 'package:bodybuild/ui/programmer/widget/k_string_row.dart';
import 'package:bodybuild/ui/programmer/widget/kv_row.dart';
import 'package:bodybuild/ui/programmer/widget/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bodybuild/data/programmer/setup.dart';
import 'package:bodybuild/ui/programmer/widget/label_bar.dart';
import 'package:bodybuild/data/programmer/current_setup_profile_provider.dart';

const String helpSetsPerWeekPerMuscleGroup = '''
Number of sets per week per muscle group.  
Based on Menno's calculator.
(this includes both direct and fractional or indirect recruitment - e.g. biceps in rows)

Does not consider age, menopause, hormone replacement, diet, rest intervals, genetics, intensiveness, AAS/PED (indirectly via energy balance), etc.
Adjust as needed.

Practical tips:
* less volume for elderly TODO confirm
* more volume in follicular phase, and less in luteal phase. e.g. +- 33%
''';

class ProgrammerSetupParams extends ConsumerWidget {
  const ProgrammerSetupParams({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final setup = ref.watch(setupProvider);
    final currentProfileId = ref.watch(currentSetupProfileProvider);
    final notifier = ref.read(setupProvider.notifier);

    return setup.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
      data: (setup) {
        // Get the list of available program groups (those not already overridden)
        final availableGroups = setup.paramOverrides.setsPerWeekPerMuscleGroupIndividual == null
            ? ProgramGroup.values
            : ProgramGroup.values.where((group) => !setup
                .paramOverrides.setsPerWeekPerMuscleGroupIndividual!
                .any((override) => override.group == group));

        return Column(
          // re-initialize all values when we switch profiles
          key: currentProfileId.maybeWhen(
            data: (profileId) => ValueKey('setup_params_$profileId'),
            orElse: () => null,
          ),
          children: [
            const LabelBar('Resulting Parameters'),
            Text('these params are derived from your inputs. You may optionally override them',
                style: ts100(context)),
            Row(children: [
              Expanded(
                flex: 10,
                child: Column(children: [
                  KVRow(
                    titleTextMedium(
                        'Intensity: ${setup.paramSuggest.intensities.map((i) => i.toString()).join(',')}',
                        context),
                    v: TextFormField(
                      key: const ValueKey('intensities'),
                      initialValue: (setup.paramOverrides.intensities == null)
                          ? ''
                          : setup.paramOverrides.intensities!.map((i) => i.toString()).join(','),
                      keyboardType: TextInputType.number,
                      autovalidateMode: AutovalidateMode.always,
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                      ),
                      validator: notifier.intensitiesValidator,
                      onChanged: notifier.setIntensitiesMaybe,
                    ),
                  ),
                  const SizedBox(height: 20),
                  KVRow(
                    titleTextMedium(
                        'Sets /week/muscle: ${setup.paramSuggest.setsPerweekPerMuscleGroup.toStringAsFixed(0)}',
                        context),
                    v: TextFormField(
                      key: const ValueKey('weeklyVolume'),
                      initialValue:
                          setup.paramOverrides.setsPerWeekPerMuscleGroup?.toString() ?? '',
                      keyboardType: TextInputType.number,
                      autovalidateMode: AutovalidateMode.always,
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                      ),
                      validator: notifier.setsPerWeekPerMuscleGroupValidator,
                      onChanged: notifier.setSetsPerWeekPerMuscleGroupMaybe,
                    ),
                    help: helpSetsPerWeekPerMuscleGroup,
                    helpTitle: 'Sets per week per muscle group',
                  ),
                ]),
              ),
              Expanded(
                flex: 10,
                child: Column(children: [
                  const KStringRow('Muscle specific overrides'),
                  if (availableGroups.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    KVRow(
                      titleTextMedium('Add for: ', context),
                      v: DropdownButton<ProgramGroup>(
                        value: null,
                        isExpanded: true,
                        hint: Text('Select muscle', style: ts100(context)),
                        items: availableGroups
                            .map((group) => DropdownMenuItem(
                                  value: group,
                                  child: Text(group.displayName, style: ts100(context)),
                                ))
                            .toList(),
                        onChanged: (group) {
                          if (group != null) {
                            notifier.addMuscleGroupOverride(group);
                          }
                        },
                      ),
                    ),
                  ],
                  if (setup.paramOverrides.setsPerWeekPerMuscleGroupIndividual?.isNotEmpty ==
                      true) ...[
                    const SizedBox(height: 10),
                    const SizedBox(height: 10),
                    ...setup.paramOverrides.setsPerWeekPerMuscleGroupIndividual!.map(
                      (override) => Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: KVRow(
                                titleTextMedium(override.group.displayName, context),
                                v: TextFormField(
                                  key: ValueKey('muscle_${override.group.name}'),
                                  initialValue: override.sets.toString(),
                                  keyboardType: TextInputType.number,
                                  autovalidateMode: AutovalidateMode.always,
                                  decoration: const InputDecoration(
                                    border: UnderlineInputBorder(),
                                    isDense: true,
                                    contentPadding:
                                        EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                  ),
                                  validator: notifier.setsPerWeekPerMuscleGroupValidator,
                                  onChanged: (value) =>
                                      notifier.updateMuscleGroupOverride(override.group, value),
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () => notifier.removeMuscleGroupOverride(override.group),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ]),
              )
            ]),
          ],
        );
      },
    );
  }
}
