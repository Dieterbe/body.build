# Persistence

we use 2 methods: shared prefs and drift

## Shared Preferences
used for workout programmer, personal profile, meal plan stuff, app settings
limited quota and API, but good enough for our needs.

- `SetupPersistenceService` and `ProgramPersistenceService` reference exercises and therefore track exercise dataset version
- If version mismatch detected, an exception is thrown (migration needed)


## Drift (sqlite)

used for workouts on mobile
Not used on web because:
* we added the functionality later
* bundle size
* may cause some issues on safari (?)

- `ExerciseVersions` table tracks the current exercise dataset version
- Version is checked in `beforeOpen` migration hook
- On database creation, version is set to current `exerciseDatasetVersion`
- If version mismatch detected, an exception is thrown (migration needed)


## Exercise Dataset Version

The `exerciseDatasetVersion` constant (defined in `/lib/data/programmer/exercises.dart`) tracks breaking changes to:
- Exercise IDs
- Exercise tweaks/modifiers

**Current version: 1**

When incrementing the version:
1. Update `exerciseDatasetVersion` constant in `exercises.dart`
2. Implement migration logic in both Drift and SharedPreferences services
3. Test migration paths thoroughly


## Future plans

Exercise dataset versioning is now implemented for both persistence methods.
This will allow us to update exercise definitions (ID's and tweaks)
Future work may include:
- Implementing actual migration logic (currently just throws exception)
- Potentially consolidating to a single persistence method
- Extracting exercise library into separate project/repo with its own versioning (and migration logic?)