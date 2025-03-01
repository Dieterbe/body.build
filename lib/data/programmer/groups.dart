//  Straight-arm pulldowns can stimulate higher muscle activity in the long head of triceps than barbell bench presses.
// https://www.scielo.br/j/motriz/a/jbfGfJrRsXbfc9BrfXgVSPy/?lang=en

import 'package:bodybuild/data/anatomy/muscles.dart';
import 'package:bodybuild/data/programmer/equipment.dart';
import 'package:bodybuild/data/programmer/exercise_base.dart';
import 'package:bodybuild/data/programmer/modifier.dart';

// muscle groups for the purpose of training
// * uses a bit more "common language" (e.g. biceps to mean elbow flexors)
// * categorized in groups based on whether they are trained together in exercises,
//   which differs from the anatomical categorization: sometimes heads from the same muscle,
//   or muscles from the same anatomical group are not trained together; and likewise
//   training a certain group may involve specific heads or muscles belonging to different groups or categories
// can contain heads and/or muscles, in which case they should be "expanded" to mean to include all their heads

class Assign {
  final double volume;
  final String? modality; // work in progress
  const Assign(this.volume, [this.modality]);

  Assign merge(Assign other) {
    final mergedModality = switch ((modality, other.modality)) {
      (null, null) => null,
      (String value, null) => value,
      (null, String value) => value,
      (String a, String b) => '$a, $b'
    };
    return Assign(volume + other.volume, mergedModality);
  }
}

enum ProgramGroup {
  wristFlexors("Wrist Flexors", [MuscleId.wristFlexors], []),
  wristExtensors('Wrist Extensors', [MuscleId.wristExtensors], []),
  lowerPecs('Lower Pecs', [MuscleId.pectoralisMajorSternalHead],
      ['transverse adduction OR flexion', 'shoulder extension']),
  upperPecs('Upper Pecs', [MuscleId.pectoralisMajorClavicularHead],
      ['transverse adduction OR flexion', 'shoulder flexion']),
  /*
      ### Delts
* front head: rarely ever needs isolation work, as it is stimulated by all horizontal and vertical presses, so it’s more likely to be overworked than understimulated.
* lateral head: needs a lateral raise or overhead press variant to emphasize shoulder abduction rather than flexion. wide grip, even better arguably, dumbbells activate the lateral delts more effectively than a barbell for most people (in menno's experience, i believe). Standing also activates the sides of the shoulders better than sitting, as with sitting you often end up with a high-incline press. Plus, the bench restricts your natural scapular movement.
* posterior head is effectively trained with most pulling movements, but many of these don’t achieve full ROM, so an added reverse fly or high row variant is advisable
*/
  frontDelts('Front Delts', [MuscleId.deltoidsAnteriorHead], []),
  sideDelts('Side Delts', [MuscleId.deltoidsLateralHead], []),
  rearDelts('Rear Delts', [MuscleId.deltoidsPosteriorHead], []),
  lowerTraps('Lower Traps', [
    MuscleId.lowerTraps
  ], [
    'middle and lower heads often get worked well with vertical pulls already'
  ]),
  middleTraps('Middle Traps', [
    MuscleId.middleTraps
  ], [
    'middle and lower heads often get worked well with vertical pulls already'
  ]),
  upperTraps('Upper Traps', [
    MuscleId.upperTrapsLowerFibers,
    MuscleId.upperTrapsUpperFibers
  ], [
    'deadlift, overhead press',
    'for max growth, add a wide or overhead shrug'
  ]),
  lats('Lats', [
    MuscleId.latissimusDorsi
  ], [
    'for non-novice trainees, >=2 different angle pulling exercises: shoulder extension & shoulder adduction'
  ]),
  biceps('Biceps', [
    MuscleId.bicepsBrachiiShortHead,
    MuscleId.bicepsBrachiiLongHead,
    MuscleId.brachialis,
    MuscleId.brachioradialis
  ], [
    'elbow flexion to the side',
    'elbow flexion in front'
  ]), // as long as you do elbow flexion anyway, i think we can include all these
  tricepsMedLatH(
      'Triceps Med/Lat H.',
      [MuscleId.tricepsBrachiiMedialHead, MuscleId.tricepsBrachiiLateralHead],
      ['presses']),
  tricepsLongHead(
      'Triceps Long H.', [MuscleId.tricepsBrachiiLongHead], ['any isolation']),
  abs('Abs', [MuscleId.rectusAbdominis, MuscleId.externalObliques],
      ['depends on goals (e.g. typically not for physique athletes)']),

