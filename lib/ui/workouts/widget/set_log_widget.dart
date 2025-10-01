import 'package:bodybuild/ui/core/confirmation_dialog.dart';
import 'package:bodybuild/ui/datetime.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bodybuild/model/workouts/workout.dart' as model;

class SetLogWidget extends StatefulWidget {
  final model.WorkoutSet workoutSet;
  final Function(model.WorkoutSet) onUpdate;
  final VoidCallback onDelete;

  const SetLogWidget({
    super.key,
    required this.workoutSet,
    required this.onUpdate,
    required this.onDelete,
  });

  @override
  State<SetLogWidget> createState() => _SetLogWidgetState();
}

class _SetLogWidgetState extends State<SetLogWidget> {
  late TextEditingController _weightController;
  late TextEditingController _repsController;
  late TextEditingController _rirController;
  late TextEditingController _commentsController;

  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _weightController = TextEditingController(text: widget.workoutSet.weight?.toString() ?? '');
    _repsController = TextEditingController(text: widget.workoutSet.reps?.toString() ?? '');
    _rirController = TextEditingController(text: widget.workoutSet.rir?.toString() ?? '');
    _commentsController = TextEditingController(text: widget.workoutSet.comments ?? '');
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
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Set header
          Row(
            children: [
              Text(
                'Set ${widget.workoutSet.setOrder}',
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              Text(
                formatHumanTimeMinutely(widget.workoutSet.timestamp),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
              const SizedBox(width: 8),
              if (_isEditing) ...[
                IconButton(
                  onPressed: _saveChanges,
                  icon: const Icon(Icons.check, color: Colors.green),
                  iconSize: 20,
                ),
                IconButton(
                  onPressed: _cancelEditing,
                  icon: const Icon(Icons.close, color: Colors.red),
                  iconSize: 20,
                ),
              ] else ...[
                IconButton(
                  onPressed: () => setState(() => _isEditing = true),
                  icon: const Icon(Icons.edit),
                  iconSize: 20,
                ),
                IconButton(
                  onPressed: _showDeleteConfirmation,
                  icon: const Icon(Icons.delete, color: Colors.red),
                  iconSize: 20,
                ),
              ],
            ],
          ),
          const SizedBox(height: 12),

          // Set data input/display
          if (_isEditing) _buildEditingInterface() else _buildDisplayInterface(),

          // Comments section
          if (widget.workoutSet.comments?.isNotEmpty == true || _isEditing) ...[
            const SizedBox(height: 8),
            if (_isEditing)
              TextField(
                controller: _commentsController,
                decoration: const InputDecoration(
                  labelText: 'Comments',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
                maxLines: 2,
              )
            else if (widget.workoutSet.comments?.isNotEmpty == true)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  widget.workoutSet.comments!,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(fontStyle: FontStyle.italic),
                ),
              ),
          ],
        ],
      ),
    );
  }

  Widget _buildEditingInterface() {
    return Row(
      children: [
        // Weight input
        Expanded(
          child: TextField(
            controller: _weightController,
            decoration: const InputDecoration(
              labelText: 'Weight (kg)',
              border: OutlineInputBorder(),
              isDense: true,
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))],
          ),
        ),
        const SizedBox(width: 8),

        // Reps input
        Expanded(
          child: TextField(
            controller: _repsController,
            decoration: const InputDecoration(
              labelText: 'Reps',
              border: OutlineInputBorder(),
              isDense: true,
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          ),
        ),
        const SizedBox(width: 8),

        // RIR input
        Expanded(
          child: TextField(
            controller: _rirController,
            decoration: const InputDecoration(
              labelText: 'RIR',
              border: OutlineInputBorder(),
              isDense: true,
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          ),
        ),
      ],
    );
  }

  Widget _buildDisplayInterface() {
    return Row(
      children: [
        // Weight display
        Expanded(
          child: _buildDataChip(
            label: 'Weight',
            value: widget.workoutSet.weight != null
                ? '${widget.workoutSet.weight!.toStringAsFixed(1)} kg'
                : '-',
            icon: Icons.fitness_center,
          ),
        ),
        const SizedBox(width: 8),

        // Reps display
        Expanded(
          child: _buildDataChip(
            label: 'Reps',
            value: widget.workoutSet.reps?.toString() ?? '-',
            icon: Icons.repeat,
          ),
        ),
        const SizedBox(width: 8),

        // RIR display
        Expanded(
          child: _buildDataChip(
            label: 'RIR',
            value: widget.workoutSet.rir?.toString() ?? '-',
            icon: Icons.battery_3_bar,
          ),
        ),
      ],
    );
  }

  Widget _buildDataChip({required String label, required String value, required IconData icon}) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 16,
            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  void _saveChanges() {
    final weight = double.tryParse(_weightController.text);
    final reps = int.tryParse(_repsController.text);
    final rir = int.tryParse(_rirController.text);
    final comments = _commentsController.text.trim();

    final updatedSet = widget.workoutSet.copyWith(
      weight: weight,
      reps: reps,
      rir: rir,
      comments: comments.isEmpty ? null : comments,
    );

    widget.onUpdate(updatedSet);
    setState(() => _isEditing = false);
  }

  void _cancelEditing() {
    // Reset controllers to original values
    _weightController.text = widget.workoutSet.weight?.toString() ?? '';
    _repsController.text = widget.workoutSet.reps?.toString() ?? '';
    _rirController.text = widget.workoutSet.rir?.toString() ?? '';
    _commentsController.text = widget.workoutSet.comments ?? '';

    setState(() => _isEditing = false);
  }

  void _showDeleteConfirmation() {
    showConfirmationDialog(
      context: context,
      title: 'Delete Set',
      content: 'Are you sure you want to delete Set ${widget.workoutSet.setOrder}?',
      confirmText: 'Delete',
      isDestructive: true,
      onConfirm: widget.onDelete,
    );
  }
}
