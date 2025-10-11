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

### Searching into tweak values and part of their descriptions

The following values can be found by looking at tweak option values and their descriptions:
- hammer (neutral grip description)
- flexion row (description for dynamic spine)
- chin up / chin-up (description for supinated grip pull-up)
- close grip (description for narrow grip)
- overhand / underhand (description for pronated/supinated grips)

incline, decline, flat (found in bench angle option descriptions)

Important: we only index the words coming after any occurrence of "aka" in the description. Otherwise it would be too much text and may lead to noise.

Note: The search is case-insensitive and normalizes all text to lowercase.

### Implementation

We support all the above by doing the following:

- Each exercise has an optional `searchAliases` field (list of strings). Any exercise can have 0, 1 or more aliases.
- Each tweak option description can include "aka ..." to add searchable terms.

For any given query:
- Convert to lowercase (search is case-insensitive)
- Replace '-' with space (so "pull-up" matches "pull up" and vice versa)
- Split by whitespace (any amount of spaces/tabs)
- Each space-separated word must be found (prefix match) in:
  - Exercise ID
  - Exercise searchAliases
  - Tweak name
  - Tweak option key
  - Words after "aka " in tweak option descriptions


### Design Decision: Prefix Match vs Contains

I went back and forth a bit between these two options:
* prefix match:
  - "chin up" won't match "chinup", therefore needs some aliases on such exercises
  - More precise, avoids false positives
* "contains":
  - CON: "chin" matches "machine" (in exercise ID)
  - CON: ("row" matches "growth" although we stopped searching into tweak descriptions) 
  - PRO: no "chinup", "pullup", "pushup", etc aliases needed

We went for the prefix match with a few aliases for now.

Note: Technically some search terms are specific to only certain tweak options (e.g. "chin-up" only applies to supinated grip pull-ups, BSQ is only squats with a bar on the back, etc), but the results are at this time always exercises without any tweaks set, so that's OK for now.