# Exercise search

## Status before

Exercises have an ID field.
Exercises are shown by their ID (and sometimes also by their tweaks)
Searching only considers the ID field, which is quite limiting and may result in not finding certain exercises.
(see below for examples)

## After

The ID's of exercises function are mostly fine for presentation to humans as well.  In some places we also show the active tweaks to disambiguate.  In the future, we may want to automatically construct a "virtual name" by combining the ID and cleanly integrating active tweak values.

The main thing we want to improve is search. Essentially we need more keywords to match relevant exercises, even if they are not part of the ID.

### Exercise aliases

We can define aliases for exercises. These aliases are used for search only.

examples:
- hamstring curl -> leg curl
- quad extension -> leg extension
- deltoid press -> shoulder press
- wrist curl -> wrist extension
- wrist reverse curl -> wrist flexion
- RDL -> romanian deadlift
- BSQ -> barbell squat (with bar on the back, but just retrieving the barbell squat should be enough)
- press-up -> push-up
- prone -> lying

### Hyphen handling

pull up -> pull-up
push up -> push-up
pull-down -> pulldown
push-down -> pushdown

### Searching into tweak keys

e.g. "deficit"

### Searching into tweak values and their descriptions

The following values can be found by looking at tweak option values and their descriptions:
- hammer (neutral grip description)
- flexion row (description for dynamic spine)
- chin up / chin-up (description for supinated grip pull-up)
- close grip (description for narrow grip)

incline, decline, flat (found in bench angle option descriptions)

### Implementation

We can support all the above by doing the following:

- add an optional alias field to exercises. Any exercise can have 0,1 or more aliases

For any given query:
- replace '-' by space.
- each space-separated word needs to be found in the exercise ID, exercise alias, tweak name, tweak option key, or tweak option description


