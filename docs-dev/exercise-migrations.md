# Exercise Migration System

## Overview

This document analyzes the requirements and design for a migration system to handle breaking changes to exercise definitions stored in `exercises.dart`. The system needs to handle changes to exercise IDs, tweak names/options, and structural transformations while maintaining data integrity across all persistence layers.

## Current State

### Exercise Version Tracking

- **Version constant**: `exerciseDatasetVersion = 1` in `exercises.dart`
- **Version tracking**: `ExerciseVersions` table in Drift tracks version, timestamp, and source, `flutter.exercise_dataset_version_programs` and `flutter.exercise_dataset_version_setup` in sharedPreferences.
- **Version checking**: Happens at startup in:
  - `ProgrammerScreen` (checks both setup and program services)
  - `WorkoutDatabase._checkExerciseMigration()` (currently just throws error)
  - `ProgramPersistenceService.checkExerciseMigration()`
  - `SetupPersistenceService.checkExerciseMigration()`

**Problems**:
 - For drift and sharedPreferences we only check the version but no actual migration logic is implemented: migrations currently fail with error messages.
 - For incoming URL's we cannot know the version of the referenced exercise and tweaks, we can only guess. And we have no migration or resolution logic in place.

### Exercise References: All Storage Points

#### 1. **Drift Database** (Workouts Feature)
- **Table**: `WorkoutSets`
- **Fields**: 
  - `exerciseId: String` - Exercise identifier
  - `tweaks: String` - JSON-encoded `Map<String, String>` of tweak options
- **Access**: Via `WorkoutPersistenceService` → `WorkoutDatabase`
- **Serialization**: 
  ```dart
  // Store
  tweaksJson = json.encode(Map<String, String>)
  // Load
  tweaksFromJson(String) → Map<String, String>
  ```

#### 2. **SharedPreferences** (Programmer Feature - Programs)
- **Key**: `'programs'` 
- **Structure**: `Map<String, ProgramState>` serialized as JSON
- **Path**: `ProgramState` → `Workout` → `SetGroup` → `Sets`
- **Fields in Sets model**:
  - `ex: Ex?` - Serialized via `_exToJson()` / `_exFromJson()`
  - Stores only exercise ID as string: `String? _exToJson(Ex?) => ex?.id`
  - `tweakOptions: Map<String, String>` - Directly serialized
- **Access**: Via `ProgramPersistenceService`
- **Migration helper**: `migrateTweakOptions()` in `set_group.dart` (currently handles `&` → `and` replacement)

#### 3. **SharedPreferences** (Programmer Feature - Setup Profiles)
- **Key**: `'setup_profiles'`
- **Structure**: `Map<String, Settings>` serialized as JSON
- **Relevant fields**:
  - `excludedExercises: Set<String>` - Set of exercise IDs
- **Access**: Via `SetupPersistenceService`
- **Note**: This feature has effectively been disabled since the beginning and isn't really relevant at this time.  If & when we re-introduce it, we can come up with a better implementation (which refers to exercises by ID and tweaks) and devise an appropriate migration strategy.  For now, we can ignore this.

#### 4. **URLs** (Exercise Browser Deep Links)
- **Pattern**: `/exercises/:id?t_tweakName=optionValue`
- **Encoding**: Spaces replaced with underscores
- **Functions**: `buildExerciseDetailUrl()`, `parseExerciseId()`, `parseExerciseParams()`
- **Usage**: 
  - Deep linking to specific exercise configurations
  - Browser history/bookmarks
  - Shared links

### Exercise Definition Lookup

```dart
// In set_group.dart
Ex? _exFromJson(String? id) {
  if (id == null) return null;
  try {
    return exes.firstWhere((e) => e.id == id);
  } catch (e) {
    print('could not find exercise $id - this should never happen');
    return null;
  }
}
```

**Critical**: All persisted data stores only the exercise ID string. The `Ex` object is reconstructed by looking up the ID in the `exes` list at runtime.

## Migration Types & Impacts

### 1. **Rename Exercise** (Simple ID Change)

**Use Case**: Fix typo, improve naming convention, consolidate similar exercises

**Example**: `"bench press (barbell)"` → `"barbell bench press"`

**Impact**:
- ✅ Drift: Exercise ID in `WorkoutSets.exerciseId`
- ✅ SharedPreferences Programs: Exercise ID in `Sets` JSON
- ✅ URLs: Exercise ID in path
- ❌ Tweaks: No changes (exercise structure unchanged)

