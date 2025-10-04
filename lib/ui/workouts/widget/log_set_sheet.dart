import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bodybuild/model/programmer/set_group.dart';
import 'package:bodybuild/data/programmer/exercises.dart';
import 'package:bodybuild/data/programmer/setup.dart';
import 'package:bodybuild/ui/programmer/widget/rating_icon_multi.dart';
import 'package:bodybuild/util/string_extension.dart';
import 'package:bodybuild/ui/workouts/widget/exercise_picker_sheet.dart';
import 'package:bodybuild/model/programmer/settings.dart';
import 'package:bodybuild/data/programmer/tweak.dart';
import 'package:collection/collection.dart';

// a modal sheet with a stepper to choose exercise, tweak it, and log a set for it
class LogSetSheet extends ConsumerStatefulWidget {
  final Sets? initialSets;

  const LogSetSheet({super.key, this.initialSets});

  @override
  ConsumerState<LogSetSheet> createState() => _LogSetSheetState();
}

class _LogSetSheetState extends ConsumerState<LogSetSheet> {
  final _formKey = GlobalKey<FormState>();
  final _weightController = TextEditingController();
  final _repsController = TextEditingController();
  final _rirController = TextEditingController();
  final _commentsController = TextEditingController();

  Sets? currentSets;
  int currentStep = 0; // 0: Select Exercise, 1: Configure, 2: Log Set

  @override
  void initState() {
    super.initState();
    currentSets = widget.initialSets;
    // If exercise already provided, start straight at logging a new set
    if (currentSets?.ex != null) {
      currentStep = 2;
    }
  }

  @override
  void dispose() {
    _weightController.dispose();
    _repsController.dispose();
    _rirController.dispose();
    _commentsController.dispose();
    super.dispose();
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
                  'Log Set',
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
        _buildStepDot(context, 2, 'Log Set'),
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
      2 => _buildStepLogSet(),
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
            label: Text(currentStep == 2 ? 'Save Set' : 'Next'),
          ),
        ),
      ],
    );
  }

  VoidCallback? _getNextButtonAction() {
    return switch (currentStep) {
      0 => currentSets?.ex != null ? () => setState(() => currentStep = 1) : null,
      1 => () => setState(() => currentStep = 2),
      2 => _saveSet,
      _ => null,
    };
  }

  // Step 1: Exercise selection
  Widget _buildStepExercisePicker() {
    return ExercisePickerSheet(
      onExerciseSelected: (exerciseId) {
        final exercise = exes.firstWhereOrNull((e) => e.id == exerciseId);
        if (exercise == null) return;
        if (mounted) {
          setState(() {
            currentSets = Sets(0, ex: exercise, tweakOptions: {});
            currentStep = 1; // Auto-advance to configure step
          });
        }
      },
    );
  }

  // Step 2: Configure exercise
  Widget _buildStepConfigure(BuildContext context, Settings settings) {
    if (currentSets?.ex == null) {
      return const Center(child: Text('No exercise selected'));
    }
    final applicableRatings = currentSets!.getApplicableRatings().toList();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Exercise name card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
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
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Tweaks configuration or "no config needed" message
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
                      'This exercise has no tweaks to configure.\nTap Next to continue.',
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            )
          else
            ...currentSets!.ex!.tweaks.map((tweak) => _buildTweakSection(context, tweak)),
        ],
      ),
    );
  }

  Widget _buildTweakSection(BuildContext context, Tweak tweak) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              tweak.name.capitalizeFirstOnlyButKeepAcronym(),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: (tweak.opts.entries.toList()..sort((a, b) => a.key.compareTo(b.key))).map((
                opt,
              ) {
                final isSelected =
                    (currentSets!.tweakOptions[tweak.name] ?? tweak.defaultVal) == opt.key;
                return ChoiceChip(
                  label: Text(opt.key),
                  selected: isSelected,
                  onSelected: (selected) {
                    if (selected) {
                      setState(() {
                        currentSets = currentSets!.copyWith(
                          tweakOptions: {...currentSets!.tweakOptions, tweak.name: opt.key},
                        );
                      });
                    }
                  },
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  // Step 3: Log set details
  Widget _buildStepLogSet() {
    if (currentSets?.ex == null) {
      return const Center(child: Text('No exercise selected'));
    }

    return Form(
      key: _formKey,
      child: SingleChildScrollView(child: _buildSetForm()),
    );
  }

  Widget _buildSetForm() {
    return Column(
      spacing: 16,
      children: [
        TextFormField(
          controller: _weightController,
          decoration: const InputDecoration(
            labelText: 'Weight (kg)',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.fitness_center),
          ),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))],
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Weight is required';
            }
            final weight = double.tryParse(value);
            if (weight == null || weight <= 0) {
              return 'Please enter a valid weight';
            }
            return null;
          },
        ),
        TextFormField(
          controller: _repsController,
          decoration: const InputDecoration(
            labelText: 'Reps',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.repeat),
          ),
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Reps is required';
            }
            final reps = int.tryParse(value);
            if (reps == null || reps <= 0) {
              return 'Please enter a valid number of reps';
            }
            return null;
          },
        ),
        TextFormField(
          controller: _rirController,
          decoration: const InputDecoration(
            labelText: 'RIR (Reps in Reserve)',
            helperText: 'How many more reps you could have done',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.battery_charging_full),
          ),
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'RIR is required';
            }
            final rir = int.tryParse(value);
            if (rir == null || rir < 0 || rir > 10) {
              return 'Please enter a valid RIR (0-10)';
            }
            return null;
          },
        ),
        TextFormField(
          controller: _commentsController,
          decoration: const InputDecoration(
            labelText: 'Comments (optional)',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.note),
          ),
          maxLines: 2,
        ),
      ],
    );
  }

  void _saveSet() {
    if (_formKey.currentState!.validate()) {
      final weight = double.parse(_weightController.text);
      final reps = int.parse(_repsController.text);
      final rir = int.parse(_rirController.text);
      final comments = _commentsController.text.trim();

      Navigator.of(context).pop({
        'sets': currentSets,
        'weight': weight,
        'reps': reps,
        'rir': rir,
        'comments': comments.isEmpty ? null : comments,
      });
    }
  }
}
