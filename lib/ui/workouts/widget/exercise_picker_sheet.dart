import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bodybuild/data/programmer/exercises.dart';
import 'package:bodybuild/data/programmer/groups.dart';
import 'package:bodybuild/data/programmer/setup.dart';
import 'package:bodybuild/model/programmer/settings.dart';

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

          // Muscle group filter
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildFilterChip('All', _selectedMuscleGroup == null),
                const SizedBox(width: 8),
                ...ProgramGroup.values.map(
                  (group) => Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: _buildFilterChip(
                      group.name,
                      _selectedMuscleGroup == group,
                      onTap: () => setState(() {
                        _selectedMuscleGroup = _selectedMuscleGroup == group ? null : group;
                      }),
                    ),
                  ),
                ),
              ],
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

  Widget _buildFilterChip(String label, bool isSelected, {VoidCallback? onTap}) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: onTap != null
          ? (_) => onTap()
          : (_) => setState(() {
              _selectedMuscleGroup = null;
            }),
      selectedColor: Theme.of(context).colorScheme.primaryContainer,
      checkmarkColor: Theme.of(context).colorScheme.onPrimaryContainer,
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
    final primaryMuscles = ProgramGroup.values
        .where((group) => exercise.recruitmentFiltered(group, {}, 0.7).volume > 0)
        .take(3)
        .map((group) => group.name)
        .join(', ');

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        title: Text(exercise.id, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (primaryMuscles.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                'Primary: $primaryMuscles',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
            ],
            if (exercise.equipment.isNotEmpty) ...[
              const SizedBox(height: 2),
              Text(
                'Equipment: ${exercise.equipment.map((e) => e.toString()).join(', ')}',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                  fontSize: 12,
                ),
              ),
            ],
          ],
        ),
        trailing: const Icon(Icons.add_circle_outline),
        onTap: () => widget.onExerciseSelected(exercise.id),
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
            (exercise) => exercise.recruitmentFiltered(_selectedMuscleGroup!, {}, 0.5).volume > 0,
          )
          .toList();
    }

    // Sort by id
    filtered.sort((a, b) => a.id.compareTo(b.id));

    return filtered;
  }
}
