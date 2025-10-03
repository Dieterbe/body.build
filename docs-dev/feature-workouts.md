# Workouts Feature

## Overview

The Body.build mobile app includes a workout feature that allows users to track
their training sessions while at the gym, logging sets
(along with their exercise, tweaks, weight, reps, RIR, and comments)

Note: it could technically work on web and other platforms, but we don't want the support burden.
So we tell the user to use the mobile app on a phone or tablet to use these features.

## Key Features

- Start workout sessions with automatic timestamp recording
- After starting a workout, display a subtle duration stopwatch, showing elapsed wallclock time since the creation of the workout
- After adding a set, display a subtle rest stopwatch, showing elapsed wallclock time since the last set finished
- Log individual sets with detailed exercise information
- Add notes and comments for each workout session
- Provide access to detailed exercise search and information,
  similar to the workout programmer and exercise library

## Implementation details

* offline-only. no network usage.
* use drift as database. tweaks are stored as json
* workout end datetime is null for active workouts
* pages:
  - /workouts/ displays all workouts
  - /workouts/:id displays a specific workout (either the current active one, or a past one)
  - /workout shows the currently active workout, creating a new one if needed

## Mobile exercise selector
user input (all optional):
* text search
* selection dropdown to involve one or more muscles (Program Groups)

option tiles:
* display exercise name, ratings and tweaks (similar to the "Add set For" dialog)
* display muscle recruitments of all muscles with recruitment > 0.5, this visualization should be clear and concise

## Future Enhancements

- **Workout Templates**: Pre-defined workout structures and those made with the programmer
- **analytics** (performance progress, 1RM estimations, comparisons which modifiers work better, etc)
- **Export Functionality**: Data export for external analysis
- **Plate Calculator**: Weight calculation assistance
- **Background Sync**: Cloud backup when network available
- **Integration APIs**: Connect with fitness tracking services
