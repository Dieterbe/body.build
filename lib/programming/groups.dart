//  Straight-arm pulldowns can stimulate higher muscle activity in the long head of triceps than barbell bench presses.
// https://www.scielo.br/j/motriz/a/jbfGfJrRsXbfc9BrfXgVSPy/?lang=en

import 'package:ptc/anatomy/muscles.dart';
import 'package:ptc/programming/exercises.dart';

// muscle groups for the purpose of training
// * uses a bit more "common language" (e.g. biceps to mean elbow flexors)
// * categorized in groups based on whether they are trained together in exercises,
//   which differs from the anatomical categorization: sometimes heads from the same muscle,
//   or muscles from the same anatomical group are not trained together; and likewise
//   training a certain group may involve specific heads or muscles belonging to different groups or categories
// can contain heads and/or muscles, in which case they should be "expanded" to mean to include all their heads
enum ProgramGroup {
  lowerPecs([MuscleId.pectoralisMajorSternalHead]),
  upperPecs([MuscleId.pectoralisMajorClavicularHead]),
  frontDelts([MuscleId.deltoidsAnteriorHead]),
  sideDelts([MuscleId.deltoidsLateralHead]),
  rearDelts([MuscleId.deltoidsPosteriorHead]),
  lowerTraps([MuscleId.lowerTraps]),
  middleTraps([MuscleId.middleTraps]),
  upperTraps([MuscleId.upperTrapsLowerFibers, MuscleId.upperTrapsUpperFibers]),
  lats([MuscleId.latissimusDorsi]),
  biceps([
    MuscleId.bicepsBrachiiShortHead,
    MuscleId.bicepsBrachiiLongHead,
    MuscleId.brachialis,
    MuscleId.brachioradialis
  ]), // as long as you do elbow flexion anyway, i think we can include all these
  triceps(
      [MuscleId.tricepsBrachiiMedialHead, MuscleId.tricepsBrachiiLateralHead]),
  tricepsLongHead([MuscleId.tricepsBrachiiLongHead]),
  spinalErectors(
      [MuscleId.spinalis, MuscleId.longissimus, MuscleId.iliocostalis]),
  quadsVasti([
    MuscleId.vastusIntermedius,
    MuscleId.vastusLateralis,
    MuscleId.vastusMedialis
  ]),
  quadsRectusFemoris([MuscleId.rectusFemoris]),
  hams([
    MuscleId.bicepsFemorisLongHead,
    MuscleId.semimembranosus,
    MuscleId.semitendinosus
  ]),
  hamsShortHead([MuscleId.bicepsFemorisShortHead]),
  gluteMax([MuscleId.gluteMaximus]),
  gluteMed([MuscleId.gluteMedius]),
  gastroc([MuscleId.gastrocnemius]),
  soleus([MuscleId.soleus]),
  abs([MuscleId.rectusAbdominis, MuscleId.externalObliques]);

  const ProgramGroup(this.muscles);
  final List<MuscleId> muscles;
}

class VolumeAssignment {
  final List<EBase> match; // OR (any)
  final Map<ProgramGroup, double> assign;
  const VolumeAssignment(this.match, this.assign);
}

