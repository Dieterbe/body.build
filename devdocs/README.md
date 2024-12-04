
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
* it's because we except certain commonalities between different data files, ui files etc, so putting them closer together may help with diffing files, copying them etc on the CLI



### TODO: incorporate eccentric overloading.it's recommended for all

 if you have machines or weight-releasers available to implement eccentric overloading, it’s generally good to do so. If not, there are still several ways you can implement eccentric overloading in your training.1. Bilaterally performing the concentric phase of an exercise, while unilaterally performing the eccentric. For example, during a machine leg extension or lying leg curl you can lift up the pad with both legs and then lower it under control with just one leg.2. Using momentum to aid the concentric phase while controlling the eccentric. This can be used during, for example, calf jumps, butterfly lateral raises, step-ups, pulldowns and seated cable rows. (See the exercise selection course module for the exercise library with detailed exercise descriptions.)3. Biomechanically decreasing your strength during the eccentric phase. For example, you could switch from a supinated to a pronated grip during chin-ups. Zottman curls are an exercise that inherently have eccentric overloading. Strategy 2 is generally by far the most practical to implement

 

TODO: look throughout the course modules about injury management and how it affects program.
for sure:
- eccentric overloading
pretty sure:
- higher rep
- more exercise variety
- KAATSU