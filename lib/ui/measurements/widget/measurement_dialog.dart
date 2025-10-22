import 'package:bodybuild/model/measurements/measurement.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class MeasurementDialog extends StatefulWidget {
  final Measurement? measurement;
  final Unit defaultUnit;

  const MeasurementDialog({super.key, this.measurement, required this.defaultUnit});

  @override
  State<MeasurementDialog> createState() => _MeasurementDialogState();
}

class _MeasurementDialogState extends State<MeasurementDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _valueController;
  late TextEditingController _commentController;
  late DateTime _selectedDateTime;
  late Unit _selectedUnit;
  late MeasurementType _selectedType;

  @override
  void initState() {
    super.initState();
    _valueController = TextEditingController(
      text: widget.measurement?.value.toStringAsFixed(1) ?? '',
    );
    _commentController = TextEditingController(text: widget.measurement?.comment ?? '');
    _selectedDateTime = widget.measurement?.timestamp ?? DateTime.now();
    _selectedUnit = widget.measurement?.unit ?? widget.defaultUnit;
    _selectedType = widget.measurement?.measurementType ?? MeasurementType.weight;
  }

  @override
  void dispose() {
    _valueController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (date != null && context.mounted) {
      setState(() {
        _selectedDateTime = DateTime(
          date.year,
          date.month,
          date.day,
          _selectedDateTime.hour,
          _selectedDateTime.minute,
        );
      });
    }
  }

  Future<void> _selectTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_selectedDateTime),
    );

    if (time != null && context.mounted) {
      setState(() {
        _selectedDateTime = DateTime(
          _selectedDateTime.year,
          _selectedDateTime.month,
          _selectedDateTime.day,
          time.hour,
          time.minute,
        );
      });
    }
  }

  void _save() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final value = double.parse(_valueController.text);
    final result = {
      'value': value,
      'unit': _selectedUnit,
      'type': _selectedType,
      'timestamp': _selectedDateTime,
      'comment': _commentController.text.trim().isEmpty ? null : _commentController.text.trim(),
    };

    Navigator.of(context).pop(result);
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MMM d, yyyy');
    final timeFormat = DateFormat('HH:mm');

    return AlertDialog(
      title: Text(widget.measurement == null ? 'Add Measurement' : 'Edit Measurement'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Measurement Type
              DropdownButtonFormField<MeasurementType>(
                value: _selectedType,
                decoration: const InputDecoration(labelText: 'Type', border: OutlineInputBorder()),
                items: MeasurementType.values.map((type) {
                  return DropdownMenuItem(value: type, child: Text(type.name.toUpperCase()));
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedType = value;
                    });
                  }
                },
              ),
              const SizedBox(height: 16),

              // Value and Unit
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      controller: _valueController,
                      decoration: const InputDecoration(
                        labelText: 'Value',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                      ],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Required';
                        }
                        final numValue = double.tryParse(value);
                        if (numValue == null) {
                          return 'Invalid number';
                        }
                        if (numValue <= 0) {
                          return 'Must be > 0';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: DropdownButtonFormField<Unit>(
                      value: _selectedUnit,
                      decoration: const InputDecoration(
                        labelText: 'Unit',
                        border: OutlineInputBorder(),
                      ),
                      items: Unit.values.map((unit) {
                        return DropdownMenuItem(value: unit, child: Text(unit.displayName));
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _selectedUnit = value;
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Date and Time
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _selectDate,
                      icon: const Icon(Icons.calendar_today),
                      label: Text(dateFormat.format(_selectedDateTime)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _selectTime,
                      icon: const Icon(Icons.access_time),
                      label: Text(timeFormat.format(_selectedDateTime)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Comment
              TextFormField(
                controller: _commentController,
                decoration: const InputDecoration(
                  labelText: 'Comment (optional)',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
        FilledButton(onPressed: _save, child: const Text('Save')),
      ],
    );
  }
}
