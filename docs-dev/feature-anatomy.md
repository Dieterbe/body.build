# Anatomy

Allows exploring muscles, joint articulations (movements), and the relations between them.
Probably less relevant to most users, but useful for die-hards.
It is a bit crude (e.g. simplified graphs of how moment arms/strength changes over muscle lengths)

## Goals & non-goals
1) an easier way for a human to recall information (e.g. which muscles cause shoulder extension again?) etc.

2) No longer a goal: deduce automatically which muscles are involved in a given exercise, based on:
- codified muscle anatomy and how those muscles (or their heads / fiber regions) contribute to specific articulations, where they have most leverage, where they reach insufficiency, over which angles they work, etc
- codified listing of exercise as a combination of simultaneous articulations over a set of ranges of motion with a given resistance angle & curve

in practice, this is quite tough though. as you need to find a way to express resistance and force curves, interpolate between them, and do it based on anecdotal evidence and incomplete information which uses relative term like "weak", "most strong" etc (see anatomy module in the course), and such information is often observed based on exercises, so trying to tie back a muscle-exercise association to muscle-articulation and then infer the muscle-exercise one, is overcomplicating.  

it's further complicated by certain muscles having multiple heads, some having no heads but various regions etc.
so I've pretty much given up on that.
The app now simply uses manually curated recruitment levels for given muscle-exercise combinations.  This is simply based on scientific evidence and coach experience.   Though the anatomy
stuff is still useful for understanding, but not as primary datasource in the algorithms.

## multi-tier muscles
sometimes it's not clear what is a muscle vs what is a head. e.g. quadriceps,
* deltoids separate muscles or heads?
* calves 2 muscles, one of which has 2 heads
* spinal erectors.
* traps, one has multi regions, and then there's multiple muscles

### what do we actually want?

- in the muscles screen, bundle muscles by their group name. they can be:
  - multi-head muscles (e.g. traps, calves, elbow flexors have at least 1 multi head muscle)
  - single-head muscles (e.g. deltoids)
- in the muscle screen, i want to see functions for all members of a group, but i also want to hone in on individual muscles

### solutions?

This problem has been solved in the code and in the UI. I don't remember exactly how, but it was probably either M:N mappings or 3-tier structure.

#### M:N mappings

do we need to support M:N mappings? i don't think so. maybe later, though!
implementation ideas:
1) separate collections structures which include overlapping sets of muscles
2) OR: add N "tags" or 1-N "collection" (enum) field to singlehead and multihead muscles. this way we can iterate over the muscles directly,
   but we'd need to somehow get a list of all defined muscles, still..

in the UI we could then show the collections, and don't show any muscles that are already shown as part of a collection, or just create a "collection" for everything we want to render. this kindof makes sense, to separate out the UI listing from the anatomical model, and give each their structure

2) seems like my favorite idea for now. but what if we want subgroups? like 'forearm' and 'wrist' ? i guess we can just make those..
what if distinct muscles in the same group share a bunch of functions? let's implement DRY at the anatomy level, and keep the categories for .. well categorizatian

#### 3-tier structure

* should we just allow any muscle to have muscle-children? then what about mandatory/optional args? we would want to be able to inherit properties
  for children, some fields would be optional, but for main one, should be mandatory?
  let's try these 3 tiers: muscle-muscle-head. in the future, maybe we can go to muscle-muscle-muscle
  actually no, we couldn't keep make elbowFlexors an enum value and its child also an enum value, i think
  maybe define the structures first, and then maintain the list of enums separately, pointing into it. ah no, the enums must be const so that probably doesn't work? [1]
  we could however, maintain the enums, and then use a conversion function that maps the enum to the data at runtime.. that woud also allow to declare enums for heads, and have our own classes with inheritance etc

  maybe the better way is to have "MuscleGroup" as top-level. it can be (or hold) a singlehead, or multihead, or contain singleheads and multiheads?
  but seems weird to have MuscleGroup as highlevel even for a relatively simple muscle such as pecs or tris

#### flatten the hierarchy via strings

e.g. the entire group is 1 muscle, and use use like 'upper traps, upper fibers', 'upper traps, lower fibers', 'middle traps', 'lower traps' as heads.
this makes UI code the simplest, I think. no need to write complicated recursion etc. we can have our listing view for the head muscle, and show the whole 2nd/3rd hierarchy with 1 simple loop. we would use the same 'children' for both 'other muscles in the same group' and 'heads'. the distinction is often blurry, could set a field hint to mark a preferred terminology.
but this looses the ability to set commonalaties on the intermediate layer. need to repeat them at the leaf nodes, e.g. the gastroc has 2 common movements for its two heads, the bicep has 4 over 2 heads

## 'whole' head

why do we need this 'whole' head stuff again? is there a cleaner way?

- for defining props when a muscle has only 1 head.
- it's only used on muscle page where we show the properties
- if there's only 1 head, you can define movements at the muscle level or the head level. but we want to keep global movements to support applying movements to all heads in multi-head muscles

### ideas

- different Muscle classes, like SingleHeadMuscle and MultiHeadMuscle, that extend from Muscle, but you can't do this with *enums*

## misc cleanups
enums support non-required, nullable fields? can probably clean up some stuff, like pseudo, nick



[1]
```
class Muscle {
  final String name;
  final List<Muscle> children;
  const Muscle(this.name, this.children);
}

const muscles = [
  Muscle('elbow flexors', [Muscle('bicep', []), Muscle('radialis', [])])
];

enum MP {
  flexors(muscles[0]);

  const MP(this.muscle);

  final Muscle muscle;
}
```
