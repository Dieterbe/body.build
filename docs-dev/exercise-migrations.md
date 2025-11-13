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
may use a previous version and we don't know exactly what version they use. So this case is tricker but our heuristic described below should take us far enough.

### Implementation

* For latest code, see actual code in `exercise_migration_service.dart`, `exercise_migrations.dart`, etc.
* Future refinement: we need to loop over all exercise references, and over all migrations. Right now the former
  is the outher loop, and the latter the inner loop. But since we track database version per-datastore (not per exercise reference), perhaps we should switch them around. This way, in case of any failure part-way, we can at least migrate
  the whole dataset to an intermediate version rather than failing everything. 
*  No detailed migrations history tracking. just a version marker. Rollback not needed

**URL Migration**

Strategy:
- try to load exercise ID and tweaks as specified. If found, done.
- If not found, run it through all migrations and try again
- if still not found: inform user that it is not found and link to exercise list.

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

## Implementation Phases

### Phase 1: Foundation (Required Before First Migration)
- [x] Implement `ExerciseMigration` abstract class and concrete types
- [x] Create `ExerciseMigrationService` with migration logic
- [x] Add migration tests
- [x] Update version checking to call migration logic
- [x] Test with dummy migrations

### Phase 2: Integration (Per-Persistence Layer)
- [x] Implement Drift database migration in `_checkExerciseMigration()`
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

## Conclusion

This migration system provides a **structured, versioned, and automated** approach to handling exercise definition changes. By centralizing migration logic and applying it consistently across all persistence layers, we ensure data integrity while maintaining flexibility to evolve the exercise library over time.

**Key Principles**:
- Migrations are code, versioned with the app
- Automatic execution, transparent to users
- Fail-safe with error reporting
- Testable and reviewable
- Forward-only (no rollbacks needed)

**Next Step**: Implement Phase 1 (foundation) before making any breaking changes to exercise definitions.
