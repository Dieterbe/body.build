
## file organization

apply DRY at filename level. e.g. if it's in the `<feature>/page` directory, the file doesn't need to have "feature" or "page" in its name (but should have Page or Screen in its dart class)

data:
* ephemeral state (riverpod) and hardcoded data (and supporting enums)
page:
* main screens and huge widgets that make up large parts of a page
model:
* domain models


why e.g. data/programmer and not programmer/data - wouldn't that make more sense?
* because we also have ui/programmer and not programmer/ui, and we want to leave room for files in ui that are not specific to a feature -> nope, could go into core/ui
* it's because we except certain commonalities between different data files, ui files etc, so putting them closer together may help with diffing files, copying them etc on the CLI


TODO: look throughout the course modules about injury management and how it affects program.
for sure:
- eccentric overloading
pretty sure:
- higher rep
- more exercise variety
- KAATSU