  spinalErectors('Spinal Erectors', [
    MuscleId.spinalis,
    MuscleId.longissimus,
    MuscleId.iliocostalis
  ], [
    'base: squats/DLs',
    'if injury risk is low and maximum growth is desired, add a high-rep back extension'
  ]),
  quadsVasti('Quads Vasti', [
    MuscleId.vastusIntermedius,
    MuscleId.vastusLateralis,
    MuscleId.vastusMedialis
  ], [
    'squat',
    'leg extension isolation: for full load across whole ROM'
  ]),
  quadsRF('Quads RF', [MuscleId.rectusFemoris], ['leg extension isolation']),

  hams('Ham Long H. & semis', [
    MuscleId.bicepsFemorisLongHead,
    MuscleId.semimembranosus,
    MuscleId.semitendinosus
  ], [
    'knee flexion',
    'hip extension'
  ]),
  hamsShortHead(
      'Ham Short H.', [MuscleId.bicepsFemorisShortHead], ['knee flexion']),
  /*
      ### Gluteus maximus (and medius)
needs a bent-knee and a straight-leg hip extension exercise such as hip
thrusts and Romanian deadlifts. // Dieter note: BSQ is probably a good bent knee hip extension too!
glute med -> anti-adduction force during squats, especially unilateral squats, may suffice. otherwise hip abduction
*/
  gluteMax('Glute Max', [MuscleId.gluteMaximus], []),
  gluteMed('Glute Med', [MuscleId.gluteMedius], []),
  /*
  ### Calves
Menno says you need at least one straight-leg plantarflexion (calf raise) exercise in addition to one
bent-knee plantarflexion (seated calf raise) exercise for the soleus.
However, according to https://www.frontiersin.org/journals/physiology/articles/10.3389/fphys.2023.1272106/full a standing calf raise gives nearly the same stimulus to the soleus as the seated one does, while also stimulating the gastrocs well. While the study is only on untrained people, I (Dieter) find it a compelling argument to not program seated calf raises, in addition to standing ones, especially for a muscle that’s hidden under the gastroc. Dr. Mike also made a youtube video about this saying basically the same.
*/
  gastroc('Gastroc', [MuscleId.gastrocnemius], []),
  soleus('Soleus', [MuscleId.soleus], []);

  final List<MuscleId> muscles;
  final String displayName;
  // recommended modalities:
  // work in progress feature. idea is to show to which extent a program covers all modalities well
  // however, not sure if this is the right approach, instead of hardcoding this information,
  // it could probably just emerge from the other data we already have (e.g. muscle-articulation associations, strength curves etc)
  // when those are defined well enough.
  final List<String> recModalities;
  const ProgramGroup(this.displayName, this.muscles, this.recModalities);
}

class VolumeAssignment {
  final List<EBase> match; // OR (any)
  final Map<ProgramGroup, Assign> assign;
  // assign volume based on equipment used in the exercise
  final Map<Equipment, Map<ProgramGroup, Assign>>
      assignEquip; // TODO: should this move to the exercise?
  const VolumeAssignment(this.match, this.assign,
      {this.assignEquip = const {}});
}

