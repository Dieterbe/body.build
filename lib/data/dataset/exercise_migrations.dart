/// Exercise migration system for handling breaking changes to exercise definitions
///
/// This system allows versioned migrations of exercise IDs and tweak configurations
/// across all persistence layers (Drift, SharedPreferences, URLs).
library;

/// Abstract base class for exercise migrations
abstract class ExerciseMigration {
  final int fromVersion;
  final int toVersion;

  const ExerciseMigration(this.fromVersion, this.toVersion);

  /// Apply migration to exercise + tweaks as a unit
  /// Returns (newExerciseId, newTweaks) or null if no change needed
  (String, Map<String, String>)? migrate(String exerciseId, Map<String, String> tweaks);

  /// Description for logging/UI
  String get description;
}

/// Simple exercise ID rename migration
class RenameExerciseMigration extends ExerciseMigration {
  final Map<String, String> renames; // oldId → newId

  const RenameExerciseMigration(super.fromVersion, super.toVersion, this.renames);

  @override
  (String, Map<String, String>)? migrate(String exerciseId, Map<String, String> tweaks) {
    final newId = renames[exerciseId];
    if (newId != null) {
      return (newId, tweaks); // ID changes, tweaks stay the same
    }
    return null; // No change needed
  }

  @override
  String get description => 'Rename exercises: ${renames.keys.join(', ')}';
}

/// Merge multiple exercises into one with a distinguishing tweak
class MergeExerciseMigration extends ExerciseMigration {
  final String newId;
  final String tweakName;
  final Map<String, String> idToTweakValue; // oldId → tweakValue

  const MergeExerciseMigration(
    super.fromVersion,
    super.toVersion,
    this.newId,
    this.tweakName,
    this.idToTweakValue,
  );

  @override
  (String, Map<String, String>)? migrate(String exerciseId, Map<String, String> tweaks) {
    final tweakValue = idToTweakValue[exerciseId];
    if (tweakValue != null) {
      // Add the new tweak that distinguishes the merged exercises
      final newTweaks = {...tweaks, tweakName: tweakValue};
      return (newId, newTweaks);
    }
    return null; // No change needed
  }

  @override
  String get description => 'Merge ${idToTweakValue.keys.join(', ')} into $newId';
}

/// Split exercise by tweak value into separate exercises
class SplitExerciseMigration extends ExerciseMigration {
  final String oldId;
  final String tweakName;
  final Map<String, String> tweakValueToNewId; // tweakValue → newId

  const SplitExerciseMigration(
    super.fromVersion,
    super.toVersion,
    this.oldId,
    this.tweakName,
    this.tweakValueToNewId,
  );

  @override
  (String, Map<String, String>)? migrate(String exerciseId, Map<String, String> tweaks) {
    if (exerciseId != oldId) return null; // Not applicable

    final tweakValue = tweaks[tweakName];
    final newId = tweakValueToNewId[tweakValue];

    if (newId == null) {
      throw ArgumentError(
        'Cannot migrate exercise "$oldId": unknown tweak value "${tweakValue ?? 'null'}" for tweak "$tweakName". '
        'Expected one of: ${tweakValueToNewId.keys.join(', ')}',
      );
    }

    // Remove the tweak that we're splitting on
    final newTweaks = Map<String, String>.of(tweaks)..remove(tweakName);

    return (newId, newTweaks);
  }

  @override
  String get description =>
      'Split $oldId by $tweakName into ${tweakValueToNewId.values.join(', ')}';
}

/// Rename tweak names or option values
class RenameTweakMigration extends ExerciseMigration {
  final String? targetExerciseId; // null = applies to all exercises
  final String? oldTweakName;
  final String? newTweakName;
  final String? oldOptionValue;
  final String? newOptionValue;

  const RenameTweakMigration(
    super.fromVersion,
    super.toVersion, {
    this.targetExerciseId,
    this.oldTweakName,
    this.newTweakName,
    this.oldOptionValue,
    this.newOptionValue,
  });

  @override
  (String, Map<String, String>)? migrate(String exerciseId, Map<String, String> tweaks) {
    // Check if this migration applies to this exercise
    if (targetExerciseId != null && targetExerciseId != exerciseId) {
      return null; // Not applicable to this exercise
    }

    var newTweaks = Map<String, String>.of(tweaks);
    bool changed = false;

    if (oldTweakName != null && newTweakName != null) {
      // Rename tweak key
      if (newTweaks.containsKey(oldTweakName!)) {
        final value = newTweaks.remove(oldTweakName!);
        newTweaks[newTweakName!] = value!;
        changed = true;
      }
    }

    if (oldTweakName != null && oldOptionValue != null && newOptionValue != null) {
      // Rename option value
      if (newTweaks[oldTweakName!] == oldOptionValue) {
        newTweaks[oldTweakName!] = newOptionValue!;
        changed = true;
      }
    }

    return changed ? (exerciseId, newTweaks) : null;
  }

  @override
  String get description {
    if (oldTweakName != null && newTweakName != null) {
      return 'Rename tweak "$oldTweakName" to "$newTweakName"';
    }
    if (oldTweakName != null && oldOptionValue != null && newOptionValue != null) {
      return 'Rename option "$oldOptionValue" to "$newOptionValue" in tweak "$oldTweakName"';
    }
    return 'Rename tweak migration';
  }
}