**Migration**: Simple string replacement `oldId → newId`

---

### 2. **Merge Exercises** (Multiple IDs → One ID + Tweak)

**Use Case**: Consolidate exercise variations that differ only in one dimension

**Example**: 
```
"dumbbell bicep curl" + "barbell bicep curl" + "cable bicep curl"
  ↓
"bicep curl" with tweak: equipment = {dumbbell, barbell, cable}
```

**Impact**:
- ✅ Drift: Replace exercise ID + add tweak to JSON
- ✅ SharedPreferences Programs: Replace exercise ID + add to `tweakOptions`
- ✅ URLs: Replace ID + add query parameter
- ✅ Tweaks: Must handle default value assignment

**Migration**: `Map<oldId, (newId, Map<tweakName, tweakValue>)>`

**Complexity**: Medium
- Need to determine which tweak value each old ID maps to
- Must ensure tweak exists in new exercise definition
- URL migration requires query param injection

---

### 3. **Split Exercise** (One ID + Tweak → Multiple IDs)

**Use Case**: Separate exercise when variations are biomechanically distinct

**Example**:
```
"squat" with tweak: depth = {quarter, half, full}
  ↓
"quarter squat" + "half squat" + "full squat" (separate exercises without 'depth' tweak)
```

**Impact**:
- ✅ Drift: Adjust ID based on tweak value in JSON, and take out the tweak.
- ✅ SharedPreferences Programs: Adjust ID based on tweak value in JSON, and take out the tweak.
- ✅ URLs: Remove tweak query param, change ID
- ❌ Tweaks: Remove tweak from definition

**Migration**: `(oldId, tweakName) → Map<tweakValue, newId>`

**Complexity**: Medium-High
- Must inspect tweak value to determine target ID
- Workout sets with same exercise but different tweak values split into different exercise IDs
- Need fallback for missing/unknown tweak values

---

### 4. **Add/Remove/Rename Tweak**

#### 4a. **Add Tweak**
**Impact**: ❌ None (new tweak uses default value)
**Migration**: Not needed—backward compatible

#### 4b. **Remove Tweak**
**Impact**: ⚠️ Drift & Programs have orphaned tweak data (harmless but clutter)
**Migration**: Optional cleanup `(exerciseId, tweakName) → remove from maps`

#### 4c. **Rename Tweak**
**Impact**: 
- ✅ Drift: Tweak key in JSON
- ✅ SharedPreferences Programs: `tweakOptions` map key
- ✅ URLs: Query parameter key

**Migration**: `(exerciseId, oldTweakName) → newTweakName`

**Complexity**: Low-Medium

---

### 5. **Change Tweak Options** (Rename/Add/Remove Option Values)

#### 5a. **Add Option**
**Impact**: ❌ None—backward compatible
**Migration**: Not needed

#### 5b. **Remove Option** 
**Impact**: ⚠️ Persisted data may reference non-existent option
**Migration**: `(exerciseId, tweakName, oldOption) → defaultOption`

#### 5c. **Rename Option**
**Impact**:
- ✅ Drift: Tweak value in JSON
- ✅ SharedPreferences Programs: `tweakOptions` map value
- ✅ URLs: Query parameter value

**Migration**: `(exerciseId, tweakName, oldValue) → newValue`

**Complexity**: Low-Medium

---

### 6. **Change Tweak Default Value**

**Impact**: ❌ None—only affects new data
**Migration**: Not needed (unless we want to normalize old data)

---

## Proposed Migration System

### Architecture

```
ExerciseMigrationService
├── Migration rules defined in code (versioned)
├── Applied automatically at data load time
├── In drift and sharedPreferences: atomically write all changes back to storage along with the new version.
└── Reports migration status/errors to user
```

Outgoing URL's are always generated following the current latest version, but don't carry a version marker. Incoming URL's
may use a previous version and we don't know exactly what version they use. So this case is tricker and we still need a good solution.

### Core Components

#### 1. **Migration Rule Definition**

```dart
// In exercises.dart or new migrations.dart file
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
```

#### 2. **Concrete Migration Types**

