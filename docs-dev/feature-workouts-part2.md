# Gym mode part 2

## Issue: there were sometimes more exercise tweak options than what fits on a screen, and we also want to keep the recruitments on-display while going through all tweaks to see their effect

addressing this has led to quite the refactor.
We show the tweaks in 3 different locations: logset sheet, workout programmer, and exercise browser

changes made in all places:
- detail toggle for tweak configuration
- redesign large tweak configuration to be a bit more compact

### the logset sheet

mobile only: small portrait layout. landscape not supported
using LogSetSheet which uses ConfigureTweakSmall and ConfigureTweakLarge directly

changes made:
* scroll the ConfigureTweak widgets, keeping recruitment visible

### in the workout programmer

desktop, tablet: using ExerciseDetailsDialog
we can't scroll cause the whole page as a whole scrolls already.

changes made:
- wrap columns next to each other (aka "TweakGrid"), making recruitments almost always visible

### the exercise browser->select an exercise

#### mobile
1 column layout + modal, which is narrow and portrait.

changes made:
- scrollable tweaks

#### tablet
2 pane layout + modal, which does not get very wide. 

changes:

- allow dialog to take up bigger portion of screen
- scrollable TweakGrid

#### desktop
3 pane layout: too narrow portrait

changes:

  - make middle pane more narrow to give more space
  - fallback to 2 pane layout quicker (dialog rather than 3rd pane)
  - scrollable TweakGrid
