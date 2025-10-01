import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bodybuild/data/programmer/exercises.dart';
import 'package:bodybuild/data/programmer/groups.dart';
import 'package:bodybuild/data/programmer/setup.dart';
import 'package:bodybuild/model/programmer/settings.dart';
import 'package:bodybuild/ui/programmer/widget/rating_icon.dart';
import 'package:bodybuild/ui/programmer/util_groups.dart';

class ExercisePickerSheet extends ConsumerStatefulWidget {
  final Function(String exerciseId) onExerciseSelected;

  const ExercisePickerSheet({super.key, required this.onExerciseSelected});

  @override
  ConsumerState<ExercisePickerSheet> createState() => _ExercisePickerSheetState();
}

class _ExercisePickerSheetState extends ConsumerState<ExercisePickerSheet> {
  final TextEditingController _searchController = TextEditingController();
  ProgramGroup? _selectedMuscleGroup;
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(setupProvider);

    return settings.when(
      data: (setup) => _buildContent(setup),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error loading exercises: $error')),
    );
  }

  Widget _buildContent(Settings setup) {
    final availableExercises = getAvailableExercises(
      excludedExercises: setup.paramOverrides.excludedExercises,
      availEquipment: setup.availEquipment,
    );
    final filteredExercises = _filterExercises(availableExercises);

    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Expanded(
                child: Text(
                  'Select Exercise',
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

          // Search bar
          TextField(
            controller: _searchController,
            decoration: const InputDecoration(
              hintText: 'Search exercises...',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              setState(() {
                _searchQuery = value.toLowerCase();
              });
            },
          ),
          const SizedBox(height: 16),

          // Muscle group filter (single-select dropdown)
          InputDecorator(
            decoration: const InputDecoration(
              labelText: 'Filter by muscle group',
              border: OutlineInputBorder(),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<ProgramGroup>(
                value: _selectedMuscleGroup,
                isExpanded: true,
                items: [
                  const DropdownMenuItem<ProgramGroup>(
                    value: null,
                    child: Text('All muscle groups'),
                  ),
                  ...ProgramGroup.values.map((group) {
                    return DropdownMenuItem(value: group, child: Text(group.displayNameShort));
                  }),
                ],
                onChanged: (group) {
                  setState(() {
                    _selectedMuscleGroup = group;
                  });
                },
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Exercise list
          Expanded(
            child: filteredExercises.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    itemCount: filteredExercises.length,
                    itemBuilder: (context, index) {
                      final exercise = filteredExercises[index];
                      return _buildExerciseItem(exercise, setup);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text('No exercises found', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your search or filter criteria',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExerciseItem(Ex exercise, Settings setup) {
    // Get all muscles with recruitment > 0.5
    final recruitedMuscles = ProgramGroup.values
        .where((group) => exercise.recruitmentFiltered(group, {}, 0.5).volume > 0.5)
        .toList();

    // Get ratings for this exercise
    final ratings = exercise.ratings;

    return InkWell(
      onTap: () => widget.onExerciseSelected(exercise.id),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 4),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.5),
              width: 1,
            ),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Exercise name with ratings
            Row(
              children: [
                Expanded(
                  child: Text(
                    exercise.id,
                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                  ),
                ),
                if (ratings.isNotEmpty) RatingIcon(ratings: ratings, size: 20),
              ],
            ),
            const SizedBox(height: 8),

            // Modifiers
            if (exercise.modifiers.isNotEmpty) ...[
              Wrap(
                spacing: 6,
                runSpacing: 4,
                children: exercise.modifiers.map((modifier) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.5),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      modifier.name,
                      style: TextStyle(fontSize: 11, color: Theme.of(context).colorScheme.primary),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 8),
            ],

            // Cues
            if (exercise.cues.isNotEmpty) ...[
              Wrap(
                spacing: 6,
                runSpacing: 4,
                children: exercise.cues.entries.map((cue) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.5),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      cue.key,
                      style: TextStyle(
                        fontSize: 11,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 8),
            ],

            // Muscle recruitment visualization
            if (recruitedMuscles.isNotEmpty) ...[
              const SizedBox(height: 4),
              Wrap(
                spacing: 8,
                runSpacing: 6,
                children: recruitedMuscles.map((group) {
                  final recruitment = exercise.recruitmentFiltered(group, {}, 0.5).volume;
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: bgColorForProgramGroup(group).withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          group.name,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          width: 40,
                          height: 6,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            borderRadius: BorderRadius.circular(3),
                          ),
                          child: FractionallySizedBox(
                            alignment: Alignment.centerLeft,
                            widthFactor: recruitment,
                            child: Container(
                              decoration: BoxDecoration(
                                color: bgColorForProgramGroup(group),
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${(recruitment * 100).toStringAsFixed(0)}%',
                          style: TextStyle(
                            fontSize: 11,
                            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  List<Ex> _filterExercises(List<Ex> exercises) {
    var filtered = exercises;

    // Filter by search query
    if (_searchQuery.isNotEmpty) {
      filtered = filtered
          .where((exercise) => exercise.id.toLowerCase().contains(_searchQuery))
          .toList();
    }

    // Filter by muscle group
    if (_selectedMuscleGroup != null) {
      filtered = filtered
          .where(
            (exercise) => exercise.recruitmentFiltered(_selectedMuscleGroup!, {}, 0.5).volume > 0.5,
          )
          .toList();
    }

    // Sort by id
    filtered.sort((a, b) => a.id.compareTo(b.id));

    return filtered;
  }
}
