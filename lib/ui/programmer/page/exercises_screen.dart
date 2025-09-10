import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bodybuild/data/programmer/exercises.dart';
import 'package:bodybuild/data/programmer/groups.dart';
import 'package:bodybuild/data/programmer/equipment.dart';
import 'package:bodybuild/data/programmer/setup.dart';
import 'package:bodybuild/model/programmer/set_group.dart';
import 'package:bodybuild/ui/programmer/widget/exercise_edit_dialog.dart';
import 'package:bodybuild/ui/programmer/widget/rating_icon.dart';
import 'package:bodybuild/ui/programmer/util_groups.dart';

class ExercisesScreen extends ConsumerStatefulWidget {
  static const String routeName = 'exercises';

  const ExercisesScreen({super.key});

  @override
  ConsumerState<ExercisesScreen> createState() => _ExercisesScreenState();
}

class _ExercisesScreenState extends ConsumerState<ExercisesScreen> {
  String _searchQuery = '';
  ProgramGroup? _selectedMuscleGroup;
  Set<Equipment> _selectedEquipment = {};
  Ex? _selectedExercise;

  @override
  Widget build(BuildContext context) {
    final setup = ref.watch(setupProvider);

    return setup.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => Scaffold(
        body: Center(child: Text('Error: $error')),
      ),
      data: (setupData) => Scaffold(
        appBar: AppBar(
          title: const Text('Exercise Browser'),
          backgroundColor: Theme.of(context).colorScheme.surface,
        ),
        body: Row(
          children: [
            // Filters Panel
            Container(
              width: 300,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                border: Border(
                  right: BorderSide(
                    color:
                        Theme.of(context).dividerColor.withValues(alpha: 0.3),
                  ),
                ),
              ),
              child: _buildFiltersPanel(setupData),
            ),
            // Exercise List
            Expanded(
              flex: 2,
              child: _buildExerciseList(setupData),
            ),
            // Exercise Detail Panel
            if (_selectedExercise != null)
              Container(
                width: 400,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  border: Border(
                    left: BorderSide(
                      color:
                          Theme.of(context).dividerColor.withValues(alpha: 0.3),
                    ),
                  ),
                ),
                child: _buildExerciseDetail(setupData),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildFiltersPanel(setupData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Filters',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(height: 16),

        // Search Filter
        TextField(
          onChanged: (value) {
            setState(() {
              _searchQuery = value;
            });
          },
          decoration: InputDecoration(
            hintText: 'Search exercises...',
            prefixIcon: const Icon(Icons.search),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            filled: true,
            fillColor:
                Theme.of(context).colorScheme.primary.withValues(alpha: 0.05),
          ),
        ),
        const SizedBox(height: 24),

        // Muscle Group Filter
        Text(
          'Muscle Group',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).dividerColor),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<ProgramGroup?>(
              value: _selectedMuscleGroup,
              hint: const Text('All muscle groups'),
              isExpanded: true,
              items: [
                const DropdownMenuItem<ProgramGroup?>(
                  value: null,
                  child: Text('All muscle groups'),
                ),
                ...ProgramGroup.values.map((group) => DropdownMenuItem(
                      value: group,
                      child: Text(group.displayName),
                    )),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedMuscleGroup = value;
                });
              },
            ),
          ),
        ),
        const SizedBox(height: 24),

        // Equipment Filter
        Text(
          'Available Equipment',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _selectedEquipment = {};
                });
              },
              child: const Text('All'),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _selectedEquipment = setupData.availEquipment;
                });
              },
              child: const Text('My Equipment'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final category in EquipmentCategory.values) ...[
                  Text(
                    category.displayName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withValues(alpha: 0.8),
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...Equipment.values
                      .where((equipment) => equipment.category == category)
                      .map((equipment) {
                    return CheckboxListTile(
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        equipment.displayName,
                        style: const TextStyle(fontSize: 13),
                      ),
                      value: _selectedEquipment.isEmpty ||
                          _selectedEquipment.contains(equipment),
                      onChanged: (selected) {
                        setState(() {
                          if (_selectedEquipment.isEmpty) {
                            // If showing all, start with all equipment and remove this one
                            _selectedEquipment = Equipment.values.toSet();
                            if (selected != true) {
                              _selectedEquipment.remove(equipment);
                            }
                          } else {
                            if (selected == true) {
                              _selectedEquipment.add(equipment);
                            } else {
                              _selectedEquipment.remove(equipment);
                            }
                          }
                        });
                      },
                    );
                  }),
                  const SizedBox(height: 12),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildExerciseList(setupData) {
    final filteredExercises = _getFilteredExercises(setupData);

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            border: Border(
              bottom: BorderSide(
                color: Theme.of(context).dividerColor.withValues(alpha: 0.3),
              ),
            ),
          ),
          child: Row(
            children: [
              Text(
                'Exercises',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const Spacer(),
              Text(
                '${filteredExercises.length} exercises',
                style: TextStyle(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: filteredExercises.length,
            itemBuilder: (context, index) {
              final exercise = filteredExercises[index];
              final isSelected = _selectedExercise == exercise;

              return Container(
                decoration: BoxDecoration(
                  color: isSelected
                      ? Theme.of(context)
                          .colorScheme
                          .primary
                          .withValues(alpha: 0.1)
                      : null,
                  border: Border(
                    bottom: BorderSide(
                      color:
                          Theme.of(context).dividerColor.withValues(alpha: 0.1),
                    ),
                  ),
                ),
                child: ListTile(
                  title: Text(
                    exercise.id,
                    style: TextStyle(
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (exercise.equipment.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Wrap(
                          spacing: 4,
                          children: exercise.equipment
                              .map((eq) => Chip(
                                    label: Text(
                                      eq.displayName,
                                      style: const TextStyle(fontSize: 10),
                                    ),
                                    materialTapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                    visualDensity: VisualDensity.compact,
                                  ))
                              .toList(),
                        ),
                      ],
                      const SizedBox(height: 4),
                      _buildMuscleRecruitmentBar(exercise, setupData),
                    ],
                  ),
                  trailing: exercise.ratings.isNotEmpty
                      ? RatingIcon(ratings: exercise.ratings)
                      : null,
                  onTap: () {
                    setState(() {
                      _selectedExercise = isSelected ? null : exercise;
                    });
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMuscleRecruitmentBar(Ex exercise, setupData) {
    final recruitmentData = <ProgramGroup, double>{};
    for (final group in ProgramGroup.values) {
      final recruitment = exercise.recruitment(group, {});
      if (recruitment.volume > 0) {
        recruitmentData[group] = recruitment.volume;
      }
    }

    if (recruitmentData.isEmpty) return const SizedBox.shrink();

    return Container(
      height: 20,
      child: Row(
        children: recruitmentData.entries.map((entry) {
          final group = entry.key;
          final volume = entry.value;
          return Expanded(
            flex: (volume * 100).round(),
            child: Container(
              margin: const EdgeInsets.only(right: 1),
              decoration: BoxDecoration(
                color: bgColorForProgramGroup(group),
                borderRadius: BorderRadius.circular(2),
              ),
              child: Tooltip(
                message:
                    '${group.displayName}: ${(volume * 100).toStringAsFixed(0)}%',
                child: Container(),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildExerciseDetail(setupData) {
    if (_selectedExercise == null) return const SizedBox.shrink();

    final exercise = _selectedExercise!;
    final dummySets = Sets(1, ex: exercise);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Exercise Details',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                setState(() {
                  _selectedExercise = null;
                });
              },
            ),
          ],
        ),
        const SizedBox(height: 16),
        Expanded(
          child: SingleChildScrollView(
            child: ExerciseEditDialog(
              sets: dummySets,
              setup: setupData,
              onChange: (newSets) {
                // This is just for display, so we don't need to handle changes
              },
            ),
          ),
        ),
      ],
    );
  }

  List<Ex> _getFilteredExercises(setupData) {
    List<Ex> exercises = List.from(exes);

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      exercises = exercises
          .where(
              (ex) => ex.id.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }

    // Apply muscle group filter
    if (_selectedMuscleGroup != null) {
      exercises = exercises.where((ex) {
        final recruitment = ex.recruitment(_selectedMuscleGroup!, {});
        return recruitment.volume > 0;
      }).toList();
    }

    // Apply equipment filter
    if (_selectedEquipment.isNotEmpty) {
      exercises = exercises.where((ex) {
        if (ex.equipment.isEmpty) return true; // Bodyweight exercises
        return ex.equipment.every((eq) => _selectedEquipment.contains(eq));
      }).toList();
    }

    // Sort exercises alphabetically
    exercises.sort((a, b) => a.id.compareTo(b.id));

    return exercises;
  }
}
