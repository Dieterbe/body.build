import 'package:bodybuild/data/programmer/groups.dart';
import 'package:bodybuild/data/programmer/modifier.dart';
import 'package:bodybuild/data/programmer/rating.dart';

const ratingJNRowChestSupported = Rating(
  source: Source.jeffNippard,
  score: 7 / 7,
  pg: [
    ProgramGroup.lats,
    ProgramGroup.middleTraps,
  ],
  comment: '''
Jeff ranks the exercise [here](https://www.youtube.com/watch?v=jLvqKgW-_G8&t=8m53s)
and then upgrades it [here](https://www.youtube.com/watch?v=jLvqKgW-_G8&t=11m33s) to special+ ranking''',
);
const ratingJNRowCable = Rating(
  source: Source.jeffNippard,
  score: 6 / 7,
  pg: [
    ProgramGroup.lats,
    ProgramGroup.middleTraps,
  ],
  comment: '''
Jeff ranks the exercise [here](https://www.youtube.com/watch?v=jLvqKgW-_G8&t=9m22s)''',
  modifiers: {'spine': 'dynamic'},
);

/* Jeff Nippard: The Best And Worst Chest Exercises (Ranked By Science) 
https://www.youtube.com/watch?v=fGm-ef-4PVk
0:00 - What makes an exercise S tier?
// COMPOUNDS
0:46 - Hex Press 1/7 - no pec stretch, no tension. triceps take over. F
1:09 - Plate Press - - no pec stretch, no tension. triceps take over, more awkward, not overloadable 0/7
1:17 - Dumbbell Pullover 2/7 (rating is for pecs!), people don't seem to feel it. much better lat exercise

*/
final ratingJNBBBenchPress = benchPressBenchAngle.opts.keys.map((e) => Rating(
      source: Source.jeffNippard,
      score: switch (e) {
        '-15' => 4 / 7,
        '-30' => 4 / 7,
        _ => 5 / 7,
      },
      pg: [
        ProgramGroup.lowerPecs,
        ProgramGroup.upperPecs,
      ],
      comment: '''
all barbell bench presses allow high tension but limited ROM/tension in deepest stretch, they're overloadable.  
not always stimulating well however.
incline variants should stimulate a bit more upper pecs (while keeping the same mid/lower)
Jeff gives the same rating to all flat and incline bench presses, except declines get a lower rating because they don't recruit upper pecs well and allow for less ROM.  
See his discussion of the exercises:
* [the flat barbell bench press](https://www.youtube.com/watch?v=fGm-ef-4PVk&t=1m47s)
* [the incline barbell bench press](https://www.youtube.com/watch?v=fGm-ef-4PVk&t=2m33s)
* [the decline barbell bench press](https://www.youtube.com/watch?v=fGm-ef-4PVk&t=2m56s)''',
      modifiers: {'bench angle': e},
    ));
final ratingJNDBBenchPress = benchPressBenchAngle.opts.keys.map((e) => Rating(
      source: Source.jeffNippard,
      score: switch (e) {
        '-15' => 4 / 7,
        '-30' => 4 / 7,
        _ => 5 / 7,
      },
      pg: [
        ProgramGroup.lowerPecs,
        ProgramGroup.upperPecs,
      ],
      comment: '''
Dumbbell presses allow deeper stretch than BB. less commonly injurious.  
Overloadable but may run into dumbbell limits when you're very strong.
Similar to barbell presses: the incline variants may allow more upper pec growth while keeping the same mid/lower pec growth.
The decline version is scored less because it stimulates the upper pecs less and is awkward to set up.

See his discussion of the exercises:
* [the flat dumbbell bench press](https://www.youtube.com/watch?v=fGm-ef-4PVk&t=3m35s)
* [the incline dumbbell bench press](https://www.youtube.com/watch?v=fGm-ef-4PVk&t=4m16s)
* [the decline dumbbell bench press](https://www.youtube.com/watch?v=fGm-ef-4PVk&t=4m25s)''',
      modifiers: {'bench angle': e},
    ));
const ratingJNMachineChestPress = Rating(
  source: Source.jeffNippard,
  score: 7 / 7,
  pg: [
    ProgramGroup.lowerPecs,
    ProgramGroup.upperPecs,
  ],
  comment: '''
Deep stretch, high tension throughout ROM. locked in for more focus. safer than freeweights.  
(but all depends on machine)
Jeff ranks the exercise [here](https://www.youtube.com/watch?v=fGm-ef-4PVk&t=4m36s)''',
);
const ratingJNPushUp = Rating(
  source: Source.jeffNippard,
  score: 3 / 7,
  pg: [
    ProgramGroup.lowerPecs,
    ProgramGroup.upperPecs,
  ],
  comment: '''
no equipment needed. Can get too easy when you're strong. can't overload well. limited ROM.
Jeff ranks the exercise [here](https://www.youtube.com/watch?v=fGm-ef-4PVk&t=5m52s)''',
  modifiers: {'deficit': 'no'},
);
const ratingJNPushUpDeficit = Rating(
  source: Source.jeffNippard,
  score: 5 / 7,
  pg: [
    ProgramGroup.lowerPecs,
    ProgramGroup.upperPecs,
  ],
  comment: '''
more deep stretch. best type of pushup 
Jeff ranks the exercise [here](https://www.youtube.com/watch?v=fGm-ef-4PVk&t=6m45s)''',
  modifiers: {'deficit': 'max'},
);
/*
5:08 - Dips - massive stretch, high tension. can overload. shoulder risk maybe. doesn't feel smooth. 5/7
6:30 - Banded Push-Ups - adds tesnion at top half only 3/7
7:01 - Plyometric Push-Ups - not much tension or stretch 2/7
7:27 - Guillotine Press - shrug shoulders out, flare elbows out. barbell to neck. more pec stretch (needs to feel comfortable!), potential danger 1/7
8:49 - Dumbbell Guillotine Press - same, and safe! 5/7
9:09 - 1-Arm Dumbbell Press - unstable, waste of time. disperses tension. 1/7
9:28 - Smith Machine Flat Bench Press - same upsides as standard BB, can push a bit more. 5/7
9:46 - Incline Smith Machine Press - same, but bit more upper pecs 5/7
// ISOLATIONS
10:14 - Cable Crossovers - big stretch, even tension across ROM. limited in weight when you're strong. cable pulls you back / less stable. .5/7
10:49 - Seated Cable Pec Flye - same, but no stability issue. jeff's favorite chest isolation. 6/7
11:09 - Pec Deck - similar, but path is more restrictive. 5/7
11:32 - Dumbbell Flye - tip: lengthened partials. not as smooth as cable flys. 5/7
12:13 - Cable Press-Around - full contraction (for occassional short length work) 5/7
12:43 - Cross-Body Standing Dumbbell Flye - full contraction. basically front raise for front delt. 1/7
13:09 - Floor Press - for max BP strength. great for tricep. no full stretch.  3/7
*/
