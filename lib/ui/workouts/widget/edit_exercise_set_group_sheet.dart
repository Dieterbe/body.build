import 'package:bodybuild/ui/core/widget/configure_tweak_small.dart';
import 'package:bodybuild/ui/core/widget/configure_tweak_large.dart';
import 'package:bodybuild/ui/core/widget/exercise_recruitment_visualization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bodybuild/model/programmer/set_group.dart';
import 'package:bodybuild/data/dataset/exercises.dart';
import 'package:bodybuild/data/programmer/setup.dart';
import 'package:bodybuild/ui/core/widget/rating_icon_multi.dart';
import 'package:bodybuild/util/string_extension.dart';
import 'package:bodybuild/ui/workouts/widget/exercise_picker_sheet.dart';
import 'package:bodybuild/model/programmer/settings.dart';
import 'package:bodybuild/data/dataset/tweak.dart';
import 'package:bodybuild/model/workouts/workout.dart' as model;
import 'package:collection/collection.dart';

/// Sheet for editing exercise, tweaks, and individual sets for a group
/// Step 1/2 very similar to [LogSetSheet], 3rd step is different
class EditExerciseSetGroupSheet extends ConsumerStatefulWidget {
  final model.ExerciseSetGroup group;

  const EditExerciseSetGroupSheet({super.key, required this.group});

  @override
  ConsumerState<EditExerciseSetGroupSheet> createState() => _EditExerciseSheetState();
}

class _EditExerciseSheetState extends ConsumerState<EditExerciseSetGroupSheet> {
  Sets? currentSets;
  int currentStep = 0; // 0: Select Exercise, 1: Configure, 2: Edit Sets
  bool showDetailedTweaks = false;
  late List<model.WorkoutSet> editableSets;
  final Set<String> deletedSetIds = {};

  @override
  void initState() {
    super.initState();
    final exercise = exes.firstWhereOrNull((e) => e.id == widget.group.exerciseId);
    currentSets = Sets(0, ex: exercise, tweakOptions: widget.group.tweaks); // TODO do we need this?
    editableSets = List.of(widget.group.sets);
    // This seems the most common use case
    currentStep = 2;
  }

  @override
  Widget build(BuildContext context) {
    final settingsAsync = ref.watch(setupProvider);

    return settingsAsync.when(
      data: (settings) => _buildContent(context, settings),
      loading: () => const SizedBox(height: 400, child: Center(child: CircularProgressIndicator())),
      error: (error, stack) => SizedBox(height: 400, child: Center(child: Text('Error: $error'))),
    );
  }

