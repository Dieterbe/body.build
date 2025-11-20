import 'package:bodybuild/data/dataset/program_group.dart';
import 'package:bodybuild/data/dataset/tweak.dart';
import 'package:bodybuild/data/dataset/rating.dart';

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
  pg: [ProgramGroup.lats, ProgramGroup.middleTraps],
  comment: '''
Jeff ranks the exercise [here](https://www.youtube.com/watch?v=jLvqKgW-_G8&t=8m53s)
and then upgrades it [here](https://www.youtube.com/watch?v=jLvqKgW-_G8&t=11m33s) to special+ ranking''',
);
const ratingJNRowCable = Rating(
  source: Source.jeffNippard,
  score: 6 / 7,
  pg: [ProgramGroup.lats, ProgramGroup.middleTraps],
  comment: '''
Jeff ranks the exercise [here](https://www.youtube.com/watch?v=jLvqKgW-_G8&t=9m22s)''',
  tweaks: {'spine': 'dynamic'},
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

final ratingJNBBBenchPress = benchPressBenchAngle.opts.keys.map(
  (e) => Rating(
    source: Source.jeffNippard,
    score: switch (e) {
      '-15' => 4 / 7,
      '-30' => 4 / 7,
      _ => 5 / 7,
    },
    pg: [ProgramGroup.lowerPecs, ProgramGroup.upperPecs],
    comment: '''
all barbell bench presses allow high tension but limited ROM/tension in deepest stretch, they're overloadable.  
not always stimulating well however.
incline variants should stimulate a bit more upper pecs (while keeping the same mid/lower)
Jeff gives the same rating to all flat and incline bench presses, except declines get a lower rating because they don't recruit upper pecs well and allow for less ROM.  
See his discussion of the exercises:
* [the flat barbell bench press](https://www.youtube.com/watch?v=fGm-ef-4PVk&t=1m47s)
* [the incline barbell bench press](https://www.youtube.com/watch?v=fGm-ef-4PVk&t=2m33s)
* [the decline barbell bench press](https://www.youtube.com/watch?v=fGm-ef-4PVk&t=2m56s)''',
    tweaks: {'bench angle': e},
  ),
);
final ratingJNDBBenchPress = benchPressBenchAngle.opts.keys.map(
  (e) => Rating(
    source: Source.jeffNippard,
    score: switch (e) {
      '-15' => 4 / 7,
      '-30' => 4 / 7,
      _ => 5 / 7,
    },
    pg: [ProgramGroup.lowerPecs, ProgramGroup.upperPecs],
    comment: '''
Dumbbell presses allow deeper stretch than BB. less commonly injurious.  
Overloadable but may run into dumbbell limits when you're very strong.
Similar to barbell presses: the incline variants may allow more upper pec growth while keeping the same mid/lower pec growth.
The decline version is scored less because it stimulates the upper pecs less and is awkward to set up.

See his discussion of the exercises:
* [the flat dumbbell bench press](https://www.youtube.com/watch?v=fGm-ef-4PVk&t=3m35s)
* [the incline dumbbell bench press](https://www.youtube.com/watch?v=fGm-ef-4PVk&t=4m16s)
* [the decline dumbbell bench press](https://www.youtube.com/watch?v=fGm-ef-4PVk&t=4m25s)''',
    tweaks: {'bench angle': e},
  ),
);
const ratingJNMachineChestPress = Rating(
  source: Source.jeffNippard,
  score: 7 / 7,
  pg: [ProgramGroup.lowerPecs, ProgramGroup.upperPecs],
  comment: '''
Deep stretch, high tension throughout ROM. locked in for more focus. safer than freeweights.  
(but all depends on machine)
Jeff ranks the exercise [here](https://www.youtube.com/watch?v=fGm-ef-4PVk&t=4m36s)''',
);
const ratingJNPushUp = Rating(
  source: Source.jeffNippard,
  score: 3 / 7,
  pg: [ProgramGroup.lowerPecs, ProgramGroup.upperPecs],
  comment: '''
no equipment needed. Can get too easy when you're strong. can't overload well. limited ROM.
Jeff ranks the exercise [here](https://www.youtube.com/watch?v=fGm-ef-4PVk&t=5m52s)''',
  tweaks: {'deficit': 'no'},
);
const ratingJNPushUpDeficit = Rating(
  source: Source.jeffNippard,
  score: 5 / 7,
  pg: [ProgramGroup.lowerPecs, ProgramGroup.upperPecs],
  comment: '''
more deep stretch. best type of pushup 
Jeff ranks the exercise [here](https://www.youtube.com/watch?v=fGm-ef-4PVk&t=6m45s)''',
  tweaks: {'deficit': 'max'},
);
const ratingJNPecDeckHandGrip = Rating(
  source: Source.jeffNippard,
  score: 5 / 7,
  pg: [ProgramGroup.lowerPecs, ProgramGroup.upperPecs],
  comment: '''big stretch, good tension across ROM. but path can can be restrictive
  Jeff ranks the exercise [here](https://www.youtube.com/watch?v=fGm-ef-4PVk&t=11m09s)
''',
);
const ratingJNDumbbellFly = Rating(
  source: Source.jeffNippard,
  score: 5 / 7,
  pg: [ProgramGroup.lowerPecs, ProgramGroup.upperPecs],
  comment: '''
big stretch, not as smooth as cable fly's. because you lose tension at the top (contraction), jeff
suggests doing lengthened partial reps.
  Jeff ranks the exercise [here](https://www.youtube.com/watch?v=fGm-ef-4PVk&t=11m32s)
''',
);

const ratingJNDips = Rating(
  source: Source.jeffNippard,
  score: 5 / 7,
  pg: [ProgramGroup.lowerPecs, ProgramGroup.upperPecs],
  comment: '''massive stretch, high tension. can overload. shoulder risk maybe. doesn't feel smooth.
  Jeff ranks the exercise [here](https://www.youtube.com/watch?v=fGm-ef-4PVk&t=5m08s)
''',
);

///
///    888888b.  8888888  .d8888b.  8888888888 8888888b.   .d8888b.
///    888  "88b   888   d88P  Y88b 888        888   Y88b d88P  Y88b
///    888  .88P   888   888    888 888        888    888 Y88b.
///    8888888K.   888   888        8888888    888   d88P  "Y888b.
///    888  "Y88b  888   888        888        8888888P"      "Y88b.
///    888    888  888   888    888 888        888              "888
///    888   d88P  888   Y88b  d88P 888        888        Y88b  d88P
///    8888888P" 8888888  "Y8888P"  8888888888 888         "Y8888P"
/*
 The Best And Worst Biceps Exercises 
 https://www.youtube.com/watch?v=GNO4OtYoCYk
4:25 - DB Preacher Curl - more tension at stretched position. impossible to cheat. 6/7
5:20 - Incline Curl - worse than preachers.  lot more stretch, but again tension mainly at mid point. fast to set up and easy to do .5/7
5:34 - Lying DB Curl - huge stretch (especially near the shoulder), more tension at the bottom.  5/7
6:08 - Scott Curl - preacher with vertical arm, no tension on stretched position. worse than preachers. 3/7
6:30 - Flat Bench Curl - preacher curl but on a horizontal bench. highest tension at the stretched position 4/7
7:01 - Machine Preacher Curl - locked in. jeff does lengthened partials (supinated grip) 6/7
7:16 - Waiter Curl - gimmicky. cranks your wrists, feels awkward. overload limits. just use dumbbels instead 0/7
7:35 - Drag Curl - simultaneous shortening at elbow and lengthening at shoulder. so overall not much change (similar to hams in squats which don't grow well). so likely not a good exercise. 3/7
8:11 - Spider Curl - shortened position (not much stretch), can bump into bench. 3/7
8:31 - Chin-Ups - back probably takes over. very accessible (only need your bodyweight) 4/7
9:01 - old skool 21s - 3/7 , modified 21s 5/7

11:45 - Cheat Curl - momentum concentric, controlled eccentric 5/7
12:30 - Strict Curl - suspect that it's a bit better than cheat curls, but we don't know for sure. 5/7
14:15 - Preacher Hammer Curl 6/7
14:25 - Inverse Zottman Curl 5/7
*/
const ratingJNBBCurl = Rating(
  source: Source.jeffNippard,
  score: 4 / 7,
  pg: [ProgramGroup.biceps],
  comment:
      '''tension mainly at the mid point. overloading, may hurt wrists. wasteful use of a barbell
      Jeff ranks the exercise [here](https://www.youtube.com/watch?v=GNO4OtYoCYkk&t=1m56s)''',
);
const ratingJNEZBarCurl = Rating(
  source: Source.jeffNippard,
  score: 5 / 7,
  pg: [ProgramGroup.biceps],
  comment:
      '''tension mainly at the mid point. easier on the wrists than barbell. good for 6-8 rep range
      Jeff ranks the exercise [here](https://www.youtube.com/watch?v=GNO4OtYoCYk&t=2m45s)''',
);
const ratingJNDBCurl = [
  Rating(
    source: Source.jeffNippard,
    score: 5 / 7,
    pg: [ProgramGroup.biceps],
    comment: '''tension mainly at the mid point. convenient. good against assymetries.
better not alternate (too much rest)
      Jeff ranks the exercise [here](https://www.youtube.com/watch?v=GNO4OtYoCYk&t=3m37s)''',
    tweaks: {'grip': 'hammer to supinated'},
  ),
  Rating(
    source: Source.jeffNippard,
    score: 5 / 7,
    pg: [ProgramGroup.biceps],
    comment: '''favors a bit more brachialis over bicep - tension mainly at the mid point
      Jeff ranks the exercise [here](https://www.youtube.com/watch?v=GNO4OtYoCYk&t=13m06s)''',
    tweaks: {'grip': 'hammer'},
  ),
];
const ratingJNCableCurl = [
  Rating(
    source: Source.jeffNippard,
    score: 5 / 7,
    pg: [ProgramGroup.biceps],
    comment:
        '''jeff says "even tension throughout ROM". He ranks the exercise [here](https://www.youtube.com/watch?v=GNO4OtYoCYk&t=10m12s)''', // TODO: disagree
    tweaks: {'style': 'standard'},
  ),
  Rating(
    source: Source.jeffNippard,
    score: 7 / 7,
    pg: [ProgramGroup.biceps],
    comment:
        '''jeff says "even tension throughout ROM, but now with maximum stretch". He ranks the exercise [here](https://www.youtube.com/watch?v=GNO4OtYoCYk&t=10m28s)''', // TODO: disagree
    tweaks: {'style': 'bayesian with arms behind'},
  ),
  Rating(
    source: Source.jeffNippard,
    score: 5 / 7,
    pg: [ProgramGroup.biceps],
    comment:
        '''jeff says "max tension at maximum stretch". He ranks the exercise [here](https://www.youtube.com/watch?v=GNO4OtYoCYk&t=11m11s)''', // TODO: also not such a consistent tension curve
    tweaks: {'style': 'bayesian with arms behind and up'},
  ),
];

/// *
///     .d88888b.  888     888        d8888 8888888b.   .d8888b.
///    d88P" "Y88b 888     888       d88888 888  "Y88b d88P  Y88b
///    888     888 888     888      d88P888 888    888 Y88b.
///    888     888 888     888     d88P 888 888    888  "Y888b.
///    888     888 888     888    d88P  888 888    888     "Y88b.
///    888 Y8b 888 888     888   d88P   888 888    888       "888
///    Y88b.Y8b88P Y88b. .d88P  d8888888888 888  .d88P Y88b  d88P
///     "Y888888"   "Y88888P"  d88P     888 8888888P"   "Y8888P"
///           Y8b
///
/*
1:28 - Combo Squat Exercises 1/6 not limiting factor
1:43 - Bosu Ball Squat - too unstable, no tension 0/7
2:01 - Barbell Back Squat - high tension when deep. best for overload. uses spinal erectors. decent RF engagement, as long as you use 1 other exercise 7/7
3:04 - Barbell Front Squat - even more tension on quads (more moment arm on knee), more strain on upper back. can be awkward for some. 5/7 (6/7 if comfortable)
4:08 - Low-Bar Squat - more glutes, less quads. but still very productive 5/7
4:36 - Hack Squat - like BB squat ,but faster and more stable 7/7
5:07 - Pendulum Squat - similar to hack squat , more natural resistance path 7/7
5:25 - Smith Machine Squat - just like bb squat, but more safe. 6/7
5:50 - 45 Degree Leg Press - can't get as deep as a squat. 5/7
6:17 -  Horizontal Leg Press - worse than 45 degree. less ROM. may max out the machine. 3/7
6:39 - Lunge - more for glutes, though it does quads also. for quads 4/7, for glutes would be 5/7 or 6/7
7:05 - Leg Extension - knee concerns debunked. can work RF, especially lean back. 5/7
8:14 - Reverse Nordic - like leg extension but without machine. 5/7
8:50 - Goblet Squat - similar to BB front squat. harder to overload 4/7
9:21  - Jump Squat - for explosive, not muscle growth. 1/7
9:34 - Bulgarian Split Squat - brutal, but work well. and prevents imbalances. 6/7
10:03 - Deadlift - "quarter squat", more for glutes and overall strength. 3/7
10:24 - Step Ups. - similarly not fun as BSQ, but less stretch and less stable. but good for glutes. 3/7
10:40 - Pistol Squat - unstable and hard to overload. great for at home. 3/7
10:56 - Sissy Squat - like reverse nordic. very challenging. but hard to load and more learning curve. might feel awkward. but super deep stretch. 4/7
*/

/***
 *     .d8888b.  888      888     888 88888888888 8888888888  .d8888b.  
 *    d88P  Y88b 888      888     888     888     888        d88P  Y88b 
 *    888    888 888      888     888     888     888        Y88b.      
 *    888        888      888     888     888     8888888     "Y888b.   
 *    888  88888 888      888     888     888     888            "Y88b. 
 *    888    888 888      888     888     888     888              "888 
 *    Y88b  d88P 888      Y88b. .d88P     888     888        Y88b  d88P 
 *     "Y8888P88 88888888  "Y88888P"      888     8888888888  "Y8888P"  
 */
/*
2:06 - Barbell Hip Thrust - very effective. for all of glute max. overloadable. can feel awkward. set up time. not a deep stretch.  4/7
3:51 - Machine Hip Thrust - 5/7 , number one for middle glute.
4:21 - Single-Leg Dumbbell Hip Thrust - more upper glute. 5/7
4:43 - Glute Bridge - hip thrust but less ROM. 4/7
5:01 - Frog Pumps - upper glute. hard to load. not a huge stretch 3/7
5:25 - Barbell Back Squat - underrated.  can make it more glute focused with lower bar position, lean more forward and focus on hip drive. go deep. at least break pararrell. 5/7
6:08 - Smith Machine Squat - feet more forward for more glute focus. balance not an issue. 5/7
6:16 - Bulgarian Split Squat - deeper stretch. good for upper and middle. can focus moreon glute with foot more forward and forward lean and focus on hip drive. hard to overload. 5/7
6:52 - Donkey Kicks - hard to overload. little tension. - 0/7
7:11 - Fire Hydrants - low tension. more mobility focus. 0/7
7:23 - Kickback - upper glute if you kick up/out diagonally. stable if you hold machine, or better yet, on bench. 5/7
7:55 - Step Ups - upper glute due to stability. can get deep stretch with platform at knee level. 5/7
8:20 - Machine Hip Abduction - fantastic for upper glutes. lean forward for deeper stretch - 30 degrees. 6/7
9:03 - Cable Hip Abduction - not as stable, harder to overload. annoying to setup. 4/7
9:11 - Lateral Banded Walk - zero tension when stretched. good warmup drill. 3/7
9:25 - Walking Lunge - entire glute. deeper stretch with longer strides, lean 30 degree forward 7/7
10:12 - Smith Machine Lunge - 5/7
10:23 - Smith Machine Lunge (Front Foot Elevated) - more ROM. 6/7
10:30 - Curtsy Lunge - upper glute / glute medius focus. hard to overload. 4/7
10:51 - Deadlift - low stimulus to fatigue. good for strength, not so much hypertrophy. 4/7
11:20 - Sumo Deadlift - probably more demand on glute med / upper glutes. 4/7
11:41 - Romanian Deadlift - better for glute hypertrophy for low glute and hams. smashes glute max. very easy to overload. 5/7 top pick lower glute
12:08 - 45-Degree Back Extension - love it. very active lengthened and shortened. 6/7
12:33 - Cable Pull Through - okay. good for beginners. starts to feel awkward when you progress. 4/7
12:45 - Kettlebell Swing - not a fan. more for cardio and explosive power. 2/7
*/
