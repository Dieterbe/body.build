# Exercise library

"Exercises" are not the rigid, precisely-defined entities like they are in other applications.
Exercises can significantly shift which muscles are recruited, or in which modality, based on various factors such as form tweaks, equipment used, etc.
Discourse (programs, ratings, commentary) may apply to only certain forms (whether explicit or implied).
Activation can also differ based on the eccentric component, unilaterality, ROM, etc.
Sometimes the name of an exercise implies a certain piece of equipment or execution style. (e.g. a "chin-up" is considered a different exercise to a "pull-up" whereas a cable row can comprise all kinds of hand positions, a butterfly lateral raise is bilateral, a side-lying lateral raise is not, etc)

This raises the question: Which alterations constitute different exercises vs a different variant of the same exercise?
Trying to get too strict / consistent is ultimately fruitless. Reality can't be modeled that cleanly.

And much can be worked around anyway:
* exercise search UI's can take into account the exercise name as well as its tweaks
* when presenting any chosen exercise in the UI, we can always either show the exercise name/id along with its tweaks, or "promote" tweak configuration into the name.
* inevitably, people will want to switch to alternative "exercises", or compare/corelate analysis across them (such as "how does my DB bench compare to my BB incline bench").  We'll need to support that, regardless of whether "it's a different exercise" or "it's the same exercise with different tweaks". But sometimes a user may not even want to compare the same exercise with different tweaks, so this doesn't mean much.

A place where the difference really matters is in the exercise browser and workout programmer: it may not always be clear when to change the exercise vs when to change tweaks, but they'll quickly get used to that I think. But we want to reasonably match how people usually think of what constitutes an exercise

That said, the best we can do is be as consistent as pragmatically possible, and document our overall approach.
Generally we do try to apply a consistent approach across the whole library, as documented below.

eventually we'll probably need to build a migrations tool to support rewriting saved data

## Current implementation

### Differences within the same exercise

These are all implemented via a simple concept of "tweaks":

- deficit and ROM
- observed execution varations
- explicit differences in exercise technique
- future: cues
- grip position & row cable attachments: there's lots of variations and many don't really make much difference (or don't conflict with other tweaks), so better within same exercise as tweaks, otherwise would lead to too many different exercises. also definitely well known to be the same exercise

## What makes exercises different

- powerlift or normal. While this could in principle also just be a "tweak", the powerlift style often has multiple ramifications in terms of rest time, choice of accessoires (mainly for the squat: less choice in bars / bar position), ROM (usually as little as possible), and technique ("whatever gets the bar up"), so it makes life easier to classify them separately.
- seated vs standing vs lying etc. they're usually thought of as different, though being able to compare performance across the flavors seems useful. sometimes lying has ramifications (unilateral lateral raises) or in terms of recruitment (e.g. lying vs seated ham curls), which in principle could also be housed within 1 exercise.
- equipment
  * many exercise definitions that mainly differ in equipment, which leads to some redundancy in code (could be refactored using generative loops)
  * if different equipment for same exercise needs custom per-equipment VA or other adjustments, it involves more implementation complexity
    (e.g. only barbell squats should have tweak for bar position [1], bulgarian split squats work forearms a bit more when using DB's, and some calf raises) often ratings are specific to equipment (e.g. barbell bench press) - would affect Assignment merging, and making tweaks and ratings conditional based on equipment [1]
  * even for a given equipment for an exercise, we want to differentiate between different smith angles, machine curves,etc -> would be nicer maybe to not change exercise for this? could be nice if this was all 1 system?
  * often equipment is fairly well ingrained to imply an exercise, e.g. seated leg curl. though as discussed above, this doesn't really matter
  we could transition to a rule "if equipment doesn't matter for VA/tweaks, than do it in-exercise" [1]
  * for some exercises, this becomes a bit obnoxious. e.g. preacher curls can use many different bars, front raises can be done with barbell, dumbbell, ez-bar, cables, plate, kettlebell, etc. and some exercises only differ in how you apply the load (e.g. also donkey calf raises)
  EXCEPTION: i implemented front raises as "everything in 1 exercises" to avoid combinatioral explosion
  
## TODO figure out in more detail:

- unilateral
  * sometimes dictated by machine (standing leg curl)
  * sometimes dictated by exercise name ("butterfly" lateral raise)
  * sometimes enables bigger ROM / resistenance curve (e.g. rear delt fly machine)
  * can go hand-in-hand with eccentric overloading



[1] in october 2025 we introduced the idea of "constraints" between tweaks (declaring incompatible options between different tweaks).  This could potentially be extended if we make equipment a tweak (e.g. a pallof press has sidestep tweaks that would be compatible with cable tower but not with elastic band equipment)