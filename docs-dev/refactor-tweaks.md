# refactor cues and modifiers into "tweaks"

## Status until now

2 concepts: Cues vs Modifiers

### Modifiers
* "not contentious" aka well established effects
* have N options which change volume assignments, and a default (but some of these are also on/off e.g. ankle dorsiflexion)
* normally different ways to execute an exercise, but exceptionally some are "observational" (e.g. front leg movement during squats)

### Cues
* "contentious": app does not assume any effects on exercise stats
* options are only on/off. 
* a bit of a misleading name: our cues are real "actions" that actively execute the exercise differently, whereas cues are generally thought of to be mainly in your mind (though they do manifest physically), we don't really have such cues today.

# Refactor

* We want to support cues that have multiple options. e.g. ROM:
    - full ROM
    - full ROM with extra time at stretch
    - full ROM with extra time at contraction
    - lengthened partials (note requires an exercise which loads under stretch)
    - shortened partials (note: requires an exercise which loads at the shortest)
    - mid-range partials (note: requires an exercise which loads at the mid-range)

Therefore, cues and modifiers will get the same datastructure to describe their options.
In case the list of values is binary ("on/off"), let's not resort to handling this in a special way in the code or data. By keeping it the same we keep code and data simple.  Although in the UI we may optimize this later (see "Future work").

"Contentiousness" can be elaborated in comments or made clear via their encoded effects which can be visualized.
Clearly, cues and modifiers can be merged into one concept, called "tweaks", to cover both deliberate and observed differences in movement, and whether they are contentious in their effects or not. This will make the app simpler: from data to code and UI, to explaining things.

If we ever do want to introduce "real" cues (mind driven), then we can e.g. just put "cue" in the name.

## Future work
- if options are only on/off, and individual items don't have further comments, then we can use a simple toggle button in UI