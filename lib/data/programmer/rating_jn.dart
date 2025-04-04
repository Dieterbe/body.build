import 'package:bodybuild/data/programmer/groups.dart';
import 'package:bodybuild/data/programmer/modifier.dart';
import 'package:bodybuild/data/programmer/rating.dart';

/*
Below are ratings from jeff nippard.  not all of them are implemented yet in code,
those that aren't are left as commented notes
*/
/*
 *    888888b.          d8888  .d8888b.  888    d8P                     
 *    888  "88b        d88888 d88P  Y88b 888   d8P                      
 *    888  .88P       d88P888 888    888 888  d8P                       
 *    8888888K.      d88P 888 888        888d88K                        
 *    888  "Y88b    d88P  888 888        8888888b                       
 *    888    888   d88P   888 888    888 888  Y88b                      
 *    888   d88P  d8888888888 Y88b  d88P 888   Y88b                     
 *    8888888P"  d88P     888  "Y8888P"  888    Y88b     
 */
/* BACK / LATS / TRAPS */
/* jeff rankings from https://www.youtube.com/watch?v=jLvqKgW-_G8&list=PLp4G6oBUcv8w8ujRtP5BtvJe8PXBwiTdl&index=6
unimplemented ones:
0:49 - Renegade Rows -> 0/7 , understimulating, not enough stretch
1:40 - Deadlift -> 2/7 for lats/traps
2:31 - Above-The-Knee Rack Pull -> 1/7 just a DL with even less ROM
2:46 - Wide-Grip Pull-Up -> 5/7
3:16 - Neutral-Grip Pull-Up -> 5/7
3:23 - Chin-Up 4/7
3:38 - Wide-Grip Lat Pulldown 6/7
3:59 - Neutral-Grip Lat Pulldown 6/7
4:08 - Half-Kneeling 1-Arm Lat Pulldown 6/7
4:38 - Cross-Body Lat Pull-Around: same as above,but 90 degree rotated , more stretch but a bit awkward 5/7
4:59 - Barbell Row 4/7 , instable
5:26 - Yates Row, like barbell row, but bit more upright and looser form 3/7
5:51 - Pendlay Row, like barbell row but more horizontal back 4.5/7
6:18 - Deficit Pendlay Row 5/7
6:28 - Meadows Row 67
6:52 - Inverted Row 3/7
7:26 - 1-Arm Dumbbell Row 5/7
7:57 - Kroc Row: same but looser form 5/7
8:25 - Free-Standing T-bar Row 4/7
9:37 - Wide-Grip Cable Row  6/7 (prefer with flexion)
9:50 - Rope Face-Pull 4/7 , but seated or lying down 5/7 because more stable
10:37 - Cable Lat Pull-Over 5/7
11:14 - DB Lat Pull-Over 5/7
*/
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

/*
 *     .d8888b.  888    888 8888888888  .d8888b. 88888888888            
 *    d88P  Y88b 888    888 888        d88P  Y88b    888                
 *    888    888 888    888 888        Y88b.         888                
 *    888        8888888888 8888888     "Y888b.      888                
 *    888        888    888 888            "Y88b.    888                
 *    888    888 888    888 888              "888    888                
 *    Y88b  d88P 888    888 888        Y88b  d88P    888                
 *     "Y8888P"  888    888 8888888888  "Y8888P"     888    
*/

/* Jeff Nippard: The Best And Worst Chest Exercises (Ranked By Science) 
https://www.youtube.com/watch?v=fGm-ef-4PVk
0:00 - What makes an exercise S tier?
// COMPOUNDS
0:46 - Hex Press 1/7 - no pec stretch, no tension. triceps take over. F
1:09 - Plate Press - - no pec stretch, no tension. triceps take over, more awkward, not overloadable 0/7
1:17 - Dumbbell Pullover 2/7 (rating is for pecs!), people don't seem to feel it. much better lat exercise
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
12:13 - Cable Press-Around - full contraction (for occassional short length work) 5/7
12:43 - Cross-Body Standing Dumbbell Flye - full contraction. basically front raise for front delt. 1/7
13:09 - Floor Press - for max BP strength. great for tricep. no full stretch.  3/7
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
const ratingJNPecDeckHandGrip = Rating(
  source: Source.jeffNippard,
  score: 5 / 7,
  pg: [
    ProgramGroup.lowerPecs,
    ProgramGroup.upperPecs,
  ],
  comment:
      '''big stretch, good tension across ROM. but path can can be restrictive
  Jeff ranks the exercise [here](https://www.youtube.com/watch?v=fGm-ef-4PVk&t=11m09s)
''',
);
const ratingJNDumbbellFly = Rating(
  source: Source.jeffNippard,
  score: 5 / 7,
  pg: [
    ProgramGroup.lowerPecs,
    ProgramGroup.upperPecs,
  ],
  comment: '''
big stretch, not as smooth as cable fly's. because you lose tension at the top (contraction), jeff
suggests doing lengthened partial reps.
  Jeff ranks the exercise [here](https://www.youtube.com/watch?v=fGm-ef-4PVk&t=11m32s)
''',
);

const ratingJNDips = Rating(
  source: Source.jeffNippard,
  score: 5 / 7,
  pg: [
    ProgramGroup.lowerPecs,
    ProgramGroup.upperPecs,
  ],
  comment:
      '''massive stretch, high tension. can overload. shoulder risk maybe. doesn't feel smooth.
  Jeff ranks the exercise [here](https://www.youtube.com/watch?v=fGm-ef-4PVk&t=5m08s)
''',
);