  Widget _buildContent(BuildContext context, Settings settings) {
    return Container(
      height: MediaQuery.sizeOf(context).height * 0.85,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Row(
            children: [
              Expanded(
                child: Text(
                  'Edit Exercise Sets',
                  style: Theme.of(
                    context,
                  ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Step indicator
          _buildStepIndicator(context),
          const SizedBox(height: 24),

          // Step content
          Expanded(child: _buildStepContent(context, settings)),

          // Navigation buttons
          const SizedBox(height: 16),
          _buildNavigationButtons(),
          SizedBox(height: MediaQuery.paddingOf(context).bottom),
        ],
      ),
    );
  }

  Widget _buildStepIndicator(BuildContext context) {
    return Row(
      children: [
        _buildStepDot(context, 0, 'Exercise'),
        Expanded(
          child: Divider(color: currentStep > 0 ? Theme.of(context).colorScheme.primary : null),
        ),
        _buildStepDot(context, 1, 'Configure'),
        Expanded(
          child: Divider(color: currentStep > 1 ? Theme.of(context).colorScheme.primary : null),
        ),
        _buildStepDot(context, 2, 'Edit Sets'),
      ],
    );
  }

  Widget _buildStepDot(BuildContext context, int step, String label) {
    final isActive = currentStep == step;
    final isCompleted = currentStep > step;
    final canNavigate = step <= currentStep || (step == 1 && currentSets?.ex != null);

    return InkWell(
      onTap: canNavigate ? () => setState(() => currentStep = step) : null,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Column(
          spacing: 4,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isActive || isCompleted
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.surfaceContainerHighest,
                border: Border.all(
                  color: isActive
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).dividerColor,
                  width: 2,
                ),
              ),
              child: Center(
                child: isCompleted
                    ? Icon(Icons.check, color: Theme.of(context).colorScheme.onPrimary, size: 20)
                    : Text(
                        '${step + 1}',
                        style: TextStyle(
                          color: isActive
                              ? Theme.of(context).colorScheme.onPrimary
                              : Theme.of(context).textTheme.bodyMedium?.color,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                color: isActive ? Theme.of(context).colorScheme.primary : null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepContent(BuildContext context, Settings settings) {
    return switch (currentStep) {
      0 => _buildStepExercisePicker(),
      1 => _buildStepConfigure(context, settings),
      2 => _buildStepEditSets(),
      _ => const SizedBox.shrink(),
    };
  }

  Widget _buildNavigationButtons() {
    return Row(
      children: [
        if (currentStep > 0)
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () => setState(() => currentStep--),
              icon: const Icon(Icons.arrow_back),
              label: const Text('Back'),
            ),
          ),
        if (currentStep > 0) const SizedBox(width: 12),
        Expanded(
          flex: 2,
          child: ElevatedButton.icon(
            onPressed: _getNextButtonAction(),
            icon: Icon(currentStep == 2 ? Icons.save : Icons.arrow_forward),
            label: Text(currentStep == 2 ? 'Save Changes' : 'Next'),
          ),
        ),
      ],
    );
  }

  VoidCallback? _getNextButtonAction() {
    return switch (currentStep) {
      0 => currentSets?.ex != null ? () => setState(() => currentStep = 1) : null,
      1 => () => setState(() => currentStep = 2),
      2 => _saveChanges,
      _ => null,
    };
  }

  Widget _buildStepExercisePicker() {
    return Column(
      children: [
        // Show currently selected exercise if any
        if (currentSets?.ex != null)
          Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              spacing: 12,
              children: [
                Icon(Icons.check_circle, color: Theme.of(context).colorScheme.onPrimaryContainer),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Currently selected:',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                      ),
                      Text(
                        currentSets!.ex!.id,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        Expanded(
          child: ExercisePickerSheet(
            onExerciseSelected: (exerciseId) {
              final exercise = exes.firstWhereOrNull((e) => e.id == exerciseId);
              if (exercise == null) return;
              if (mounted) {
                setState(() {
                  currentSets = Sets(0, ex: exercise, tweakOptions: {});
                  currentStep = 1;
                });
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildStepConfigure(BuildContext context, Settings settings) {
    if (currentSets?.ex == null) {
      return const Center(child: Text('No exercise selected'));
    }
    final applicableRatings = currentSets!.getApplicableRatings().toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Exercise name header
        Row(
          children: [
            Expanded(
              child: Text(
                currentSets!.ex!.id,
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            if (applicableRatings.isNotEmpty) RatingIconMulti(ratings: applicableRatings),
            const SizedBox(width: 8),
            if (currentSets!.ex!.tweaks.isNotEmpty)
              FilledButton.tonalIcon(
                onPressed: () => setState(() => showDetailedTweaks = !showDetailedTweaks),
                icon: Icon(showDetailedTweaks ? Icons.unfold_less : Icons.unfold_more),
                label: Text(showDetailedTweaks ? 'Less' : 'More'),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  visualDensity: VisualDensity.compact,
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Divider(color: Theme.of(context).colorScheme.outlineVariant),
                const SizedBox(height: 16),
                if (currentSets!.ex!.tweaks.isEmpty)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        children: [
                          Icon(
                            Icons.check_circle_outline,
                            size: 64,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No configuration needed',
                            style: Theme.of(
                              context,
                            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'This exercise has no tweaks to configure.\nTap Save to apply changes.',
                            style: Theme.of(context).textTheme.bodyMedium,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  ...currentSets!.ex!.tweaks.map((tweak) => _buildTweakSection(context, tweak)),
                Divider(color: Theme.of(context).colorScheme.outlineVariant),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
        ExerciseRecruitmentVisualization(
          exercise: currentSets!.ex!,
          tweakOptions: currentSets!.tweakOptions,
          setup: settings,
          cutoff: 0.4,
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildTweakSection(BuildContext context, Tweak tweak) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        spacing: 12,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            tweak.name.capitalizeFirstOnlyButKeepAcronym(),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          if (showDetailedTweaks)
            ConfigureTweakLarge(
              tweak,
              currentSets!,
              availableEquipment: null, // No equipment filtering in workout context
              onChange: (val) {
                setState(() {
                  currentSets = currentSets!.copyWith(
                    tweakOptions: {...currentSets!.tweakOptions, tweak.name: val},
                  );
                });
              },
            )
          else
            ConfigureTweakSmall(
              tweak,
              currentSets!,
              availableEquipment: null, // No equipment filtering in workout context
              onChange: (val) {
                setState(() {
                  currentSets = currentSets!.copyWith(
                    tweakOptions: {...currentSets!.tweakOptions, tweak.name: val},
                  );
                });
              },
            ),
        ],
      ),
    );
  }

  Widget _buildStepEditSets() {
    return ListView.builder(
      itemCount: editableSets.length,
      itemBuilder: (context, index) {
        final set = editableSets[index];
        return Card(
          key: ValueKey(set.id),
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Set ${index + 1}',
                        style: Theme.of(
                          context,
                        ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          deletedSetIds.add(set.id);
                          editableSets.removeAt(index);
                        });
                      },
                      icon: const Icon(Icons.delete_outline),
                      tooltip: 'Remove set',
                      iconSize: 20,
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        initialValue: set.weight?.toString() ?? '',
                        decoration: const InputDecoration(
                          labelText: 'Weight (kg)',
                          border: OutlineInputBorder(),
                          isDense: true,
                        ),
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))],
                        onChanged: (value) {
                          final weight = double.tryParse(value);
                          editableSets[index] = editableSets[index].copyWith(weight: weight);
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextFormField(
                        initialValue: set.reps?.toString() ?? '',
                        decoration: const InputDecoration(
                          labelText: 'Reps',
                          border: OutlineInputBorder(),
                          isDense: true,
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        onChanged: (value) {
                          final reps = int.tryParse(value);
                          editableSets[index] = editableSets[index].copyWith(reps: reps);
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextFormField(
                        initialValue: set.rir?.toString() ?? '',
                        decoration: const InputDecoration(
                          labelText: 'RIR',
                          border: OutlineInputBorder(),
                          isDense: true,
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        onChanged: (value) {
                          final rir = int.tryParse(value);
                          editableSets[index] = editableSets[index].copyWith(rir: rir);
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                TextFormField(
                  initialValue: set.comments ?? '',
                  decoration: const InputDecoration(
                    labelText: 'Comments (optional)',
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                  maxLines: 2,
                  onChanged: (value) {
                    editableSets[index] = editableSets[index].copyWith(
                      comments: value.isEmpty ? null : value,
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _saveChanges() {
    // Ensure all tweaks have explicit values (including defaults)
    final explicitTweakOptions = <String, String>{};
    if (currentSets?.ex != null) {
      for (final tweak in currentSets!.ex!.tweaks) {
        explicitTweakOptions[tweak.name] =
            currentSets!.tweakOptions[tweak.name] ?? tweak.defaultVal;
      }
    }

    final setsWithExplicitTweaks = currentSets!.copyWith(tweakOptions: explicitTweakOptions);

    // Update all sets with new exercise and tweaks
    final updatedSets = editableSets.map((set) {
      return set.copyWith(exerciseId: setsWithExplicitTweaks.ex!.id, tweaks: explicitTweakOptions);
    }).toList();

    Navigator.of(context).pop({
      'sets': setsWithExplicitTweaks,
      'updatedSets': updatedSets,
      'deletedSetIds': deletedSetIds.toList(),
    });
  }
}
