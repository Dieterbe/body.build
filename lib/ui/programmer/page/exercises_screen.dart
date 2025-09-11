import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bodybuild/data/programmer/exercises.dart';
import 'package:bodybuild/data/programmer/groups.dart';
import 'package:bodybuild/data/programmer/equipment.dart';
import 'package:bodybuild/data/programmer/setup.dart';
import 'package:bodybuild/model/programmer/set_group.dart';
import 'package:bodybuild/ui/programmer/widget/exercise_details_dialog.dart';
import 'package:bodybuild/ui/programmer/widget/rating_icon.dart';
import 'package:bodybuild/ui/programmer/util_groups.dart';
import 'package:bodybuild/ui/core/widget/navigation_drawer.dart';

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
  Set<EquipmentCategory> _selectedEquipmentCategories = {};
  Ex? _selectedExercise;
  bool _showFilters = false;

  @override
  Widget build(BuildContext context) {
    final setup = ref.watch(setupProvider);
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 1024;
    final isTablet = screenWidth > 768 && screenWidth <= 1024;

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
          actions: [
            if (!isDesktop) ...[
              IconButton(
                icon: Icon(
                    _showFilters ? Icons.filter_list_off : Icons.filter_list),
                onPressed: () {
                  setState(() {
                    _showFilters = !_showFilters;
                  });
                },
              ),
            ],
          ],
        ),
        drawer: const AppNavigationDrawer(),
        body: isDesktop
            ? _buildDesktopLayout(setupData)
            : isTablet
                ? _buildTabletLayout(setupData)
                : _buildMobileLayout(setupData),
      ),
    );
  }

  Widget _buildDesktopLayout(setupData) {
    return Row(
      children: [
        // Filters Panel
        Container(
          width: 300,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            border: Border(
              right: BorderSide(
                color: Theme.of(context).dividerColor.withValues(alpha: 0.3),
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
                  color: Theme.of(context).dividerColor.withValues(alpha: 0.3),
                ),
              ),
            ),
            alignment: Alignment.topCenter,
            child: _buildExerciseDetail(setupData),
          ),
      ],
    );
  }

  Widget _buildTabletLayout(setupData) {
    return Stack(
      children: [
        Row(
          children: [
            // Collapsible Filters Panel
            if (_showFilters)
              Container(
                width: 280,
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
              child: _buildExerciseList(setupData),
            ),
          ],
        ),
        // Exercise Detail Modal
        if (_selectedExercise != null) _buildExerciseDetailModal(setupData),
      ],
    );
  }

  Widget _buildMobileLayout(setupData) {
    return Column(
      children: [
        if (_showFilters) _buildCompactFilterBar(setupData),
        Expanded(
          child: _buildExerciseList(setupData),
        ),
      ],
    );
  }

  Widget _buildCompactFilterBar(setupData) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).dividerColor.withValues(alpha: 0.3),
          ),
        ),
      ),
      child: Column(
        children: [
          // Search Bar
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
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
          ),
          const SizedBox(height: 12),
          // Quick Filters Row
          Row(
            children: [
              // Muscle Group Chip
              Expanded(
                child: GestureDetector(
                  onTap: () => _showMuscleGroupPicker(),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      border: Border.all(color: Theme.of(context).dividerColor),
                      borderRadius: BorderRadius.circular(8),
                      color: _selectedMuscleGroup != null
                          ? Theme.of(context)
                              .colorScheme
                              .primary
                              .withValues(alpha: 0.1)
                          : null,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.fitness_center, size: 16),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            _selectedMuscleGroup?.displayName ?? 'All muscles',
                            style: const TextStyle(fontSize: 12),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Icon(Icons.arrow_drop_down, size: 16),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // Equipment Chip
              Expanded(
                child: GestureDetector(
                  onTap: () => _showEquipmentPicker(setupData),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      border: Border.all(color: Theme.of(context).dividerColor),
                      borderRadius: BorderRadius.circular(8),
                      color: _selectedEquipmentCategories.isNotEmpty ||
                              _selectedEquipment.isNotEmpty
                          ? Theme.of(context)
                              .colorScheme
                              .primary
                              .withValues(alpha: 0.1)
                          : null,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.build, size: 16),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            _getEquipmentFilterText(),
                            style: const TextStyle(fontSize: 12),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Icon(Icons.arrow_drop_down, size: 16),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
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
          'Equipment',
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
                  _selectedEquipmentCategories = {};
                });
              },
              child: const Text('All'),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _selectedEquipment = setupData.availEquipment;
                  _selectedEquipmentCategories = {};
                });
              },
              child: const Text('My Equipment'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Expanded(
          child: SingleChildScrollView(
            child: _buildSimplifiedEquipmentList(),
          ),
        ),
      ],
    );
  }

  Widget _buildSimplifiedEquipmentList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Individual Non-machine and General Machine equipment
        ...Equipment.values
            .where((eq) =>
                eq.category == EquipmentCategory.nonMachine ||
                eq.category == EquipmentCategory.generalMachines)
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
            onChanged: (selected) => _toggleEquipment(equipment, selected),
          );
        }),

        const SizedBox(height: 12),

        // Grouped machine categories
        ...[
          EquipmentCategory.upperBodyMachines,
          EquipmentCategory.lowerBodyMachines,
          EquipmentCategory.coreAndGluteMachines,
        ].map((category) {
          final isSelected = _selectedEquipmentCategories.contains(category);
          return CheckboxListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            title: Text(
              category.displayName,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
            ),
            value: isSelected,
            onChanged: (selected) =>
                _toggleEquipmentCategory(category, selected),
          );
        }),
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

                    // On mobile, show modal
                    if (MediaQuery.of(context).size.width <= 768 &&
                        _selectedExercise != null) {
                      _showExerciseDetailModal(setupData);
                    }
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
      height: 10,
      margin: const EdgeInsets.only(top: 4),
      child: Row(
        children: recruitmentData.entries.map((entry) {
          final group = entry.key;
          final volume = entry.value;
          return Expanded(
            flex: (volume * 100).round(),
            child: Container(
              margin: const EdgeInsets.only(right: 0.5),
              decoration: BoxDecoration(
                color: bgColorForProgramGroup(group).withValues(alpha: 0.7),
                borderRadius: BorderRadius.circular(1),
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

    return SingleChildScrollView(
      child: ExerciseDetailsDialog(
        sets: dummySets,
        setup: setupData,
        onClose: () {
          setState(() {
            _selectedExercise = null;
          });
        },
      ),
    );
  }

  Widget _buildExerciseDetailForModal(setupData, BuildContext dialogContext) {
    if (_selectedExercise == null) return const SizedBox.shrink();

    final exercise = _selectedExercise!;
    final dummySets = Sets(1, ex: exercise);

    return SingleChildScrollView(
      child: ExerciseDetailsDialog(
        sets: dummySets,
        setup: setupData,
        onClose: () {
          setState(() {
            _selectedExercise = null;
          });
          Navigator.pop(dialogContext);
        },
      ),
    );
  }

  Widget _buildExerciseDetailModal(setupData) {
    return Container(
      color: Colors.black54,
      child: Center(
        child: Container(
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.all(16),
          constraints: const BoxConstraints(maxWidth: 600, maxHeight: 700),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: _buildExerciseDetail(setupData),
        ),
      ),
    );
  }

  void _showExerciseDetailModal(setupData) {
    showDialog(
      context: context,
      builder: (dialogContext) => Dialog(
        insetPadding: const EdgeInsets.all(20),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 600, maxHeight: 700),
          padding: const EdgeInsets.all(16),
          child: _buildExerciseDetailForModal(setupData, dialogContext),
        ),
      ),
    );
  }

  void _showMuscleGroupPicker() {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Select Muscle Group'),
        children: [
          SimpleDialogOption(
            onPressed: () {
              setState(() {
                _selectedMuscleGroup = null;
              });
              Navigator.pop(context);
            },
            child: const Text('All muscle groups'),
          ),
          ...ProgramGroup.values.map((group) => SimpleDialogOption(
                onPressed: () {
                  setState(() {
                    _selectedMuscleGroup = group;
                  });
                  Navigator.pop(context);
                },
                child: Text(group.displayName),
              )),
        ],
      ),
    );
  }

  void _showEquipmentPicker(setupData) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Equipment'),
        content: Container(
          width: double.maxFinite,
          child: _buildSimplifiedEquipmentList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  void _toggleEquipment(Equipment equipment, bool? selected) {
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
  }

  void _toggleEquipmentCategory(EquipmentCategory category, bool? selected) {
    setState(() {
      if (selected == true) {
        _selectedEquipmentCategories.add(category);
      } else {
        _selectedEquipmentCategories.remove(category);
      }
    });
  }

  String _getEquipmentFilterText() {
    if (_selectedEquipmentCategories.isEmpty && _selectedEquipment.isEmpty) {
      return 'All equipment';
    }

    final count = _selectedEquipmentCategories.length +
        _selectedEquipment
            .where((eq) =>
                eq.category == EquipmentCategory.nonMachine ||
                eq.category == EquipmentCategory.generalMachines)
            .length;

    return count == 1 ? '1 filter' : '$count filters';
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
    if (_selectedEquipment.isNotEmpty ||
        _selectedEquipmentCategories.isNotEmpty) {
      exercises = exercises.where((ex) {
        if (ex.equipment.isEmpty) return true; // Bodyweight exercises

        // Check individual equipment selections
        final hasSelectedEquipment =
            ex.equipment.any((eq) => _selectedEquipment.contains(eq));

        // Check category selections
        final hasSelectedCategory = ex.equipment
            .any((eq) => _selectedEquipmentCategories.contains(eq.category));

        return hasSelectedEquipment || hasSelectedCategory;
      }).toList();
    }

    // Sort exercises alphabetically
    exercises.sort((a, b) => a.id.compareTo(b.id));

    return exercises;
  }
}