List<VolumeAssignment> volumeAssignments = [
  const VolumeAssignment(
    [EBase.deadlift],
    {
      ProgramGroup.upperTraps: 1,
      ProgramGroup.lats: 0.25,
      ProgramGroup.spinalErectors: 1,
      ProgramGroup.quadsVasti: 0.5, // depends on technique and build
      ProgramGroup.hams: 0.75,
      ProgramGroup.gluteMax: 1,
      ProgramGroup.abs: 0.25,
      ProgramGroup.soleus: 0.5,
    },
  ),
  const VolumeAssignment(
    [EBase.deadliftRDL],
    {
      ProgramGroup.upperTraps: 1,
      ProgramGroup.lats: 0.25,
      ProgramGroup.spinalErectors: 1,
      ProgramGroup.hams: 1,
      ProgramGroup.gluteMax: 1,
      ProgramGroup.abs: 0.25,
    },
  ),
  const VolumeAssignment(
    [EBase.goodMorning],
    {
      ProgramGroup.spinalErectors: 1,
      ProgramGroup.hams: 1,
      ProgramGroup.gluteMax: 1,
      ProgramGroup.abs: 0.25,
    },
  ),
  const VolumeAssignment(
    [
      EBase.hipExtension,
      EBase.pullThrough,
    ],
    {
      ProgramGroup.spinalErectors: 0.25,
      ProgramGroup.hams: 1,
      ProgramGroup.gluteMax: 1,
    },
  ),
  const VolumeAssignment(
    [EBase.backExtension],
    {
      ProgramGroup.spinalErectors: 1,
      ProgramGroup.hams: 1,
      ProgramGroup.gluteMax: 1,
    },
  ),
  const VolumeAssignment([
    EBase.legCurl
  ], {
    ProgramGroup.hamsShortHead: 1,
    ProgramGroup.hams: 1,
    ProgramGroup.gastroc: 1 // assuming full dorsiflexion
  }),
  const VolumeAssignment(
    [
      EBase.squatBB,
      EBase.squatGoblet,
    ],
    {
      ProgramGroup.spinalErectors: 1,
      ProgramGroup.quadsVasti: 1,
      ProgramGroup.gluteMax: 1,
      ProgramGroup.soleus:
          0.5, // 0.25 for low bar squats if shins stay vertical
      ProgramGroup.abs: 0.25,
    },
  ),
  const VolumeAssignment(
    [EBase.legPress, EBase.squatHack, EBase.squatBelt],
    {
      ProgramGroup.spinalErectors: 0.25,
      ProgramGroup.quadsVasti: 1,
      ProgramGroup.gluteMax: 1,
      ProgramGroup.soleus: 0.5, // 0.25 if shins stay vertical
    },
  ),
  const VolumeAssignment([
    EBase.squatBSQ,
  ], {
    ProgramGroup.spinalErectors: 0.5,
    ProgramGroup.quadsVasti: 1,
    ProgramGroup.quadsRectusFemoris: 1,
    ProgramGroup.gluteMax: 1,
    ProgramGroup.gluteMed: 0.5,
    ProgramGroup.soleus: 0.5, // 0.25 if shins stay vertical
    ProgramGroup.abs: 0.25,
  }), // has RF, others don't. so do we assume upright posture? (hip extension)
  const VolumeAssignment([
    EBase.lunge,
    EBase.stepUp,
    EBase.squatPistol,
    EBase.squatSissyAssisted,
    EBase.squatSpanish,
  ], {
    ProgramGroup.spinalErectors: 0.5,
    ProgramGroup.quadsVasti: 1,
    ProgramGroup.gluteMax: 1,
    ProgramGroup.gluteMed: 0.5,
    ProgramGroup.soleus: 0.5, // 0.25 if shins stay vertical
    ProgramGroup.abs: 0.25,
  }),
  const VolumeAssignment([
    EBase.legExtension,
    EBase.reverseNordicHamCurl,
    EBase.squatSissy
  ], {
    ProgramGroup.quadsVasti: 1,
    ProgramGroup.quadsRectusFemoris: 1,
  }),
  const VolumeAssignment([
    EBase.hipThrust,
    EBase.gluteKickback
  ], {
    ProgramGroup.quadsVasti:
        0.5, // depends.. more knee flexion -> more vasti involved
    ProgramGroup.gluteMax: 1,
  }),
  const VolumeAssignment([
    EBase.hipAbductionHipFlexed,
  ], {
    ProgramGroup.gluteMax: 0.5, // upper fibers only
    ProgramGroup.gluteMed: 0.25,
  }),
  const VolumeAssignment([
    EBase.hipAbductionHipExtended,
  ], {
    ProgramGroup.gluteMed: 1,
  }),
  const VolumeAssignment([
    EBase.standingCalfRaise,
    EBase.calfJump,
  ], {
    ProgramGroup.gastroc: 1,
    ProgramGroup.soleus: 1,
  }),
  const VolumeAssignment([
    EBase.seatedCalfRaise
  ], {
    ProgramGroup.gastroc: 0.25,
    ProgramGroup.soleus: 1,
  }),

  const VolumeAssignment([
    EBase.pullupSupinated,
    EBase.pulldown,
    EBase.pulldownNeutral,
    EBase.pullupNeutral,
    EBase.diagonalRow,
  ], {
    ProgramGroup.lowerPecs: 0.25,
    ProgramGroup.rearDelts: 1,
    ProgramGroup.lowerTraps: 1,
    ProgramGroup.middleTraps: 0.75,
    ProgramGroup.lats: 1,
    ProgramGroup.biceps: 1,
  }),
  const VolumeAssignment([
    EBase.pullup,
    EBase.pulldownWidePronated,
  ], {
    ProgramGroup.lowerPecs: 0.5,
    ProgramGroup.rearDelts: 0.25,
    ProgramGroup.lowerTraps: 1,
    ProgramGroup.middleTraps: 0.25,
    ProgramGroup.lats: 1,
    ProgramGroup.biceps: 1,
  }),
  const VolumeAssignment([
    EBase.cableRowWithForwardLean,
    EBase.bentOverRow,
  ], {
    ProgramGroup.rearDelts: 1,
    ProgramGroup.lowerTraps: 1,
    ProgramGroup.middleTraps: 1,
    ProgramGroup.lats: 1,
    ProgramGroup.biceps: 0.5,
    ProgramGroup.tricepsLongHead: 0.25,
    ProgramGroup.spinalErectors: 0.5,
    ProgramGroup.hams: 0.25,
    ProgramGroup.gluteMax: 0.25,
  }), // shouldn't that be extension? where are the normal rows?
  const VolumeAssignment([
    EBase.pullOver,
    EBase.latPrayer
  ], {
    ProgramGroup.lowerPecs: 0.5,
    ProgramGroup.rearDelts: 1,
    ProgramGroup.lats: 1,
    ProgramGroup.tricepsLongHead: 1,
  }),
  const VolumeAssignment([
    EBase.highRow,
    EBase.rearDeltFly,
    EBase.rearDeltRaise,
    EBase.shoulderPull,
    EBase.facePull,
  ], {
    ProgramGroup.rearDelts: 1,
    ProgramGroup.lowerTraps: 1,
    ProgramGroup.middleTraps: 1,
  }),
  const VolumeAssignment([
    EBase.benchPressBB,
    EBase.chestPressMachine,
    EBase.pushUp,
  ], {
    ProgramGroup.lowerPecs: 1,
    ProgramGroup.upperPecs: 1,
    ProgramGroup.frontDelts: 1,
    ProgramGroup.triceps: 1,
    ProgramGroup.tricepsLongHead: 0.25,
  }),
  const VolumeAssignment([
    EBase.benchPressDB,
    EBase.chestPressCable,
  ], {
    ProgramGroup.lowerPecs: 1,
    ProgramGroup.upperPecs: 1,
    ProgramGroup.frontDelts: 1,
    ProgramGroup.triceps: 0.5,
  }),
  const VolumeAssignment([
    EBase.fly,
    EBase.pecDeck
  ], {
    ProgramGroup.lowerPecs: 1,
    ProgramGroup.upperPecs: 1,
    ProgramGroup.frontDelts: 1,
  }), // no diff in lower vs upper?
  const VolumeAssignment([
    EBase.overheadPressBB
  ], {
    ProgramGroup.upperPecs: 0.25,
    ProgramGroup.frontDelts: 1,
    ProgramGroup.sideDelts: 1,
    ProgramGroup.lowerTraps: 0.25,
    ProgramGroup.middleTraps: 0.25,
    ProgramGroup.upperTraps: 0.25,
    ProgramGroup.triceps: 1,
    ProgramGroup.tricepsLongHead: 0.25,
    ProgramGroup.abs: 0.25,
  }),
  const VolumeAssignment([
    EBase.overheadPressDB,
  ], {
    ProgramGroup.upperPecs: 0.25,
    ProgramGroup.frontDelts: 1,
    ProgramGroup.sideDelts: 1,
    ProgramGroup.lowerTraps: 0.25,
    ProgramGroup.middleTraps: 0.25,
    ProgramGroup.upperTraps: 0.25,
    ProgramGroup.triceps: 0.5,
    ProgramGroup.abs: 0.25,
  }),
  const VolumeAssignment([
    EBase.lateralRaise
  ], {
    ProgramGroup.upperPecs: 0.25,
    ProgramGroup.frontDelts: 1,
    ProgramGroup.sideDelts: 1,
    ProgramGroup.lowerTraps: 0.25,
    ProgramGroup.middleTraps: 0.25,
    ProgramGroup.upperTraps: 0.25,
  }),
  const VolumeAssignment([
    EBase.shrug
  ], {
    ProgramGroup.upperTraps: 1,
  }),
  const VolumeAssignment([EBase.tricepExtension],
      {ProgramGroup.triceps: 1, ProgramGroup.tricepsLongHead: 1}),
  /* overhead 40% more growth than pushdown: https://pubmed.ncbi.nlm.nih.gov/35819335/
  50% for long head
  40% more growth for the other two
  due to more tension on all heads
  -> skull overs, skull crushers (elbows!)

  kickbacks, pushdowns not so great
  */
  const VolumeAssignment([EBase.bicepCurl], {ProgramGroup.biceps: 1}),
  const VolumeAssignment([EBase.abCrunch], {ProgramGroup.abs: 1}),
];

