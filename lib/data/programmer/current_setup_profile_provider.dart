import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ptc/model/programmer/settings.dart';
import 'package:ptc/data/programmer/setup_persistence_provider.dart';

part 'current_setup_profile_provider.g.dart';

@riverpod
class CurrentSetupProfile extends _$CurrentSetupProfile {
  @override
  Future<String> build() async {
    ref.onDispose(() {
      print('current setup profile provider disposed');
    });

    // Get the persistence service
    final service = await ref.read(setupPersistenceProvider.future);

    // Try to load the last selected profile ID
    final lastProfileId = await service.loadLastProfileId();
    if (lastProfileId != null) {
      // Verify the profile still exists
      final profile = await service.loadProfile(lastProfileId);
      if (profile != null) {
        return lastProfileId;
      }
    }

    // If no last profile or it doesn't exist anymore, get the first available profile
    final profiles = await service.loadProfiles();

    if (profiles.isEmpty) {
      final newId = DateTime.now().millisecondsSinceEpoch.toString();
      await service.saveProfile(
        newId,
        Settings.defaults(),
      );
      await service.saveLastProfileId(newId);
      return newId;
    }

    final firstId = profiles.keys.first;
    await service.saveLastProfileId(firstId);
    return firstId;
  }

  void select(String id) async {
    state = AsyncData(id);
    // Save the selected profile ID
    final service = await ref.read(setupPersistenceProvider.future);
    await service.saveLastProfileId(id);
  }
}