List<VolumeAssignment> volumeAssignments = [
  const VolumeAssignment(
    [EBase.deadlift],
    {
      ProgramGroup.upperTraps: Assign(1),
      ProgramGroup.lats: Assign(0.25),
      ProgramGroup.spinalErectors: Assign(1, 'isometric'),
      ProgramGroup.quadsVasti:
          Assign(0.5, 'knee extension (depends on technique and build)'),
      ProgramGroup.hams: Assign(0.75),
      ProgramGroup.gluteMax: Assign(1),
      ProgramGroup.abs: Assign(0.25),
      ProgramGroup.soleus: Assign(0.5),
      ProgramGroup.wristExtensors: Assign(0.3, 'isometric'),
      ProgramGroup.wristFlexors: Assign(0.3, 'isometric'),
    },
  ),
  const VolumeAssignment([
    EBase.deadliftRDL
  ], {
    ProgramGroup.upperTraps: Assign(1, 'isometric'),
    ProgramGroup.lats: Assign(0.25),
    ProgramGroup.spinalErectors: Assign(1, 'isometric'),
    ProgramGroup.hams: Assign(1, 'long length hip extension'),
    ProgramGroup.gluteMax:
        Assign(1, 'full ROM hip extension, less load when short & strongest'),
    ProgramGroup.abs: Assign(0.25),
    ProgramGroup.wristExtensors: Assign(0.3, 'isometric'),
    ProgramGroup.wristFlexors: Assign(0.3, 'isometric'),
  }),
  const VolumeAssignment(
    [EBase.goodMorning],
    {
      ProgramGroup.spinalErectors: Assign(1, 'isometric'),
      ProgramGroup.hams: Assign(1, 'long length hip extension'),
      ProgramGroup.gluteMax: Assign(1),
      ProgramGroup.abs: Assign(0.25),
      ProgramGroup.wristExtensors: Assign(0.25, 'isometric'),
      ProgramGroup.wristFlexors: Assign(0.25, 'isometric'),
    },
  ),
  const VolumeAssignment(
    [
      EBase.hipExtension,
    ],
    {
      ProgramGroup.spinalErectors: Assign(0.25),
      ProgramGroup.hams: Assign(1),
      ProgramGroup.gluteMax: Assign(1),
      ProgramGroup.wristExtensors: Assign(0.25, 'isometric'),
      ProgramGroup.wristFlexors: Assign(0.25, 'isometric'),
    },
  ),
  const VolumeAssignment(
    [
      EBase.pullThrough,
    ],
    {
      ProgramGroup.spinalErectors: Assign(0.25),
      ProgramGroup.hams: Assign(1),
      ProgramGroup.gluteMax: Assign(1),
      ProgramGroup.wristExtensors: Assign(0.3, 'isometric'),
      ProgramGroup.wristFlexors: Assign(0.3, 'isometric'),
    },
  ),
  const VolumeAssignment(
    [EBase.backExtension],
    {
      ProgramGroup.spinalErectors:
          Assign(1, 'isometric or dynamic based on technique'),
      ProgramGroup.hams: Assign(1),
      ProgramGroup.gluteMax: Assign(1),
      ProgramGroup.wristExtensors: Assign(0.25, 'isometric'),
      ProgramGroup.wristFlexors: Assign(0.25, 'isometric'),
    },
  ),
  const VolumeAssignment(
    [EBase.legCurlHipFlexed],
    {
      ProgramGroup.hamsShortHead: Assign(1, 'full length'),
      ProgramGroup.hams: Assign(1, 'medium to long length knee flexion'),
    },
  ),
  const VolumeAssignment(
    [EBase.legCurlHipExtended],
    {
      ProgramGroup.hamsShortHead: Assign(1, 'full length'),
      ProgramGroup.hams: Assign(1, 'knee flexion (short to medium length)'),
    },
  ),
  const VolumeAssignment(
    [
      EBase.squatBB,
      EBase.squatGoblet,
    ],
    {
      ProgramGroup.spinalErectors: Assign(1, 'isometric'),
      ProgramGroup.quadsVasti: Assign(1, 'knee extension'),
      ProgramGroup.gluteMax: Assign(1),
      ProgramGroup.abs: Assign(0.25),
      ProgramGroup.wristExtensors: Assign(0.3, 'isometric'),
      ProgramGroup.wristFlexors: Assign(0.3, 'isometric'),
    },
  ),
  const VolumeAssignment(
    [EBase.legPress, EBase.squatHack, EBase.squatBelt],
    {
      ProgramGroup.spinalErectors: Assign(0.25),
      ProgramGroup.quadsVasti: Assign(1, 'knee extension'),
      ProgramGroup.gluteMax: Assign(1),
    },
  ),
  const VolumeAssignment([
    EBase.squatBSQ,
  ], {
    ProgramGroup.spinalErectors: Assign(0.5, 'isometric'),
    ProgramGroup.quadsVasti: Assign(1, 'knee extension'),
    ProgramGroup.gluteMax: Assign(1,
        'hip extension (from long to somewhat flexed still), less load when short & strongest'),
    ProgramGroup.gluteMed: Assign(0.5, 'anti-adduction force'),
    ProgramGroup.abs: Assign(0.25),
  }, assignEquip: {
    Equipment.dumbbell: {
      ProgramGroup.wristExtensors: Assign(0.3, 'isometric'),
      ProgramGroup.wristFlexors: Assign(0.3, 'isometric'),
    },
    Equipment.barbell: {
      ProgramGroup.wristExtensors: Assign(0.25, 'isometric'),
      ProgramGroup.wristFlexors: Assign(0.25, 'isometric'),
    },
    Equipment.smithMachineVertical: {
      ProgramGroup.wristExtensors: Assign(0.25, 'isometric'),
      ProgramGroup.wristFlexors: Assign(0.25, 'isometric'),
    },
    Equipment.smithMachineAngled: {
      ProgramGroup.wristExtensors: Assign(0.25, 'isometric'),
      ProgramGroup.wristFlexors: Assign(0.25, 'isometric'),
    },
  }),
  const VolumeAssignment(
    [
      EBase.lunge,
      EBase.stepUp,
    ],
    {
      ProgramGroup.spinalErectors: Assign(0.5, 'isometric'),
      ProgramGroup.quadsVasti: Assign(1, 'knee extension'),
      ProgramGroup.gluteMax: Assign(1),
      ProgramGroup.gluteMed: Assign(0.5),
      ProgramGroup.abs: Assign(0.25),
    },
    assignEquip: {
      Equipment.dumbbell: {
        ProgramGroup.wristExtensors: Assign(0.3, 'isometric'),
        ProgramGroup.wristFlexors: Assign(0.3, 'isometric'),
      }
    },
  ),
  const VolumeAssignment([
    EBase.squatPistol,
    EBase.squatSissyAssisted,
    EBase.squatSpanish,
  ], {
    ProgramGroup.spinalErectors: Assign(0.5, 'isometric'),
    ProgramGroup.quadsVasti: Assign(1, 'knee extension'),
    ProgramGroup.gluteMax: Assign(1),
    ProgramGroup.gluteMed: Assign(0.5),
    ProgramGroup.abs: Assign(0.25),
  }),
  const VolumeAssignment([
    EBase.legExtension,
    EBase.reverseNordicHamCurl,
    EBase.squatSissy
  ], {
    ProgramGroup.quadsVasti: Assign(1, 'knee extension'),
  }),
  const VolumeAssignment([
    EBase.hipThrust,
    EBase.gluteKickback
  ], {
    ProgramGroup.gluteMax: Assign(1),
  }, assignEquip: {
    Equipment.barbell: {
      ProgramGroup.wristExtensors: Assign(0.25, 'isometric'),
      ProgramGroup.wristFlexors: Assign(0.25, 'isometric'),
    }
  }),
  VolumeAssignment(
    [EBase.hipAbduction],
    // for exercises that use this EBase but don't use the modifier, we assume straight hip
    hipAbductionHipFlexion('0°').opts['0°']!,
  ),
  const VolumeAssignment([
    EBase.standingCalfRaise,
    EBase.calfJump,
  ], {
    ProgramGroup.gastroc: Assign(
        1, 'ankle plantarflexion (medium to long length, stretched at knee)'),
    ProgramGroup.soleus: Assign(1, 'ankle plantarflexion (full ROM)'),
  }, assignEquip: {
    Equipment.barbell: {
      ProgramGroup.wristExtensors: Assign(0.25, 'isometric'),
      ProgramGroup.wristFlexors: Assign(0.25, 'isometric'),
    },
    Equipment.dumbbell: {
      ProgramGroup.wristExtensors: Assign(0.5, 'isometric'),
      ProgramGroup.wristFlexors: Assign(0.5, 'isometric'),
    },
    Equipment.smithMachineVertical: {
      ProgramGroup.wristExtensors: Assign(0.25, 'isometric'),
      ProgramGroup.wristFlexors: Assign(0.25, 'isometric'),
    },
  }),
  const VolumeAssignment([
    EBase.seatedCalfRaise
  ], {
    ProgramGroup.gastroc: Assign(0.25),
    ProgramGroup.soleus: Assign(1),
  }),
/* Note, in the PTC course exercise library:
pull up -> grip just outside shoulder width
wide grip pull down -> grip just outside shoulder width
lat pull down -> not mentioned :?
this explains why pull up goes together with wide grip pull down
*/
  const VolumeAssignment([
    EBase.pullupSupinated,
    EBase.pulldownSupinated,
    EBase.pulldown,
    EBase.pulldownNeutral,
    EBase.pullupNeutral,
    EBase.diagonalRow,
  ], {
    ProgramGroup.lowerPecs: Assign(0.25),
    ProgramGroup.rearDelts: Assign(1),
    ProgramGroup.lowerTraps: Assign(1),
    ProgramGroup.middleTraps: Assign(0.75, 'scapular retraction'),
    ProgramGroup.lats: Assign(1),
    ProgramGroup.biceps: Assign(1),
    ProgramGroup.wristExtensors: Assign(0.5, 'isometric'),
    ProgramGroup.wristFlexors: Assign(0.5, 'isometric'),
  }),
  // TODO: add hanging leg raises? wrist stuff 0.5
  const VolumeAssignment([
    EBase.pullup,
    EBase.pulldownWidePronated,
    EBase.pullupWidePronated // TODO: confirm with menno. wasn't part
  ], {
    ProgramGroup.lowerPecs: Assign(0.5),
    ProgramGroup.rearDelts: Assign(0.25),
    ProgramGroup.lowerTraps: Assign(1),
    ProgramGroup.middleTraps: Assign(0.25, 'scapular retraction'),
    ProgramGroup.lats: Assign(1),
    ProgramGroup.biceps: Assign(1, 'elbow flexion while weakened'),
    ProgramGroup.wristExtensors: Assign(0.5, 'isometric'),
    ProgramGroup.wristFlexors: Assign(0.5, 'isometric'),
  }),
  const VolumeAssignment([
    EBase.row,
  ], {
    ProgramGroup.rearDelts: Assign(1),
    ProgramGroup.lowerTraps: Assign(1),
    ProgramGroup.middleTraps: Assign(1, 'scapular retraction'),
    ProgramGroup.lats: Assign(1, 'not full stretch'),
    ProgramGroup.biceps: Assign(0.5, 'elbow flexion while weakened'),
    ProgramGroup.tricepsLongHead: Assign(0.25),
    ProgramGroup.wristExtensors: Assign(0.5, 'isometric'),
    ProgramGroup.wristFlexors: Assign(0.5, 'isometric'),
  }),
  const VolumeAssignment([
    EBase
        .rowWithSpineIso, // specifically, this is for standing rows where you hip hinge forward
  ], {
    // same as normal row
    ProgramGroup.rearDelts: Assign(1),
    ProgramGroup.lowerTraps: Assign(1),
    ProgramGroup.middleTraps: Assign(1, 'scapular retraction'),
    ProgramGroup.lats: Assign(1, 'not full stretch'),
    ProgramGroup.biceps: Assign(0.5, 'elbow flexion while weakened'),
    ProgramGroup.tricepsLongHead: Assign(0.25),
    ProgramGroup.wristExtensors: Assign(0.5, 'isometric'),
    ProgramGroup.wristFlexors: Assign(0.5, 'isometric'),

    // unique to this variant
    ProgramGroup.spinalErectors: Assign(0.5, 'isometric'),
    ProgramGroup.hams: Assign(0.25),
    ProgramGroup.gluteMax: Assign(0.25),
  }),

  const VolumeAssignment([
    EBase.pullOver,
    EBase.latPrayer
  ], {
    ProgramGroup.lowerPecs:
        Assign(0.5, 'full ROM shoulder extension (sometimes)'),
    ProgramGroup.rearDelts: Assign(1, 'full ROM shoulder extension'),
    ProgramGroup.lats: Assign(1, 'full ROM shoulder extension'),
    ProgramGroup.tricepsLongHead:
        Assign(1, 'full ROM shoulder extension (short to medium length)'),
    ProgramGroup.wristExtensors: Assign(0.3, 'isometric'),
    ProgramGroup.wristFlexors: Assign(0.3, 'isometric'),
  }),
  const VolumeAssignment([
    EBase.highRow,
    EBase.rearDeltFly,
    EBase.rearDeltRaise,
    EBase.shoulderPull,
    EBase.facePull,
  ], {
    ProgramGroup.rearDelts: Assign(1,
        'full ROM shoulder transverse abduction'), // TODO: while true for rearDeltFly, didn't check the others
    ProgramGroup.lowerTraps: Assign(1,
        'scapular retraction (maybe: isometric scapular depression depending on technique)'),
    ProgramGroup.middleTraps: Assign(1, 'scapular retraction'),
    ProgramGroup.wristExtensors: Assign(0.3, 'isometric'),
    ProgramGroup.wristFlexors: Assign(0.3, 'isometric'),
  }),
  const VolumeAssignment([
    EBase.benchPressBB,
    EBase.chestPressMachine,
    EBase.dip,
  ], {
    ProgramGroup.lowerPecs: Assign(1),
    ProgramGroup.upperPecs: Assign(1),
    ProgramGroup.frontDelts: Assign(1),
    ProgramGroup.tricepsMedLatH: Assign(1, 'elbow extension'),
    ProgramGroup.tricepsLongHead: Assign(0.25),
    ProgramGroup.wristExtensors: Assign(0.25, 'isometric'),
    ProgramGroup.wristFlexors: Assign(0.25, 'isometric'),
  }),
  const VolumeAssignment([
    EBase.pushUp,
  ], {
    ProgramGroup.lowerPecs: Assign(1, 'horizontal shoulder adduction/flexion'),
    ProgramGroup.upperPecs:
        Assign(1, 'horizontal shoulder adduction/flexion + shoulder flexion'),
    ProgramGroup.frontDelts: Assign(1, 'horizontal shoulder flexion'),
    ProgramGroup.tricepsMedLatH: Assign(1, 'elbow extension'),
    ProgramGroup.tricepsLongHead: Assign(0.25),
    ProgramGroup.abs: Assign(1, 'isometric'),
  }),
  const VolumeAssignment([
    EBase.benchPressDB,
    EBase.chestPressCable,
  ], {
    ProgramGroup.lowerPecs: Assign(1),
    ProgramGroup.upperPecs: Assign(1),
    ProgramGroup.frontDelts: Assign(1),
    ProgramGroup.tricepsMedLatH: Assign(0.5, 'elbow extension'),
    ProgramGroup.wristExtensors: Assign(0.25, 'isometric'),
    ProgramGroup.wristFlexors: Assign(0.25, 'isometric'),
  }),
  // TODO: differentiate lower and upper pecs
  const VolumeAssignment([
    EBase.fly,
    EBase.pecDeckHandGrip,
  ], {
    ProgramGroup.lowerPecs: Assign(1),
    ProgramGroup.upperPecs: Assign(1),
    ProgramGroup.frontDelts: Assign(1, 'full ROM horizontal shoulder flexion'),
    ProgramGroup.wristFlexors: Assign(0.5, 'isometric'),
  }),
  const VolumeAssignment([
    EBase.flyShoulderExt,
  ], {
    ProgramGroup.lowerPecs: Assign(1, 'full ROM horizontal shoulder adduction'),
    ProgramGroup.upperPecs: Assign(1, 'full ROM horizontal shoulder adduction'),
    ProgramGroup.frontDelts:
        Assign(0.5, 'full ROM horizontal shoulder adduction (weak)'),
    ProgramGroup.wristFlexors: Assign(0.5, 'isometric'),
  }),
  const VolumeAssignment([
    EBase.pecDeckElbowPad
  ], {
    ProgramGroup.lowerPecs: Assign(1),
    ProgramGroup.upperPecs: Assign(1),
    ProgramGroup.frontDelts: Assign(1),
  }),

  const VolumeAssignment([
    EBase.overheadPressBB
  ], {
    ProgramGroup.upperPecs: Assign(0.25),
    ProgramGroup.frontDelts:
        Assign(0.8, 'some shoulder flexion/abduction, based on grip width'),
    ProgramGroup.sideDelts: Assign(1, 'full ROM shoulder abduction'),
    ProgramGroup.lowerTraps: Assign(0.25),
    ProgramGroup.middleTraps: Assign(0.25),
    ProgramGroup.upperTraps: Assign(0.25),
    ProgramGroup.tricepsMedLatH: Assign(0.75,
        'elbow extension'), // TODO: normally should be 1 but i think i read somewhere they don't activate well for most people
    ProgramGroup.tricepsLongHead: Assign(0.25),
    ProgramGroup.abs: Assign(0.25),
    ProgramGroup.wristExtensors: Assign(0.25, 'isometric'),
    ProgramGroup.wristFlexors: Assign(0.25, 'isometric'),
  }),
  const VolumeAssignment([
    EBase.overheadPressDB,
  ], {
    ProgramGroup.upperPecs: Assign(0.25),
    ProgramGroup.frontDelts: Assign(1, 'shoulder flexion/abduction'),
    ProgramGroup.sideDelts: Assign(1, 'full ROM shoulder abduction'),
    ProgramGroup.lowerTraps: Assign(0.25),
    ProgramGroup.middleTraps: Assign(0.25),
    ProgramGroup.upperTraps: Assign(0.25),
    ProgramGroup.tricepsMedLatH: Assign(0.5, 'elbow extension'),
    ProgramGroup.abs: Assign(0.25),
    ProgramGroup.wristExtensors: Assign(0.25, 'isometric'),
    ProgramGroup.wristFlexors: Assign(0.25, 'isometric'),
  }),
  const VolumeAssignment([
    EBase.lateralRaise
  ], {
    ProgramGroup.upperPecs: Assign(0.25),
    ProgramGroup.sideDelts:
        Assign(1, 'full ROM shoulder abduction with full loaded stretch'),
    ProgramGroup.rearDelts: Assign(0.25),
    ProgramGroup.lowerTraps: Assign(0.25),
    ProgramGroup.middleTraps: Assign(0.25),
    ProgramGroup.upperTraps: Assign(0.25),
    ProgramGroup.wristExtensors: Assign(0.3, 'isometric'),
  }),
  const VolumeAssignment([
    EBase.shrug
  ], {
    ProgramGroup.upperTraps: Assign(1, 'scapular elevation'),
    ProgramGroup.wristExtensors: Assign(0.5, 'isometric'),
    ProgramGroup.wristFlexors: Assign(0.5, 'isometric'),
  }),
  const VolumeAssignment([
    EBase.tricepExtension // TODO: classify based on shoulder position?
  ], {
    ProgramGroup.tricepsMedLatH: Assign(1, 'elbow extension'),
    ProgramGroup.tricepsLongHead: Assign(1, 'elbow extension'),
    ProgramGroup.wristFlexors: Assign(0.25, 'isometric'),
    ProgramGroup.wristExtensors: Assign(0.25, 'isometric'),
  }),
  const VolumeAssignment([
    EBase.tricepExtensionOverhead
  ], {
    ProgramGroup.tricepsMedLatH: Assign(1, 'elbow extension'),
    ProgramGroup.tricepsLongHead:
        Assign(1, 'elbow extension (medium to long length)'),
    ProgramGroup.wristFlexors: Assign(0.25, 'isometric'),
    ProgramGroup.wristExtensors: Assign(0.25, 'isometric'),
  }),
  /* overhead 40% more growth than pushdown: https://pubmed.ncbi.nlm.nih.gov/35819335/
  50% for long head
  40% more growth for the other two
  due to more tension on all heads
  -> skull overs, skull crushers (elbows!)

  kickbacks, pushdowns not so great
  */
  const VolumeAssignment([
    EBase.bicepCurl
  ], {
    ProgramGroup.biceps: Assign(1,
        'elbow flexion @ anatomic position (strongest)'), // TODO: not true for all curls! but good enough for exam
    ProgramGroup.wristFlexors: Assign(0.25, 'isometric'),
  }),
  const VolumeAssignment(
    [EBase.abCrunch],
    {ProgramGroup.abs: Assign(1, 'full ROM')},
  ),
  const VolumeAssignment(
    [EBase.abIsometric],
    {ProgramGroup.abs: Assign(1, 'isometric')},
  ),
  const VolumeAssignment(
    [EBase.wristExtension],
    {ProgramGroup.wristExtensors: Assign(1, 'active ROM')},
  ),
  const VolumeAssignment(
    [EBase.wristFlexion],
    {ProgramGroup.wristFlexors: Assign(1, 'active ROM')},
  ),
];

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
// lat prayer                                v
//

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
/* TODO
add accessory things like dead hangs (shoulder health, grip) and holds (grip)
*/

/*
TODO
how to validate that each day is similarly intense? e.g.
- every day is a mix of some intense compounds and some lighter work
- or every day has a mix of low and high reps
*/
