
## file organization

apply DRY at filename level. e.g. if it's in the `<feature>/page` directory, the file doesn't need to have "feature" or "page" in its name (but should have Page or Screen in its dart class)

data:
* ephemeral state (riverpod), persisted state (riverpod) and hardcoded data (and supporting enums)
page:
* main screens and huge widgets that make up large parts of a page
model:
* domain models


why e.g. data/programmer and not programmer/data - wouldn't that make more sense?
* because we also have ui/programmer and not programmer/ui, and we want to leave room for files in ui that are not specific to a feature -> nope, could go into core/ui
* it's because we accept certain commonalities between different data files, ui files etc, so putting them closer together may help with diffing files, copying them etc on the CLI

## things to do still

### incorporate eccentric overloading

ecc overloading is good for all. can be done with:
- certain machines, weight-releasers
- bilateral concentrics, unilateral eccentric. e.g. many machines like leg curs, leg extensions, calf raises
- using momentum to aid the heavier concentric. e.g. calf jumps, butterfly lateral raises, step-ups, pulldowns, seated cable rows
- biomechanically decreasing strength during eccentric. e.g. switch from a supinated to a pronated grip during chin-ups. Zottman curls has inherent eccentric overloading. 

### excerpt from a q&a session re advanced techniques

- combo sets, unilateral, eccentric overloading: do all of it as much as possible?
- in principle yes. in practice it's hard because:
    - e.g. eccentric overloading bench press needs spotter
    - ecc overloading is hard to measure progress
        - with concentric: did you get it up or not, for eccentric, speed is very relevant and not tightly controlled
        - more variance in how you do it. e.g. angles for lateral raise
- therefore, tip:
    - do it for last set or all sets after the first. use the first ones for measurements


also, per course : ecc overloading -> more fatigue, reduce volume accordingly


### look throughout the course modules about injury management and how it affects program.

for sure:
- eccentric overloading
pretty sure:
- higher rep
- more exercise variety
- KAATSU
