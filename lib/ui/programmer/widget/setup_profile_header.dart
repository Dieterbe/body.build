import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ptc/data/programmer/current_setup_profile_provider.dart';
import 'package:ptc/data/programmer/setup_persistence_provider.dart';
import 'package:ptc/data/programmer/setup_profile_list_provider.dart';
import 'package:ptc/model/programmer/settings.dart';
import 'package:ptc/ui/core/widget/data_manager.dart';

class SetupProfileHeader extends ConsumerWidget {
  const SetupProfileHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // returns all the keys of programs, the first one being currentId
    List<String> getOpts(String currentId, Map<String, Settings> profiles) {
      final currentName = profiles[currentId]!.name;
      final otherNames = profiles.entries
          .where((e) => e.key != currentId)
          .map((e) => e.value.name)
          .toList();
      return [currentName, ...otherNames];
    }

    return ref.watch(setupProfileListProvider).when(
        loading: () => const SizedBox(
              width: 200,
              child: LinearProgressIndicator(),
            ),
        error: (error, stack) => Text('Error: $error'),
        data: (profiles) => ref.watch(currentSetupProfileProvider).when(
              loading: () => const CircularProgressIndicator(),
              error: (error, stack) => Text('Error: $error'),
              data: (currentId) => DataManager(
                  opts: getOpts(currentId, profiles),
                  onSelect: (name) {
                    final profiles = ref.read(setupProfileListProvider).value!;
                    final profile = profiles.entries.firstWhere(
                      (e) => e.value.name == name,
                    );
                    ref
                        .read(currentSetupProfileProvider.notifier)
                        .select(profile.key);
                  },
                  onCreate: (String id, String name) async {
                    final service =
                        await ref.read(setupPersistenceProvider.future);

                    await service.saveProfile(
                        id, Settings.defaults(name: name));
                    ref.invalidate(setupProfileListProvider);
                    await ref.read(setupProfileListProvider.future).then((_) {
                      // Then switch to the new profile
                      ref.read(currentSetupProfileProvider.notifier).select(id);
                    });
                  },
                  onRename: (oldName, newName) async {
                    final service =
                        await ref.read(setupPersistenceProvider.future);
                    final profiles = await service.loadProfiles();
                    final entry = profiles.entries
                        .firstWhere((e) => e.value.name == oldName);
                    await service.saveProfile(
                      entry.key,
                      entry.value.copyWith(name: newName),
                    );
                    ref.invalidate(setupProfileListProvider);
                    // Wait for the profile list to be reloaded
                    await ref.read(setupProfileListProvider.future);
                  },
                  onDuplicate: (oldName, newName) async {
                    final currentId =
                        await ref.read(currentSetupProfileProvider.future);
                    final service =
                        await ref.read(setupPersistenceProvider.future);
                    final currentProfile = await service.loadProfile(currentId);
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
                    } while (allProfiles.values.any((p) => p.name == newName));

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
                  onDelete: (String name) async {
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
                    final currentProfile = await service.loadProfile(currentId);
                    if (currentProfile == null) return;

                    // Select a different profile before deleting
                    final newId =
                        profiles.keys.firstWhere((id) => id != currentId);
                    ref
                        .read(currentSetupProfileProvider.notifier)
                        .select(newId);
                    await service.deleteProfile(currentId);
                    ref.invalidate(setupProfileListProvider);
                  }),
            ));
  }
}