```dart
// Simple rename
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
}

// Merge exercises into one with tweak
class MergeExerciseMigration extends ExerciseMigration {
  final String newId;
  final String tweakName;
  final Map<String, String> idToTweakValue; // oldId → tweakValue
  
  const MergeExerciseMigration(super.fromVersion, super.toVersion, this.newId, this.tweakName, this.idToTweakValue);
  
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
}

// Split exercise by tweak value
class SplitExerciseMigration extends ExerciseMigration {
  final String oldId;
  final String tweakName;
  final Map<String, String> tweakValueToNewId; // tweakValue → newId
  final String fallbackId; // If tweak value not found
  
  const SplitExerciseMigration(super.fromVersion, super.toVersion, this.oldId, this.tweakName, this.tweakValueToNewId, this.fallbackId);
  
  @override
  (String, Map<String, String>)? migrate(String exerciseId, Map<String, String> tweaks) {
    if (exerciseId != oldId) return null; // Not applicable
    
    final tweakValue = tweaks[tweakName];
    final newId = tweakValueToNewId[tweakValue] ?? fallbackId;
    
    // Remove the tweak that we're splitting on
    final newTweaks = Map<String, String>.from(tweaks)..remove(tweakName);
    
    return (newId, newTweaks);
  }
}

// Rename tweak or option
class RenameTweakMigration extends ExerciseMigration {
  final String? exerciseId; // null = applies to all exercises
  final String? oldTweakName;
  final String? newTweakName;
  final String? oldOptionValue;
  final String? newOptionValue;
  
  const RenameTweakMigration(super.fromVersion, super.toVersion, {
    this.exerciseId,
    this.oldTweakName,
    this.newTweakName,
    this.oldOptionValue,
    this.newOptionValue,
  });
  
  @override
  (String, Map<String, String>)? migrate(String exerciseId, Map<String, String> tweaks) {
    // Check if this migration applies to this exercise
    if (this.exerciseId != null && this.exerciseId != exerciseId) {
      return null; // Not applicable to this exercise
    }
    
    var newTweaks = Map<String, String>.from(tweaks);
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
}
```

#### 3. **Migration Registry**

```dart
// In exercises.dart
const List<ExerciseMigration> exerciseMigrations = [
  // Example migrations (none currently needed)
  // RenameExerciseMigration(1, 2, {
  //   'old bench press': 'bench press',
  // }),
];

// Version must match the highest toVersion in migrations
const int exerciseDatasetVersion = 1;
```

#### 4. **Migration Service**

```dart
// In new file: /lib/service/exercise_migration_service.dart
class ExerciseMigrationService {
  /// Migrate exercise ID and tweaks through all applicable migrations
  static (String, Map<String, String>) migrateExercise(
    String exerciseId,
    Map<String, String> tweaks,
    int fromVersion,
    int toVersion,
  ) {
    var currentId = exerciseId;
    var currentTweaks = Map<String, String>.from(tweaks);
    
    for (final migration in exerciseMigrations) {
      if (migration.fromVersion >= fromVersion && migration.toVersion <= toVersion) {
        final result = migration.migrate(currentId, currentTweaks);
        if (result != null) {
          currentId = result.$1;
          currentTweaks = result.$2;
        }
      }
    }
    
    return (currentId, currentTweaks);
  }
  
  /// Convenience method for migrating just exercise ID (when tweaks don't matter)
  static String migrateExerciseId(String exerciseId, int fromVersion, int toVersion) {
    final (newId, _) = migrateExercise(exerciseId, {}, fromVersion, toVersion);
    return newId;
  }
  
  /// Convenience method for migrating just tweaks (when ID doesn't change)
  static Map<String, String> migrateTweaks(
    String exerciseId,
    Map<String, String> tweaks,
    int fromVersion,
    int toVersion,
  ) {
    final (_, newTweaks) = migrateExercise(exerciseId, tweaks, fromVersion, toVersion);
    return newTweaks;
  }
}
```

#### 5. **Integration Points**

##### 5a. **Drift Database Migration**
```dart
// In workout_database.dart
Future<void> _checkExerciseMigration() async {
  final currentVersion = await getCurrentExerciseVersion();
  
  if (currentVersion == null || currentVersion == exerciseDatasetVersion) {
    return; // Up to date
  }
  
  if (currentVersion > exerciseDatasetVersion) {
    throw Exception('Database version ($currentVersion) newer than app ($exerciseDatasetVersion)');
  }
  
  print('Migrating workout data from v$currentVersion to v$exerciseDatasetVersion');
  
  // Get all workout sets
  final allSets = await select(workoutSets).get();
  
  for (final set in allSets) {
    final oldTweaks = WorkoutSet.tweaksFromJson(set.tweaks);
    final (newId, newTweaks) = ExerciseMigrationService.migrateExercise(
      set.exerciseId,
      oldTweaks,
      currentVersion,
      exerciseDatasetVersion,
    );
    
    if (newId != set.exerciseId || !_mapsEqual(newTweaks, oldTweaks)) {
      // Update the set
      await (update(workoutSets)..where((s) => s.id.equals(set.id))).write(
        WorkoutSetsCompanion(
          exerciseId: Value(newId),
          tweaks: Value(json.encode(newTweaks)),
        ),
      );
    }
  }
  
  // Update version
  await setCurrentExerciseVersion(exerciseDatasetVersion, 'migration');
  print('Migration complete');
}
```

