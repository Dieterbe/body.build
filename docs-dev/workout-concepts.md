# Workout Concepts

The word "workout" is used in two different contexts in the codebase. This document clarifies the distinction.

## Programmer Workout (desktop/web)

The workout programmer lets users design training programs on desktop/web. Its data model is abstract and compact:

- **`Workout`** (`lib/model/programmer/workout.dart`): a single training day. Contains a name (e.g. "day A"), a list of `SetGroup`s, and scheduling info (`timesPerPeriod`, `periodWeeks`).
- **`SetGroup`**: a group of exercises performed together (combo/super set). Contains a list of `Sets`.
- **`Sets`**: Defines the execution of an `Ex` with its `tweakOPtions`, with a given `intensity` level and a repeat count `n`

Key abstractions:
- `n` on `Sets` means "repeat this set N times within the group rotation". E.g. a `SetGroup([A(n=2), B(n=2)])` means: do A, B, A, B.
- `SetGroup` defines combo/super set ordering — all exercises in a group are interleaved.
- `intensity` is a programmer-level concept not carried into templates.

## Logged Workout & Template (mobile)

The mobile app tracks actual gym sessions and provides templates to pre-populate them. These models are flat and expanded: every individual set is tracked explicitly.

### Logged Workout

- **`Workout`** (`lib/model/workouts/workout.dart`): an actual gym session. Has `startTime`, nullable `endTime` (null = active), `notes`, and a flat list of `WorkoutSet`s.
- **`WorkoutSet`** (`lib/model/workouts/workout.dart`): a single logged set. Tracks `exerciseId`, `tweaks`, `weight`, `reps`, `rir` (reps in reserve), `comments`, `setOrder`, `timestamp`, and `completed` (false = planned, true = done).

A database constraint ensures at most one active workout (null `endTime`) exists at a time.

In the future, we should also be able to log things like "my left side was stronger/weaker than right", left/right separately (e.g. for split squats interleaved with other exercises)


### Template

- **`WorkoutTemplate`** (`lib/model/workouts/template.dart`): a reusable workout blueprint. Has a `name`, optional `description`, `isBuiltin` flag, and a flat ordered list of `TemplateSet`s.
- **`TemplateSet`** (`lib/model/workouts/template.dart`): a single planned set within a template. Tracks `exerciseId`, `tweaks`, and `setOrder`. No weight/reps/rir — those are filled in during the actual workout.

Templates are persisted in the drift database. When a user starts a workout from a template, each `TemplateSet` becomes a `WorkoutSet` with `completed=false`.

## What should the exchange format be?

we don't need workout-log specific details like date/time, RIR, etc => a "template" is the same as what the programmer uses.
if you want to use a past workout as a template, we do our best to extract the exercise sequence and structure.

## Conversion: Programmer → Template

A `ProgramState` contains multiple `Workout`s (days). Each programmer `Workout` maps to one `WorkoutTemplate`.

The expansion logic (see `_seedBuiltinTemplates` in `lib/data/workouts/workout_database.dart`) works as follows:

1. For each `SetGroup`, find the maximum `n` across its `Sets`.
2. Loop through rounds (0 to maxN-1).
3. Within each round, iterate through all `Sets` in order.
4. If the current round is less than the set's `n`, emit a `TemplateSet` for it.

Example: `SetGroup([A(n=2), B(n=3)])` expands to: A, B, A, B, B.

This interleaving matches how combo sets are actually performed in the gym.

Fields dropped during conversion:
- `intensity` — not relevant for templates
- `timesPerPeriod` / `periodWeeks` — scheduling info, not part of a single template

## Interchange Format (for export/import)

To transfer programs from the desktop programmer to the mobile app (and eventually back), we use a JSON interchange format. The programmer exports `ProgramState` JSON along with a version of the exercise dataset (`exerciseDatasetVersion` from `lib/data/dataset/exercise_versioning.dart`). The mobile app deserializes it, checks version compatibility, runs exercise migrations if needed, and converts each `Workout` into a `WorkoutTemplate` using the expansion logic above.
