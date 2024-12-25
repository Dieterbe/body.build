import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ptc/data/programmer/current_setup_profile_provider.dart';
import 'package:ptc/data/programmer/setup_persistence_provider.dart';
import 'package:ptc/data/programmer/setup_profile_list_provider.dart';
import 'package:ptc/model/programmer/settings.dart';

class SetupProfileHeader extends ConsumerWidget {
  const SetupProfileHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Combined profile selector and name editor
              ref.watch(setupProfileListProvider).when(
                    loading: () => const SizedBox(
                      width: 200,
                      child: LinearProgressIndicator(),
                    ),
                    error: (error, stack) => Text('Error: $error'),
                    data: (profiles) => ref
                        .watch(currentSetupProfileProvider)
                        .when(
                          loading: () => const CircularProgressIndicator(),
                          error: (error, stack) => Text('Error: $error'),
                          data: (currentId) => SizedBox(
                            width: 400,
                            child: DropdownButtonFormField<String>(
                              value: currentId,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                    color:
                                        Theme.of(context).colorScheme.outline,
                                  ),
                                ),
                                filled: true,
                                fillColor:
                                    Theme.of(context).colorScheme.surface,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                              ),
                              icon: Icon(
                                Icons.arrow_drop_down,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              style: Theme.of(context).textTheme.bodyLarge,
                              items: profiles.keys.map((id) {
                                final profileName =
                                    profiles[id]?.name ?? 'Unnamed Profile';
                                return DropdownMenuItem(
                                  value: id,
                                  child: Text(
                                    profileName,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                );
                              }).toList(),
                              onChanged: (id) {
                                if (id != null) {
                                  ref
                                      .read(
                                          currentSetupProfileProvider.notifier)
                                      .select(id);
                                }
                              },
                            ),
                          ),
                        ),
                  ),
              const SizedBox(width: 16),
              // Profile management buttons
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).colorScheme.outlineVariant,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    IconButton(
                      style: IconButton.styleFrom(
                        shape: const RoundedRectangleBorder(),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      icon: Icon(
                        Icons.edit,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      tooltip: 'Rename Profile',
                      onPressed: () async {
                        final currentId =
                            await ref.read(currentSetupProfileProvider.future);
                        final service =
                            await ref.read(setupPersistenceProvider.future);
                        final currentProfile =
                            await service.loadProfile(currentId);
                        if (currentProfile == null) return;

                        final controller =
                            TextEditingController(text: currentProfile.name);
                        // ignore: use_build_context_synchronously
                        await showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Rename Profile'),
                            content: TextField(
                              controller: controller,
                              decoration: const InputDecoration(
                                labelText: 'Profile Name',
                              ),
                              autofocus: true,
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () async {
                                  final newName = controller.text.trim();
                                  if (newName.isNotEmpty) {
                                    await service.saveProfile(
                                      currentId,
                                      currentProfile.copyWith(name: newName),
                                    );
                                    ref.invalidate(setupProfileListProvider);
                                    // Wait for the profile list to be reloaded
                                    await ref
                                        .read(setupProfileListProvider.future);
                                    // ignore: use_build_context_synchronously
                                    Navigator.pop(context);
                                  }
                                },
                                child: const Text('Save'),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    IconButton(
                      style: IconButton.styleFrom(
                        shape: const RoundedRectangleBorder(),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      icon: Icon(
                        Icons.copy,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      tooltip: 'Duplicate Profile',
                      onPressed: () async {
                        final currentId =
                            await ref.read(currentSetupProfileProvider.future);
                        final service =
                            await ref.read(setupPersistenceProvider.future);
                        final currentProfile =
                            await service.loadProfile(currentId);
                        if (currentProfile == null) return;

                        // Find the next available copy number
                        final baseName = currentProfile.name;
                        final allProfiles =
                            await ref.read(setupProfileListProvider.future);
                        int copyNumber = 1;
                        String newName;
                        do {
                          newName = copyNumber == 1
                              ? '$baseName (Copy)'
                              : '$baseName (Copy $copyNumber)';
                          copyNumber++;
                        } while (
                            allProfiles.values.any((p) => p.name == newName));

                        final newId =
                            DateTime.now().millisecondsSinceEpoch.toString();
                        await service.saveProfile(
                          newId,
                          currentProfile.copyWith(name: newName),
                        );
                        ref.invalidate(setupProfileListProvider);
                        await ref.read(setupProfileListProvider.future);
                        // Then switch to the new profile
                        ref
                            .read(currentSetupProfileProvider.notifier)
                            .select(newId);
                      },
                    ),
                    IconButton(
                      style: IconButton.styleFrom(
                        shape: const RoundedRectangleBorder(),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      icon: Icon(
                        Icons.add,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      tooltip: 'New Profile',
                      onPressed: () async {
                        final service =
                            await ref.read(setupPersistenceProvider.future);
                        final newId =
                            DateTime.now().millisecondsSinceEpoch.toString();
                        await service.saveProfile(newId, Settings.defaults());
                        ref.invalidate(setupProfileListProvider);
                        await ref
                            .read(setupProfileListProvider.future)
                            .then((_) {
                          // Then switch to the new profile
                          ref
                              .read(currentSetupProfileProvider.notifier)
                              .select(newId);
                        });
                      },
                    ),
                    IconButton(
                      style: IconButton.styleFrom(
                        shape: const RoundedRectangleBorder(),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      icon: Icon(
                        Icons.delete,
                        color: Theme.of(context).colorScheme.error,
                      ),
                      tooltip: 'Delete Profile',
                      onPressed: () async {
                        final profiles =
                            await ref.read(setupProfileListProvider.future);
                        if (profiles.length <= 1) {
                          // Don't allow deleting the last profile
                          return;
                        }

                        final currentId =
                            await ref.read(currentSetupProfileProvider.future);
                        final service =
                            await ref.read(setupPersistenceProvider.future);
                        final currentProfile =
                            await service.loadProfile(currentId);
                        if (currentProfile == null) return;

                        // ignore: use_build_context_synchronously
                        final confirmed = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Delete Profile'),
                            content: Text(
                                'Are you sure you want to delete "${currentProfile.name}"?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: Text(
                                  'Delete',
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.error,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );

                        if (confirmed == true) {
                          // Select a different profile before deleting
                          final newId =
                              profiles.keys.firstWhere((id) => id != currentId);
                          ref
                              .read(currentSetupProfileProvider.notifier)
                              .select(newId);
                          await service.deleteProfile(currentId);
                          ref.invalidate(setupProfileListProvider);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
