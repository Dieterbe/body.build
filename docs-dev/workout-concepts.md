# Workout Concepts

The word "workout" is used in two different contexts in the codebase. This document clarifies the distinction.

## Programmer Workout (desktop/web)

The workout programmer lets users design training programs on desktop/web. Its data model is abstract and compact:

- **`Workout`** (`lib/model/programmer/workout.dart`): a single training day. Contains a name (e.g. "day A"), a list of `SetGroup`s, and scheduling info (`timesPerPeriod`, `periodWeeks`).
- **`SetGroup`**: a group of exercises performed together (combo/super set). Contains a list of `Sets`.
- **`Sets`**: Defines the execution of an `Ex` with its `tweakOptions`, with a given `intensity` level and a repeat count `n`

Key abstractions:
- `n` on `Sets` means "repeat this set N times within the group rotation". E.g. a `SetGroup([A(n=2), B(n=2)])` means: do A, B, A, B.
- `SetGroup` defines combo/super set ordering — all exercises in a group are interleaved.
- `intensity` is retained in the programmer `Workout` stored by templates, but not actually used when launching a workout from the template.

## Logged Workout & Template (mobile)

The mobile app tracks actual gym sessions and provides templates to pre-populate them. Logged workouts are flat and expanded: every individual set is tracked explicitly.

### Logged Workout

- **`Workout`** (`lib/model/workouts/workout.dart`): an actual gym session. Has `startTime`, nullable `endTime` (null = active), `notes`, and a flat list of `WorkoutSet`s.
- **`WorkoutSet`** (`lib/model/workouts/workout.dart`): a single logged set. Tracks `exerciseId`, `tweaks`, `weight`, `reps`, `rir` (reps in reserve), `comments`, `setOrder`, `timestamp`, and `completed` (false = planned, true = done).

A database constraint ensures at most one active workout (null `endTime`) exists at a time.

Note how the programmer's `Sets` uses an `intensity` prescription, whereas the `WorkoutSet` uses a weight (and reps and rir); because in the gym you don't work with intensities directly: you aim to choose a weight to match an intensity, and whether it does is demonstrated most accurately by considering the weight, reps, and rir.

In the future, we should also be able to log things like "my left side was stronger/weaker than right", left/right separately (e.g. for split squats interleaved with other exercises)


### Template

- **`WorkoutTemplate`** (`lib/model/workouts/workout_template.dart`): a reusable workout blueprint. Has a `name`, optional `description`, `isBuiltin` flag, and a programmer `Workout`.

Templates are persisted in the drift database. When a user starts a workout from a template, its `SetGroup`s are expanded into `WorkoutSet`s with `completed=false`.

## What should the exchange format for templates be?

we don't need workout-log specific details like date/time, etc.  A "template" is conceptually much closer to the workout prescribed by the programmer, so that's what we use.

However, there seem to be three cases here:

* a program (and therefore template) prescribes an intensity:
This does mean that the template contains "intensity" rather than weight and reps prescriptions (because the template should work regardless of how much progress you've made and therefore not assume specific weight/reps).  If you want/need weight/reps prescriptions when doing a workout, those should be derived by looking at past performance in recent workouts, compared against estimated strength curves, and can the best estimated weight can be shown while doing the new workout.  The app doesn't do this yet, but this can be implemented later. For now, this is done manually, and typically a bit roughly.

* a program prescribes a specific number of reps and RIR: the template would then copy them over.  This is currently not supported.  Also in this case, the right weight needs to be estimated based on past performance.

* a program prescribes a specific weight and reps: not implemented. I think this is not a very good system, but i think some programs do this.  It's needs to hardcode a pre-determined progression rate over time which may not match the individual.  This is currently not supported. Not sure how this would need to be built into templates.

If you want to use a past workout as a template, we do our best to extract the exercise sequence and structure; though we can't reconstruct a fully polished workout as it would have been prescribed via the programmer.

## Conversion: Template → Logged Workout

A `WorkoutTemplate` stores a programmer `Workout`. Starting it creates flat `WorkoutSet`s.

The expansion logic (see `WorkoutTemplate.toFlatSets` in `lib/model/workouts/workout_template.dart`) works as follows:

1. For each `SetGroup`, find the maximum `n` across its `Sets`.
2. Loop through rounds (0 to maxN-1).
3. Within each round, iterate through all `Sets` in order.
4. If the current round is less than the set's `n`, emit an exercise/tweak entry for it.

Example: `SetGroup([A(n=2), B(n=3)])` expands to: A, B, A, B, B.

This interleaving matches how combo sets are actually performed in the gym.

## Interchange Format (for export/import)

To transfer programs from the desktop programmer to the mobile app (and eventually back), we use a JSON interchange format. The programmer exports `ProgramExport`, which wraps `ProgramState` with the exercise dataset version (`exerciseDatasetVersion` from `lib/data/dataset/exercise_versioning.dart`). The mobile app deserializes it, checks version compatibility, runs exercise migrations if needed, and converts each `Workout` into a `WorkoutTemplate` without expanding it.
