import 'package:bodybuild/data/programmer/exercises.dart';
import 'package:bodybuild/data/programmer/groups.dart';
import 'package:bodybuild/model/workouts/workout.dart' as model;
import 'package:bodybuild/ui/programmer/util_groups.dart';
import 'package:flutter/material.dart';

/// Displays a summary of volume performed for each muscle group (ProgramGroup) in a workout
class WorkoutVolumeSummary extends StatefulWidget {
  final model.Workout workout;

  const WorkoutVolumeSummary({super.key, required this.workout});

  @override
  State<WorkoutVolumeSummary> createState() => _WorkoutVolumeSummaryState();
}

class _WorkoutVolumeSummaryState extends State<WorkoutVolumeSummary> {
  bool _isExpanded = false;

  /// Calculate total volume for each muscle group across all sets in the workout
  Map<ProgramGroup, double> _calculateVolumes() {
    final volumes = <ProgramGroup, double>{};

    // Initialize all program groups to 0
    for (final pg in ProgramGroup.values) {
      volumes[pg] = 0.0;
    }

    // Sum up volume from all sets
    for (final set in widget.workout.sets) {
      final exercise = exes.firstWhere(
        (ex) => ex.id == set.exerciseId,
        orElse: () => throw Exception('Exercise ${set.exerciseId} not found'),
      );

      // Calculate recruitment for each muscle group with the set's tweaks
      for (final pg in ProgramGroup.values) {
        final recruitment = exercise.recruitmentFiltered(pg, set.tweaks, 0.4);
        volumes[pg] = volumes[pg]! + recruitment.volume;
      }
    }

    return volumes;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(Icons.fitness_center, size: 20, color: theme.colorScheme.primary),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Volume by Muscle Group',
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Icon(
                    _isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ],
              ),
            ),
          ),
          if (_isExpanded) ...[
            const Divider(height: 1),
            Padding(padding: const EdgeInsets.all(16), child: _buildVolumeList(context)),
          ],
        ],
      ),
    );
  }

  Widget _buildVolumeList(BuildContext context) {
    final volumes = _calculateVolumes();

    // Show all program groups in their enum order (same as programmer builder)
    // This maintains consistency with the existing UI
    final displayVolumes = ProgramGroup.values
        .map((pg) => MapEntry(pg, volumes[pg] ?? 0.0))
        .toList();

    if (displayVolumes.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: displayVolumes
          .map((entry) => _buildVolumeRow(context, entry.key, entry.value))
          .toList(),
    );
  }

  Widget _buildVolumeRow(BuildContext context, ProgramGroup pg, double volume) {
    final theme = Theme.of(context);
    final maxVolume = _calculateVolumes().values.reduce((a, b) => a > b ? a : b);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(flex: 3, child: Text(pg.displayNameLong, style: theme.textTheme.bodyMedium)),
          const SizedBox(width: 8),
          Expanded(
            flex: 5,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: maxVolume > 0 ? volume / maxVolume : 0,
                minHeight: 20,
                backgroundColor: theme.colorScheme.surfaceContainerHighest,
                valueColor: AlwaysStoppedAnimation<Color>(bgColorForProgramGroup(pg)),
              ),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 40,
            child: Text(
              volume.toStringAsFixed(1),
              style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
