## Body building anatomy

Goals are/were:
1)
* if you can express:
  - muscle anatomy and how those muscles (or their heads / fiber regions) contribute to specific articulations, where they have most leverage, where they reach insufficiency, over which angles they work, etc
  - an exercise as a combination of simultaneous articulations over a set of ranges of motion with a given resistance angle & curve

... then, you can, for any given exercise, deduce which muscles it uses and works the best
in practice, this is quite though though. as you need to find a way to express resistance and force curves, interpolate between them, and do it based on anecdotal evidence and incomplete information which uses relative term like "weak", "most strong" etc (see anatomy module), and such information is often observed based on exercises, so trying to tie back a muscle-exercise association to muscle-articulation and then infer the muscle-exercise one, doesn't seem all that useful.
probably more useful to just declare synergists/prime movers based on facts for some exercises, and inferring, for others

it's further complicated by certain muscles having multi heads, some having no heads but various regions etc.
so I've pretty much given up on that

2) an easier way for a human to recall information (e.g. which muscles cause shoulder extension again?) etc.
in a way the codification here is a summarized, easy to use reference (that could get a simple GUI), at the same time, there's some nuance that can't easily be coded...





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

#### M:N mappings

do we need to support M:N mappings? i don't think so. maybe later, though!
could implement this as separate collections structures which include overlapping sets of muscles, or "tags"
in the UI we could then show the collections, and don't show any muscles that are already shown as part of a collection.

#### 3-tier structure

* should we just allow any muscle to have muscle-children? then what about mandatory/optional args? we would want to be able to inherit properties
  for children, some fields would be optional, but for main one, should be mandatory?
  let's try these 3 tiers: muscle-muscle-head. in the future, maybe we can go to muscle-muscle-muscle
  actually no, we couldn't keep make elbowFlexors an enum value and its child also an enum value, i think
  maybe define the structures first, and then maintain the list of enums separately, pointing into it. ah no, the enums must be const so that probably doesn't work? [1]
  we could however, maintain the enums, and then use a conversion function that maps the enum to the data at runtime.. that woud also allow to declare enums for heads, and have our own classes with inheritance etc

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
```