// given an exercise, process all names and apply all volume assignemnts that match
//Map{ProgramGroup, double} computeVolumeForExercise() {}

// why no seperation in lats activation for rows vs prayers. various triceps extensions

// you should count barbell presses as achieving only a 50% triceps stimulus compared to
// 100% for triceps isolation exercises. Exercises like lat prayers, a variant of straight-arm
// pulldowns, can effectively stimulate the long head of the triceps in relative isolation to
// compensate for its lack of activation during pushing exercises.


// bulgarians here assume you use rear leg so you activate RF on that. could also hav variant that doesn't use rear leg
// TODO split up chest upper / lower / mid



// triceps pitfall:
// pressing exercises train medial/lateral head
// triceps isolation train all heads
// -> medial/lateral get more volume, while long head gets less but it's the biggest head
// solution 1:
// de-emphasize triceps in pressing chest/shoulder work + isolated tri work
// overhead press -> lat raise // TODO does this refer to barbell overhead press? i guess so
// press -> fly, cable chest press
// dumbbel overhead and bench press instead of barbell
// convergent machine also an option according to menno
// solution 2:
// straight arm pull-downs, lat prayers: trains long head, but not really the other ones
// combine with your normal chest/shoulder stuff which hit only the other heads
// in this case, iso work not really needed

