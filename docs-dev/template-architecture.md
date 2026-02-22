# Template Architecture: Program vs Per-Day Design

Below follows our agent's explanation.  I (Dieter) am not fully convinced.
Let's go a head with what our agent said, but at some point we could try a prompt like this:

```
Can we try the refactor to hold a whole ProgramState inside of a WorkoutTemplate? Here's why I think your concerns are overblown:
- identifying individual days within a blob is trivial. it doesn't require any DB/schema changes. Only at runtime do we need to select the correct day out of the json. this is only a few lines of code. I propose to do this via the workout name field. This does mean that workout names need to be unique, which needs to be validated when saving a workout in the editor
- for TemplatePickerSheet, this is where we can expand the templates into the individual days/workouts and keep using the same TemplateCard as before
- in _useAsTemplate this concern seems oveblown
```

## The Mismatch (and why it's correct)

The system has two different granularities for workout data:

1. **ProgramExport (interchange format)**: Contains a full `ProgramState` with multiple workout days
2. **WorkoutTemplate (mobile app)**: Contains a single `programmer.Workout` (one day)

This appears to be a mismatch, but it's actually the correct design boundary.

## Why Export Holds a Full Program

- **Unit of sharing**: Users create and share complete programs (e.g., "PPL 6-day split", "5/3/1 BBB")
- **Coherent versioning**: Exercise dataset version applies to the entire program
- **Metadata preservation**: Program name, authorship, builtin flag stay together
- **Natural authoring**: Programs are designed as cohesive units, not isolated days

## Why Templates Are Per-Day

- **Unit of execution**: The mobile app logs one workout at a time, always a single day
- **Simple selection**: User picks one template → starts one workout
- **Flat persistence**: DB stores one row per template, simple CRUD operations
- **Reusability**: Users can mix days from different programs freely
- **Past workout → template**: A logged workout is already a single day, no wrapping needed

## The Conversion Boundary

**Import is the one-way explosion point:**

```dart
ProgramExport (N days) 
  → ProgramImportService.importProgram()
  → ProgramState.toTemplates() 
  → N × WorkoutTemplate (persisted individually)
```

After import, the program-level grouping is lost except for name prefixes (`"PPL / Day A"`, `"PPL / Day B"`).

## Alternative: Templates Hold Full Programs

### What would improve:
- Import service slightly simpler (no explosion, store blob directly)
- Seeding builtins simpler (store `demo1` directly)

### What would get worse:
- **DB schema**: Large blobs, need compound keys `(programId, dayIndex)` instead of simple `templateId`
- **Persistence service**: Complex "get day X from program Y" queries
- **Template picker UI**: Two-level navigation (pick program → pick day), more complex
- **Template card**: Can't show per-day details (set count, exercise count, recruitment chart)
- **Start workout**: Needs `(programId, dayIndex)` tuple instead of single `templateId`
- **Past workout → template**: Must wrap single logged workout in synthetic ProgramState with one day (very awkward)

**Score: 2 things simpler, 6 things worse.**

## Verdict

Keep the current design. The explosion from program → per-day templates is the right boundary. Everything downstream only thinks about single days, which matches how the mobile app actually works.

## Future Enhancement (Optional)

If visual grouping becomes important, add an optional `programName` field to `WorkoutTemplate`:

```dart
const factory WorkoutTemplate({
  required String id,
  String? programName,  // e.g., "PPL"
  // ... rest unchanged
});
```

Then group templates by `programName` in the picker UI. No architectural change needed.
