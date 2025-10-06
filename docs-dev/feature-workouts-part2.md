# Gym mode part 2

## Issue: there are many exercise tweaks, and we also want to keep the recruitments on-display while going through all tweaks to see their effect

We show the tweaks in 3 different locations: logset sheet, workout programmer, and exercise browser

### the logset sheet

mobile only: small portrait layout. landscape not supported
using LogSetSheet which uses ConfigureTweakSmall and ConfigureTweakLarge directly
solution:
* detail toggle (done)
* scroll the ConfigureTweak widgets, keeping recruitment visible (done)

### in the workout programmer

desktop, tablet: using ExerciseDetailsDialog
we can't scroll cause the whole page as a whole scrolls already.
but we can do:
- detail toggle (done)
- wrap columns next to each other, making recruitments almost always visible (done)

### the exercise browser->select an exercise

using ExerciseDetailsDialog means we can't add scrolling (see above)

* mobile: 1 column layout + model, which is narrow and portrait.
potential solution:
- detail toggle (done)
- switch to custom widget to allow scrolling (TODO)

* tablet: 2 pane layout + modal, which does not get very wide. 
potential solution:
- detail toggle (done)
- allow dialog to take up bigger portion of screen (TODO)
- switch to custom widget to allow scrolling (TODO)

* desktop: 3 pane layout: too narrow portrait
  potential solution:
  - detail toggle (done)
  - make middle pane more narrow to give more space
  - adopt tablet layout much quicker (dialog rather than 3rd pane)
  - switch to custom widget to allow scrolling (TODO)


