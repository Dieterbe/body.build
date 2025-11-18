import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bodybuild/model/workouts/workout.dart' as model;

/// Inline form widget for editing a single set's weight, reps, RIR, and comments
class SetFormWidget extends StatefulWidget {
  final model.WorkoutSet workoutSet;
  final int setNumber;
  final ValueChanged<model.WorkoutSet> onChanged;
  final VoidCallback? onDelete;
  final GlobalKey<FormState>? formKey;

  const SetFormWidget({
    super.key,
    required this.workoutSet,
    required this.setNumber,
    required this.onChanged,
    this.onDelete,
    this.formKey,
  });

  @override
  State<SetFormWidget> createState() => _SetFormWidgetState();
}

class _SetFormWidgetState extends State<SetFormWidget> {
  late TextEditingController _weightController;
  late TextEditingController _repsController;
  late TextEditingController _rirController;
  late TextEditingController _commentsController;
  late bool _completed;
  late final GlobalKey<FormState> _internalFormKey;

  @override
  void initState() {
    super.initState();
    _weightController = TextEditingController(text: widget.workoutSet.weight?.toString() ?? '');
    _repsController = TextEditingController(text: widget.workoutSet.reps?.toString() ?? '');
    _rirController = TextEditingController(text: widget.workoutSet.rir?.toString() ?? '');
    _commentsController = TextEditingController(text: widget.workoutSet.comments ?? '');
    _completed = widget.workoutSet.completed;
    _internalFormKey = GlobalKey<FormState>();
  }

  @override
  void didUpdateWidget(covariant SetFormWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.workoutSet != widget.workoutSet) {
      // Only update weight field if the numeric value actually changed
      final currentWeight = double.tryParse(_weightController.text);
      if (currentWeight != widget.workoutSet.weight) {
        _weightController.text = widget.workoutSet.weight?.toString() ?? '';
      }

      if (_repsController.text != (widget.workoutSet.reps?.toString() ?? '')) {
        _repsController.text = widget.workoutSet.reps?.toString() ?? '';
      }
      if (_rirController.text != (widget.workoutSet.rir?.toString() ?? '')) {
        _rirController.text = widget.workoutSet.rir?.toString() ?? '';
      }
      if (_commentsController.text != (widget.workoutSet.comments ?? '')) {
        _commentsController.text = widget.workoutSet.comments ?? '';
      }
      _completed = widget.workoutSet.completed;
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

  // TODO what if these don't validate
  void _notifyChange() {
    final weightText = _weightController.text;
    final weightValue = weightText.isEmpty ? null : double.tryParse(weightText);

    // Allow intermediate input states like "12." without resetting the field
    if (weightText.isNotEmpty && weightValue == null) {
      _effectiveFormKey.currentState?.validate();
      return;
    }

    final updatedSet = widget.workoutSet.copyWith(
      weight: weightValue,
      reps: _repsController.text.isEmpty ? null : int.tryParse(_repsController.text),
      rir: _rirController.text.isEmpty ? null : int.tryParse(_rirController.text),
      comments: _commentsController.text.isEmpty ? null : _commentsController.text,
      completed: _completed,
    );
    if (updatedSet != widget.workoutSet) {
      widget.onChanged(updatedSet);
    }
    _effectiveFormKey.currentState?.validate();
  }

  void _onCompletedChanged(bool? value) {
    setState(() {
      _completed = value ?? false;
    });
    _notifyChange();
  }

  String? _validateWeight(String? value) {
    if (!_completed && (value == null || value.trim().isEmpty)) {
      return null;
    }
    if (value == null || value.trim().isEmpty) {
      return 'Weight is required';
    }
    final weight = double.tryParse(value);
    if (weight == null || weight <= 0) {
      return 'Enter weight > 0';
    }
    return null;
  }

  String? _validateReps(String? value) {
    if (!_completed && (value == null || value.trim().isEmpty)) {
      return null;
    }
    if (value == null || value.trim().isEmpty) {
      return 'Reps are required';
    }
    final reps = int.tryParse(value);
    if (reps == null || reps <= 0) {
      return 'Enter reps > 0';
    }
    return null;
  }

  String? _validateRir(String? value) {
    if (!_completed && (value == null || value.trim().isEmpty)) {
      return null;
    }
    if (value == null || value.trim().isEmpty) {
      return 'RIR is required';
    }
    final rir = int.tryParse(value);
    if (rir == null || rir < 0 || rir > 10) {
      return 'RIR must be 0-10';
    }
    return null;
  }

  GlobalKey<FormState> get _effectiveFormKey => widget.formKey ?? _internalFormKey;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Form(
      key: _effectiveFormKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Card(
        key: ValueKey(widget.workoutSet.id),
        margin: const EdgeInsets.only(bottom: 12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Checkbox(
                    value: _completed,
                    onChanged: _onCompletedChanged,
                    visualDensity: VisualDensity.compact,
                  ),
                  Text(
                    'Set ${widget.setNumber}${_completed ? '' : ' (planned)'}',
                    style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  if (widget.onDelete != null)
                    IconButton(
                      icon: const Icon(Icons.delete_outline, size: 20),
                      onPressed: widget.onDelete,
                      tooltip: 'Delete set',
                      visualDensity: VisualDensity.compact,
                    ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _weightController,
                      decoration: const InputDecoration(
                        labelText: 'Weight (kg)',
                        border: OutlineInputBorder(),
                        isDense: true,
                        prefixIcon: Icon(Icons.fitness_center, size: 18),
                      ),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))],
                      validator: _validateWeight,
                      onChanged: (_) => _notifyChange(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      controller: _repsController,
                      decoration: const InputDecoration(
                        labelText: 'Reps',
                        border: OutlineInputBorder(),
                        isDense: true,
                        prefixIcon: Icon(Icons.repeat, size: 18),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      validator: _validateReps,
                      onChanged: (_) => _notifyChange(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      controller: _rirController,
                      decoration: const InputDecoration(
                        labelText: 'RIR',
                        border: OutlineInputBorder(),
                        isDense: true,
                        prefixIcon: Icon(Icons.battery_charging_full, size: 18),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      validator: _validateRir,
                      onChanged: (_) => _notifyChange(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _commentsController,
                decoration: const InputDecoration(
                  labelText: 'Comments (optional)',
                  border: OutlineInputBorder(),
                  isDense: true,
                  prefixIcon: Icon(Icons.note, size: 18),
                ),
                maxLines: 1,
                onChanged: (_) => _notifyChange(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
