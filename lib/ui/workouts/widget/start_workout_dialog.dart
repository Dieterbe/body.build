import 'package:bodybuild/ui/core/widget/menu_tile.dart';
import 'package:bodybuild/ui/core/widget/menu_title.dart';
import 'package:bodybuild/ui/workouts/page/workout_screen.dart';
import 'package:bodybuild/ui/workouts/widget/template_picker_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class StartWorkoutDialog extends ConsumerStatefulWidget {
  const StartWorkoutDialog({super.key});

  @override
  ConsumerState<StartWorkoutDialog> createState() => _StartWorkoutDialogState();
}

class _StartWorkoutDialogState extends ConsumerState<StartWorkoutDialog> {
  bool _showTemplateSelection = false;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500),
        child: _showTemplateSelection
            ? TemplatePickerSheet(
                isInline: true,
                onBack: () {
                  setState(() => _showTemplateSelection = false);
                },
              )
            : SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const MenuTitle(title: 'Start Workout', icon: Icons.fitness_center),
                    // Options
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          MenuTile(
                            icon: Icons.add_circle_outline,
                            title: 'New Empty Workout',
                            subtitle: 'Start fresh with no exercises',
                            onTap: () {
                              Navigator.of(context).pop();
                              if (context.mounted) {
                                context.goNamed(WorkoutScreen.routeNameActive);
                              }
                            },
                          ),
                          const SizedBox(height: 12),
                          MenuTile(
                            icon: Icons.library_add_outlined,
                            title: 'From Template',
                            subtitle: 'Load exercises from a saved template',
                            onTap: () {
                              setState(() => _showTemplateSelection = true);
                            },
                          ),
                        ],
                      ),
                    ),
                    // Cancel Button
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: SizedBox(
                        width: double.infinity,
                        child: TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('Cancel'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
