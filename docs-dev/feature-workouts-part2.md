# Gym mode part 2

Today, the ExerciseDetailsDialog is used in 3 places:

- "log sets", after selecting an exercise (mobile only)
- exercise browser -> select an exercise (mobile, desktop, tablet)
- workout programmer -> expand a set (desktop, tablet)

in exercise browser:
    - exercisedetailsDialog desktop -> put tweaks in columns. we will probably run out of horizontal space, unless screen is huge.
    - huge wide desktop -> keep 3 column layout
    - normal desktop and tablet -> 2 column layout
    in workout programmer, we have max horizontal space, so def. use columns
    - mobile portrait -> not much can be done (it's already full width)
    - mobile landscape -> resize dialog, also here put tweaks in columns
      actually in both mobile cases: collapse tweaks (just show currently selected option)
      same for "log sets"



