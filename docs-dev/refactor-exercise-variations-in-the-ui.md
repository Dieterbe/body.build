# Refactor: simpler showing of exercise variations in the UI

## Status until now

We display *all* exercise variations in the ExerciseTileList UI, with the ability to expand/collapse them under
their "parent" exercise.
This UI is used on both:
- the exercises browser
- the exercise picker sheet when logging a set to a workout.

advantages:
1. main results immediatey show more breadth of exercise library
2. can search "into" an exercise, e.g. user might type "incline bench" and we could take them
   into the corresponding variation(s) directly, not showing the rest
3. we wouldn't want to show all variations as distinct search hits, that gets excessive
   due to many small tweaks like bench angles etc

downsides:
1. when you select an exercise, you can change all tweaks anyway
   (and we will have more room to do them justice, such as visualize their recruitment effects)
2. for different variations, we would ideally also show their different
   recruitments here, but space is already cramped.
3. navigation/selection behavior is more complicated and a bit broken on desktop/web, e.g.
   selecting different variations doesn't update the UI properly, it unselects
4. the dropdown button needs a lot of space on mobile
5. Especially since the big "tweaks" refactor, there's too many variations due to basic stuff like grip squeeze, ROM tweaks etc. (x18). Bench press has 108 variations now. It doesn't make sense to scroll through the combinatorial "explosion" of all of them.


## New solution

* remove the collapsing/expansion stuff.
* on the exercise tiles in the ExerciseTileList, show list of all the *names* of all the tweaks (but not all their values)
* show all the rating stars (that can be achieved for this given exercise)
