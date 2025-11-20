import 'package:bodybuild/data/dataset/ex.dart';
import 'package:bodybuild/data/dataset/program_group.dart';
import 'package:bodybuild/model/workouts/workout.dart' as model;
import 'package:bodybuild/ui/core/widget/histogram_widget.dart';
import 'package:bodybuild/ui/dataset/util_groups.dart';
import 'package:flutter/material.dart';

/// Shows a comprehensive stats bottom sheet for a workout
void showWorkoutStatsSheet(BuildContext context, model.Workout workout) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    clipBehavior: Clip.antiAlias,
    builder: (context) => DraggableScrollableSheet(
      initialChildSize: 0.8,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return _WorkoutStatsSheet(workout: workout, scrollController: scrollController);
      },
    ),
  );
}

class _WorkoutStatsSheet extends StatelessWidget {
  final model.Workout workout;
  final ScrollController scrollController;

  const _WorkoutStatsSheet({required this.workout, required this.scrollController});

  /// Calculate total volume for each muscle group
  Map<ProgramGroup, double> _calculateVolumes() {
    final volumes = <ProgramGroup, double>{};

    // Initialize all program groups to 0
    for (final pg in ProgramGroup.values) {
      volumes[pg] = 0.0;
    }

    // Sum up volume from all sets
    for (final set in workout.sets) {
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

  /// Calculate histogram of sets per number of involved muscle groups
  Map<int, int> _calculateSetsHistogram() {
    final histogram = <int, int>{};

    for (final set in workout.sets) {
      final exercise = exes.firstWhere(
        (ex) => ex.id == set.exerciseId,
        orElse: () => throw Exception('Exercise ${set.exerciseId} not found'),
      );

      // Get unique isolation keys with significant recruitment
      final involvedGroups = ProgramGroup.values
          .where((pg) => exercise.recruitmentFiltered(pg, set.tweaks, 0.5).volume > 0)
          .map((pg) => pg.isolationKey)
          .toSet();

      // Handle forearm special case (see involvedMuscleGroups in set_group.dart)
      int count;
      if (involvedGroups.length == 1 && involvedGroups.firstOrNull! == 'forearm') {
        count = 1;
      } else if (involvedGroups.contains('forearm')) {
        count = involvedGroups.length - 1;
      } else {
        count = involvedGroups.length;
      }

      histogram[count] = (histogram[count] ?? 0) + 1;
    }

    return histogram;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        // Header
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            border: Border(bottom: BorderSide(color: theme.dividerColor, width: 1)),
          ),
          child: Row(
            children: [
              Icon(Icons.analytics, color: theme.colorScheme.primary),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Workout Statistics',
                  style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
            ],
          ),
        ),
        // Content
        Expanded(
          child: ListView(
            controller: scrollController,
            padding: const EdgeInsets.all(16),
            children: [
              _buildOverviewSection(context),
              const SizedBox(height: 24),
              _buildHistogramSection(context),
              const SizedBox(height: 24),
              _buildVolumeSection(context),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOverviewSection(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      spacing: 12,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Overview', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
        Row(
          spacing: 12,
          children: [
            Expanded(
              child: _buildStatCard(
                context,
                icon: Icons.fitness_center,
                label: 'Total Sets',
                value: '${workout.sets.length}',
              ),
            ),
            Expanded(
              child: _buildStatCard(
                context,
                icon: Icons.list,
                label: 'Exercises',
                value: '${workout.exerciseIds.length}',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: theme.colorScheme.primary, size: 32),
          const SizedBox(height: 8),
          Text(value, style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }

  Widget _buildHistogramSection(BuildContext context) {
    final theme = Theme.of(context);
    final histogram = _calculateSetsHistogram();

    if (histogram.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Sets per Muscle Groups',
          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          'Shows how many sets target 1 muscle group (isolations), 2, 3, etc (compounds)',
          style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
        ),
        const SizedBox(height: 12),
        HistogramWidget(data: histogram),
      ],
    );
  }

  Widget _buildVolumeSection(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Volume by Muscle Group',
          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        _buildVolumeList(context),
      ],
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
    final volumes = _calculateVolumes();
    final maxVolume = volumes.values.reduce((a, b) => a > b ? a : b);

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
