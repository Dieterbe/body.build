import 'package:bodybuild/model/measurements/measurement.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MeasurementCard extends StatelessWidget {
  final Measurement measurement;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const MeasurementCard({
    super.key,
    required this.measurement,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MMM d, yyyy');
    final timeFormat = DateFormat('HH:mm');

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        '${measurement.value.toStringAsFixed(1)} ${measurement.unit.displayName}',
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        measurement.measurementType.name.toUpperCase(),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${dateFormat.format(measurement.timestamp)} at ${timeFormat.format(measurement.timestamp)}',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                  if (measurement.comment != null && measurement.comment!.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(measurement.comment!, style: const TextStyle(fontSize: 14)),
                  ],
                ],
              ),
            ),
            Column(
              children: [
                IconButton(icon: const Icon(Icons.edit), onPressed: onEdit, tooltip: 'Edit'),
                IconButton(icon: const Icon(Icons.delete), onPressed: onDelete, tooltip: 'Delete'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