##### 5b. **SharedPreferences Programs**
```dart
// In program_persistence_service.dart
Future<void> migratePrograms(int fromVersion) async {
  final programs = loadPrograms();
  bool anyChanges = false;
  
  for (final entry in programs.entries) {
    final programId = entry.key;
    final program = entry.value;
    
    final migratedWorkouts = program.workouts.map((workout) {
      final migratedSetGroups = workout.setGroups.map((setGroup) {
        final migratedSets = setGroup.sets.map((sets) {
          if (sets.ex == null) return sets;
          
          final (newId, newTweaks) = ExerciseMigrationService.migrateExercise(
            sets.ex!.id,
            sets.tweakOptions,
            fromVersion,
            exerciseDatasetVersion,
          );
          
          // Look up new exercise
          final newEx = exes.cast<Ex?>().firstWhere(
            (e) => e?.id == newId,
            orElse: () => null,
          );
          
          if (newEx?.id != sets.ex!.id || !_mapsEqual(newTweaks, sets.tweakOptions)) {
            anyChanges = true;
            return sets.copyWith(ex: newEx, tweakOptions: newTweaks);
          }
          return sets;
        }).toList();
        
        return SetGroup(migratedSets);
      }).toList();
      
      return workout.copyWith(setGroups: migratedSetGroups);
    }).toList();
    
    if (anyChanges) {
      await saveProgram(programId, program.copyWith(workouts: migratedWorkouts));
    }
  }
  
  if (anyChanges) {
    await setCurrentExerciseVersion(exerciseDatasetVersion);
  }
}
```

##### 5c. **URL Migration**
URLs are **read-only** and cannot be migrated retroactively. Strategy:
- **Best effort**: Parse old URL format, apply migrations at parse time
- **Graceful degradation**: If exercise ID not found, show error or redirect to exercise list
- **User notification**: "This link uses an old exercise format" message

```dart
// In exercises_screen.dart
void _initializeFromUrl() {
  if (widget.exerciseId == null) return;
  
  var exerciseId = widget.exerciseId!;
  var tweakOptions = widget.tweakOptions ?? {};
  
  // Try to migrate from URL
  // We don't know the original version, so try migrating from version 1
  if (!exes.any((ex) => ex.id == exerciseId)) {
    // Exercise not found—try migrating
    final (migratedId, migratedTweaks) = ExerciseMigrationService.migrateExercise(
      exerciseId,
      tweakOptions,
      1, // Assume oldest version
      exerciseDatasetVersion,
    );
    
    if (exes.any((ex) => ex.id == migratedId)) {
      // Migration successful!
      exerciseId = migratedId;
      tweakOptions = migratedTweaks;
      
      // Optional: Show user notification
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Exercise link updated to current format')),
      );
    }
  }
  
  // Continue with normal flow...
}
```

### Migration Workflow

1. **Increment Version**: Change `exerciseDatasetVersion` in `exercises.dart`
2. **Define Migration**: Add migration rule to `exerciseMigrations` list
3. **Test**: Verify migration logic with unit tests
4. **Deploy**: On app start, migrations run automatically
5. **Monitor**: Check for migration errors in logs/crash reports

### User Experience

**Automatic & Transparent**: 
- Migrations happen silently on first launch after update
- No user action required
- Progress logged to console for debugging

**Error Handling**:
- If migration fails, show error dialog with details
- Allow user to continue with old data, but recommend them taking a backup to try again. or reset data
- Log migration failures for bug reports

**Performance**:
- Drift migrations: Single transaction, fast even with 1000s of sets
- SharedPreferences: In-memory migration, negligible overhead
- Only runs once per version bump

## Open Questions & Decisions Needed

### 1. **Split Migration Complexity** ✅ **RESOLVED**
The `SplitExerciseMigration` was tricky because the new exercise ID depends on the tweak value:

```dart
(oldId: "squat", tweaks: {depth: "full"}) → (newId: "full squat", tweaks: {})
```

