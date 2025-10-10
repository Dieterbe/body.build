# Persistence

we use 2 methods: shared prefs and drift

## Shared Preferences
used for workout programmer, personal profile, meal plan stuff.
limited quota and API, but good enough for our needs.


## Drift (sqlite)

used for workouts on mobile
Not used on web because:
* we added the functionality later
* bundle size
* may cause some issues on safari (?)


## Future plans

Inevitably, we'll need to come up with a way to migrate/upgrade exercise definitions (ID's and tweaks, etc)
Since we reference these in both SharedPrefs and in Drift, it may be advisable to just migrate to 1 persistence method at some point in the future.
Unless we can devise a more "exercise-library-native" way to do the migrations (perhaps tied to a project to separate out the library into its own project/repo)