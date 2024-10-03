# ptc

Goals are/were:
1)
* if you can express:
  - muscle anatomy and how those muscles (or their heads / fiber regions) contribute to specific articulations, where they have most leverage, where they reach insufficiency, over which angles they work, etc
  - an exercise as a combination of simultateous articulations over a set of ranges of motion with a given resistance angle & curve

... then, you can, for any given exercise, deduce which muscles it uses and works the best
in practice, this is quite though though. as you need to find a way to express resistance and force curves, interpolate between them, and do it based on anecdotal evidence and incomplete information which uses relative term like "weak", "most strong" etc (see anatomy module), and such information is often observed based on exercises, so trying to tie back a muscle-exercise association to muscle-articulation and then infer the muscle-exercise one, doesn't seem all that useful.
probably more useful to just declare synergists/prime movers based on facts for some exercises, and inferring, for others

it's further complicated by certain muscles having multi heads, some having no heads but various regions etc.
so i've pretty much given up on that

2) an easier way for a human to recall information (e.g. which muscles cause shoulder extension again?) etc.
in a way the codification here is a summarized, easy to use reference (that could get a simple GUI), at the same time, there's some nuance that can't easily be coded...



## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


refactor stuff:
* sometimes it's not clear what is a muscle vs what is a head. e.g. quadriceps,
* deltoids seperate muscles or heads?
* calves 2 muscles, one of which has 2 heads
* spinal erectors.

why does it matter?
- bundle them in UI on muscles overview
- when looking at functions, i want to see gastroc and soleus together. the 3 delts together, etc

solutions?
* a 3 tier structure?
* do we need more flexibility, e.g. arbitrary "collections" of muscles? or "tags" ?

- why do we need this 'whole' head stuff again? for props when a muscle has only 1 head? is there a cleaner way?