**Solution**: We implemented the unified `migrate()` method that processes exercise ID + tweaks together as one unit. This elegantly handles all migration types including complex split scenarios.

---

### 2. **Migration History Tracking**
Should we track which specific migrations have been applied?

**Current approach**: Only store current version number
**Alternative**: Store list of applied migration IDs

**Recommendation**: Keep current approach (version number only) for simplicity. Migration definitions are tied to version ranges.

---

### 3. **Rollback Support**
Should we support rolling back migrations (downgrading)?

**Recommendation**: No—rollbacks add significant complexity and are rarely needed. If user downgrades app version, we show error message: "Please update to the latest version."

---

### 4. **Bulk Migration vs. Lazy Migration**
Should we migrate all data upfront or lazily when accessed?

**Current proposal**: Bulk migration at app start
**Alternative**: Migrate on-demand when data is loaded

**Recommendation**: Bulk migration for:
- ✅ Simple version checking (one source of truth)
- ✅ Predictable performance (one-time cost)
- ✅ Complete data consistency
- ❌ Slightly slower first launch after update (acceptable tradeoff)

---

### 5. **URL Migration Strategy**
URLs can't be retroactively updated. How aggressive should we be with migration attempts?

**Options**:
- A) Always attempt migration from v1 → current (may cause false positives)
- B) Store migration metadata in URL (e.g., `?v=3`) to know source version
- C) Accept that old URLs may break, show helpful error message

**Recommendation**: Option A with validation—attempt migration, but verify resulting exercise + tweaks are valid before using.

---

### 6. **Migration Testing**
How do we test migrations before deploying?

**Recommendations**:
- Unit tests for each migration type with sample data
- Integration tests that load old JSON and verify migration correctness
- Manual testing with exported real user data (anonymized)
- Consider a "dry run" mode that reports what would change without applying

---

## Implementation Phases

### Phase 1: Foundation (Required Before First Migration)
- [ ] Implement `ExerciseMigration` abstract class and concrete types
- [ ] Create `ExerciseMigrationService` with migration logic
- [ ] Add migration tests
- [ ] Update version checking to call migration logic
- [ ] Test with dummy migrations

### Phase 2: Integration (Per-Persistence Layer)
- [ ] Implement Drift database migration in `_checkExerciseMigration()`
- [ ] Implement SharedPreferences programs migration
- [ ] Add URL migration attempt in `ExercisesScreen`

### Phase 3: First Real Migration
- [ ] Define specific migration (rename/merge/split)
- [ ] Increment `exerciseDatasetVersion`
- [ ] Test thoroughly with real data
- [ ] Deploy and monitor

### Phase 4: Enhancements (Optional)
- [ ] Add migration dry-run/preview mode
- [ ] Add user notification for successful migrations
- [ ] Add telemetry to track migration success rates
- [ ] Consider tweak-specific exercise exclusions

## Example Migration Scenarios

### Scenario 1: Rename for Consistency
```dart
// Version 1 → 2: Standardize bench press naming
RenameExerciseMigration(1, 2, {
  'bench press (barbell)': 'barbell bench press',
  'bench press (dumbbell)': 'dumbbell bench press',
}),
```

### Scenario 2: Merge Equipment Variations
```dart
// Version 2 → 3: Consolidate leg curl variations
MergeExerciseMigration(
  2, 3,
  newId: 'leg curl',
  tweakName: 'equipment',
  idToTweakValue: {
    'seated leg curl': 'machine (seated)',
    'lying leg curl': 'machine (lying)',
    'standing leg curl': 'machine (standing)',
  },
),
```

### Scenario 3: Split ROM Variations
```dart
// Version 3 → 4: Split squat by depth
SplitExerciseMigration(
  3, 4,
  oldId: 'squat',
  tweakName: 'depth',
  tweakValueToNewId: {
    'quarter': 'quarter squat',
    'half': 'half squat',
    'parallel': 'squat',
    'atg': 'deep squat',
  },
  fallbackId: 'squat',
),
```

## Conclusion

This migration system provides a **structured, versioned, and automated** approach to handling exercise definition changes. By centralizing migration logic and applying it consistently across all persistence layers, we ensure data integrity while maintaining flexibility to evolve the exercise library over time.

**Key Principles**:
- Migrations are code, versioned with the app
- Automatic execution, transparent to users
- Fail-safe with error reporting
- Testable and reviewable
- Forward-only (no rollbacks needed)

**Next Step**: Implement Phase 1 (foundation) before making any breaking changes to exercise definitions.