//                           medial/lat    long
// barbell presses              v
// cable/dummbell presses       
// tri isolation work           v            v
// lat pulldown                              v


/* families etc?
what are the use cases?
- true "alternatives"? don't really exist, always some level of difference, but maybe useful still to find alternative exercises
- seeing difference in results between different versions of something 
- equivalency for volume assignment matching
should probably not put all squats or bench presses in the same family. that doesn't seem very useful
leg curls
bicep curls
tricep extensions
deadlifts
different squats: what's the point of having a category that includes bulgarian and hack squat and goblet, and bodyweight, etc? they are quite different (e.g. in back load
bench press (inclide, decline, barbell, dumbell)
pull-downs (chinup, neutral grip, wide, etc), also assisted vs unassisted
pull-ups (chinup, neutral grip, wide, etc)

for volume assignments, we use
- exact names (e.g. dumbell overhead press). i guess you can always split up further. seated, standing, maybe unilateral though that could be an execution specific thing that is orthogonal to the exercise, etc
  i suppose we can later always add new variants, while the rules must continue to work. therefore, rules cannot point to single exercises by id/name
- family names (chest fly, lat raise)

we don't to have simple prefix search like "hip abduction" because then you need to give names like "hip abduction, standing"
so either we declare family manually, or we parse it out by removing "standing" etc. probably better to be a bit redundant and make it explicit
*/