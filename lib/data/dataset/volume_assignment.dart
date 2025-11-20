import 'package:bodybuild/data/dataset/assign.dart';
import 'package:bodybuild/data/dataset/program_group.dart';
import 'package:bodybuild/data/dataset/tweak.dart';

typedef VolumeAssignment = Map<ProgramGroup, Assign>;

const wrist025 = {
  ProgramGroup.wristExtensors: Assign(0.25, 'isometric'),
  ProgramGroup.wristFlexors: Assign(0.25, 'isometric'),
};

const wrist03 = {
  ProgramGroup.wristExtensors: Assign(0.3, 'isometric'),
  ProgramGroup.wristFlexors: Assign(0.3, 'isometric'),
};

const wrist05 = {
  ProgramGroup.wristExtensors: Assign(0.5, 'isometric'),
  ProgramGroup.wristFlexors: Assign(0.5, 'isometric'),
};

// Volume assignments for each exercise type
const vaGoodMorning = {
  ProgramGroup.spinalErectors: Assign(1, 'isometric'),
  ProgramGroup.hams: Assign(1, 'long length hip extension'),
  ProgramGroup.gluteMax: Assign(1, 'full ROM hip extension, less load when short & strongest'),
  ProgramGroup.abs: Assign(0.25, "intra abdominal pressure"),
  ProgramGroup.obliques: Assign(0.25, "intra oblique pressure"),
  ...wrist025,
};

final vaDeadliftRDL = {
  ...vaGoodMorning,
  ProgramGroup.upperTraps: const Assign(1, 'isometric'),
  ProgramGroup.lats: const Assign(0.25),
  ...wrist03,
};

final vaDeadlift = {
  ...vaDeadliftRDL,
  ProgramGroup.quadsVasti: const Assign(0.5, 'knee extension (depends on technique and build)'),
  ProgramGroup.hams: const Assign(0.75, 'hip extension'),
  ProgramGroup.gluteMax: const Assign(1, 'hip extension, less load when short & strongest'),
  ProgramGroup.soleus: const Assign(0.5),
};

const vaHipExtension = {
  ProgramGroup.spinalErectors: Assign(0.25),
  ProgramGroup.hams: Assign(1),
  ProgramGroup.gluteMax: Assign(1),
  ...wrist025,
};

const vaPullThrough = {
  ProgramGroup.spinalErectors: Assign(0.25),
  ProgramGroup.hams: Assign(1),
  ProgramGroup.gluteMax: Assign(1),
  ...wrist03,
};

const vaBackExtension = {
  ProgramGroup.spinalErectors: Assign(1, 'isometric or dynamic based on technique'),
  ProgramGroup.hams: Assign(1),
  ProgramGroup.gluteMax: Assign(1),
  ...wrist025,
};

const vaLegCurlHipFlexed = {
  ProgramGroup.hamsShortHead: Assign(1, 'full length'),
  ProgramGroup.hams: Assign(1, 'medium to long length knee flexion'),
  // according to https://pubmed.ncbi.nlm.nih.gov/33009197/ this is a much better growth stimulus than hip extended
};

const vaLegCurlHipExtended = {
  ProgramGroup.hamsShortHead: Assign(1, 'full length'),
  ProgramGroup.hams: Assign(1, 'knee flexion (short to medium length)'),
};

const vaGluteHamRaise = {
  ProgramGroup.spinalErectors: Assign(0.25),
  ProgramGroup.gluteMax: Assign(1),
  ...vaLegCurlHipExtended,
};
/*
squats and hamstrings -> https://pubmed.ncbi.nlm.nih.gov/9107637/
https://pubmed.ncbi.nlm.nih.gov/31230110/
you'll feel em bit, but they won't grow much..
*/

const vaSquatBBAndGoblet = {
  ProgramGroup.spinalErectors: Assign(1, 'isometric'),
  ProgramGroup.quadsVasti: Assign(1, 'knee extension'),
  ProgramGroup.gluteMax: Assign(1),
  ProgramGroup.hams: Assign(0.3, 'hip extension'),
  ProgramGroup.abs: Assign(0.25, "intra abdominal pressure"),
  ProgramGroup.obliques: Assign(0.25, "intra oblique pressure"),
  ...wrist03,
};

const vaLegPressSquatHackSquatBelt = {
  ProgramGroup.spinalErectors: Assign(0.25),
  ProgramGroup.quadsVasti: Assign(1, 'knee extension'),
  ProgramGroup.gluteMax: Assign(1),
  ProgramGroup.hams: Assign(0.3, 'hip extension'),
};

const vaSquatBSQ = {
  ProgramGroup.spinalErectors: Assign(0.5, 'isometric'),
  ProgramGroup.quadsVasti: Assign(1, 'knee extension'),
  ProgramGroup.gluteMax: Assign(
    1,
    'hip extension (from long to somewhat flexed still), less load when short & strongest',
  ),
  ProgramGroup.gluteMed: Assign(0.5, 'anti-adduction force'),
  ProgramGroup.hams: Assign(0.3, 'hip extension'),
  ProgramGroup.abs: Assign(0.25, "intra abdominal pressure"),
  ProgramGroup.obliques: Assign(0.25, "intra oblique pressure"),
};
const vaLungeStepUp = {
  ProgramGroup.spinalErectors: Assign(0.5, 'isometric'),
  ProgramGroup.quadsVasti: Assign(1, 'knee extension'),
  ProgramGroup.gluteMax: Assign(1),
  ProgramGroup.gluteMed: Assign(0.5),
  ProgramGroup.hams: Assign(0.3, 'hip extension'),
  ProgramGroup.abs: Assign(0.25, "intra abdominal pressure"),
  ProgramGroup.obliques: Assign(0.25, "intra oblique pressure"),
};
const vaSquatPistolSissyAssistedSpanish = {
  ProgramGroup.spinalErectors: Assign(0.5, 'isometric'),
  ProgramGroup.quadsVasti: Assign(1, 'knee extension'),
  ProgramGroup.gluteMax: Assign(1),
  ProgramGroup.gluteMed: Assign(0.5),
  ProgramGroup.hams: Assign(0.3, 'hip extension'),
  ProgramGroup.abs: Assign(0.25, "intra abdominal pressure"),
  ProgramGroup.obliques: Assign(0.25, "intra oblique pressure"),
};
const vaLegExtensionReverseNordicHamCurlSquatSissy = {
  ProgramGroup.quadsVasti: Assign(1, 'knee extension'),
};
const vaHipThrustGluteKickback = {ProgramGroup.gluteMax: Assign(1)};

final vaHipAbductionStraightHip = {
  // for exercises that use this EBase but don't use the tweak, we assume straight hip
  ...hipAbductionHipFlexion('0').opts['0']!.va,
};
const vaStandingCalfRaiseCalfJump = {
  ProgramGroup.gastroc: Assign(
    1,
    'ankle plantarflexion (medium to long length, stretched at knee)',
  ),
  ProgramGroup.soleus: Assign(1, 'ankle plantarflexion (full ROM)'),
};
const vaSeatedCalfRaise = {ProgramGroup.gastroc: Assign(0.25), ProgramGroup.soleus: Assign(1)};
/* Note, in the PTC course exercise library:
pull up -> grip just outside shoulder width
wide grip pull down -> grip just outside shoulder width
lat pull down -> not mentioned :?
this explains why pull up goes together with wide grip pull down
*/
const vaPulls = {
  ProgramGroup.lowerPecs: Assign(0.25),
  ProgramGroup.rearDelts: Assign(1),
  ProgramGroup.lowerTraps: Assign(1),
  ProgramGroup.middleTraps: Assign(0.75, 'scapular retraction'),
  ProgramGroup.lats: Assign(1),
  ProgramGroup.biceps: Assign(1),
  ...wrist05,
};
// TODO: add hanging leg raises? wrist stuff 0.5
// TODO confirm
const vaPullsWide = {
  ProgramGroup.lowerPecs: Assign(0.5),
  ProgramGroup.rearDelts: Assign(0.25),
  ProgramGroup.lowerTraps: Assign(1),
  ProgramGroup.middleTraps: Assign(0.25, 'scapular retraction'),
  ProgramGroup.lats: Assign(1),
  ProgramGroup.biceps: Assign(1, 'elbow flexion while weakened'),
  ...wrist05,
};
const vaRow = {
  // lats and spinal erectors are added via tweak!
  ProgramGroup.rearDelts: Assign(1),
  ProgramGroup.lowerTraps: Assign(1),
  ProgramGroup.middleTraps: Assign(1, 'scapular retraction'),
  ProgramGroup.biceps: Assign(0.5, 'elbow flexion while weakened'),
  ProgramGroup.tricepsLongHead: Assign(0.25),
  ...wrist05,
};
const vaRowWithoutSpine = {...vaRow, ProgramGroup.lats: Assign(1, 'not full stretch')};
// specifically, this is for standing rows where you hip hinge forward
const vaRowWithSpineIso = {
  ...vaRowWithoutSpine,
  ProgramGroup.spinalErectors: Assign(0.5, 'isometric'),
  ProgramGroup.hams: Assign(0.25),
  ProgramGroup.gluteMax: Assign(0.25),
};
const vaPullOverLatPrayer = {
  ProgramGroup.lowerPecs: Assign(0.5, 'full ROM shoulder extension (sometimes)'),
  ProgramGroup.rearDelts: Assign(1, 'full ROM shoulder extension'),
  ProgramGroup.lats: Assign(1, 'full ROM shoulder extension'),
  ProgramGroup.tricepsLongHead: Assign(1, 'full ROM shoulder extension (short to medium length)'),
  ...wrist03,
};
const vaHighRowRearDeltFlyRearDeltRaiseShoulderPullFacePull = {
  ProgramGroup.rearDelts: Assign(
    1,
    'full ROM shoulder transverse abduction',
  ), // TODO: while true for rearDeltFly, didn't check the others
  ProgramGroup.lowerTraps: Assign(
    1,
    'scapular retraction (maybe: isometric scapular depression depending on technique)',
  ),
  ProgramGroup.middleTraps: Assign(1, 'scapular retraction'),
  ...wrist03,
};
const vaBenchPressBBChestPressMachineDip = {
  ProgramGroup.lowerPecs: Assign(1),
  ProgramGroup.upperPecs: Assign(1),
  ProgramGroup.frontDelts: Assign(1),
  ProgramGroup.tricepsMedLatH: Assign(1, 'elbow extension'),
  ProgramGroup.tricepsLongHead: Assign(0.25),
  ...wrist025,
};
const vaRingDip = {
  ProgramGroup.lowerPecs: Assign(1),
  ProgramGroup.upperPecs: Assign(1),
  ProgramGroup.frontDelts: Assign(1),
  ProgramGroup.tricepsMedLatH: Assign(1, 'elbow extension'),
  ProgramGroup.tricepsLongHead: Assign(0.25),
  ...wrist05,
};

const vaPushUp = {
  ProgramGroup.lowerPecs: Assign(1, 'horizontal shoulder adduction/flexion'),
  ProgramGroup.upperPecs: Assign(1, 'horizontal shoulder adduction/flexion + shoulder flexion'),
  ProgramGroup.frontDelts: Assign(1, 'horizontal shoulder flexion'),
  ProgramGroup.tricepsMedLatH: Assign(1, 'elbow extension'),
  ProgramGroup.tricepsLongHead: Assign(0.25),
  ProgramGroup.abs: Assign(1, 'isometric'),
  ProgramGroup.obliques: Assign(0.25, 'intra abdominal pressure'),
};
const vaBenchPressDBChestPressCable = {
  ProgramGroup.lowerPecs: Assign(1),
  ProgramGroup.upperPecs: Assign(1),
  ProgramGroup.frontDelts: Assign(1),
  ProgramGroup.tricepsMedLatH: Assign(0.5, 'elbow extension'),
  ...wrist025,
};
const vaFlyPecDeckHandGrip = {
  // most real muscle recruitments are set via the `flyThumbs` tweak
  ProgramGroup.wristFlexors: Assign(0.5, 'isometric'),
};
const vaPecDeckElbowPad = {
  ProgramGroup.lowerPecs: Assign(1),
  ProgramGroup.upperPecs: Assign(1),
  ProgramGroup.frontDelts: Assign(1),
};
const vaOverheadPressBB = {
  ProgramGroup.upperPecs: Assign(0.25),
  ProgramGroup.frontDelts: Assign(0.8, 'some shoulder flexion/abduction, based on grip width'),
  ProgramGroup.sideDelts: Assign(1, 'full ROM shoulder abduction'),
  ProgramGroup.lowerTraps: Assign(0.25),
  ProgramGroup.middleTraps: Assign(0.25),
  ProgramGroup.upperTraps: Assign(0.25),
  ProgramGroup.tricepsMedLatH: Assign(
    0.75,
    'elbow extension',
  ), // TODO: normally should be 1 but i think i read somewhere they don't activate well for most people
  ProgramGroup.tricepsLongHead: Assign(0.25),
  ProgramGroup.abs: Assign(0.25, 'intra abdominal pressure'),
  ProgramGroup.obliques: Assign(0.25, 'intra oblique pressure'),
  ...wrist025,
};
const vaOverheadPressDB = {
  ProgramGroup.upperPecs: Assign(0.25),
  ProgramGroup.frontDelts: Assign(1, 'shoulder flexion/abduction'),
  ProgramGroup.sideDelts: Assign(1, 'full ROM shoulder abduction'),
  ProgramGroup.lowerTraps: Assign(0.25),
  ProgramGroup.middleTraps: Assign(0.25),
  ProgramGroup.upperTraps: Assign(0.25),
  ProgramGroup.tricepsMedLatH: Assign(0.5, 'elbow extension'),
  ProgramGroup.abs: Assign(0.25, 'intra abdominal pressure'),
  ProgramGroup.obliques: Assign(0.25, 'intra oblique pressure'),
  ...wrist025,
};
const vaBTNPressBB = {
  ProgramGroup.upperPecs: Assign(
    0.2,
  ), // low pec activity during pure abduction. see https://www.frontiersin.org/journals/physiology/articles/10.3389/fphys.2022.825880/full
  ProgramGroup.frontDelts: Assign(0.5, 'some shoulder abduction while externally rotated'),
  ProgramGroup.sideDelts: Assign(1, 'full ROM shoulder abduction'),
  ProgramGroup.rearDelts: Assign(0.25, 'shoulder abduction'),
  ProgramGroup.lowerTraps: Assign(0.25),
  ProgramGroup.middleTraps: Assign(0.25),
  ProgramGroup.upperTraps: Assign(0.25),
  ProgramGroup.tricepsMedLatH: Assign(
    0.75,
    'elbow extension',
  ), // TODO: normally should be 1 but i think i read somewhere they don't activate well for most people
  ProgramGroup.tricepsLongHead: Assign(0.25),
  ProgramGroup.abs: Assign(0.25, 'intra abdominal pressure'),
  ProgramGroup.obliques: Assign(0.25, 'intra oblique pressure'),
  ...wrist025,
};
const vaLateralRaise = {
  ProgramGroup.upperPecs: Assign(0.25),
  ProgramGroup.sideDelts: Assign(1, 'full ROM shoulder abduction with full loaded stretch'),
  ProgramGroup.lowerTraps: Assign(0.25),
  ProgramGroup.middleTraps: Assign(0.25),
  ProgramGroup.upperTraps: Assign(0.25),
  ProgramGroup.wristExtensors: Assign(0.3, 'isometric'),
};
const vaFrontRaise = {
  ProgramGroup.upperPecs: Assign(1, "shoulder flexion"),
  ProgramGroup.biceps: Assign(0.2, "shoulder flexion"),
  ProgramGroup.frontDelts: Assign(1, "shoulder flexion"),
};
const vaShrug = {ProgramGroup.upperTraps: Assign(1, 'scapular elevation'), ...wrist05};
// TODO: classify based on shoulder position?
const vaTricepExtension = {
  ProgramGroup.tricepsMedLatH: Assign(1, 'elbow extension'),
  ProgramGroup.tricepsLongHead: Assign(1, 'elbow extension'),
  ...wrist025,
};
const vaTricepExtensionOverhead = {
  ProgramGroup.tricepsMedLatH: Assign(1, 'elbow extension'),
  ProgramGroup.tricepsLongHead: Assign(1, 'elbow extension (medium to long length)'),
  ...wrist025,
};
/* overhead 40% more growth than pushdown: https://pubmed.ncbi.nlm.nih.gov/35819335/
  50% for long head
  40% more growth for the other two
  due to more tension on all heads
  -> skull overs, skull crushers (elbows!)

  kickbacks, pushdowns not so great
  */
/* moment arm for elbow flexion
  for all elbow flexors -> optimal when elbow 90°. 
  bicep improves moment arm via supination
  for brachioradialis it's in neutral (hammer) grip
  muscles are strongest near anatomical, and get much weaker when shortened
  bicep short head is insufficient @ max stretch and full contraction
  */
const vaBicepCurlAnatomic = {
  ProgramGroup.biceps: Assign(
    1,
    'elbow flexion with loading at mid-point, in anatomic position (strongest)',
  ),
  ProgramGroup.wristFlexors: Assign(0.25, 'isometric'),
};
const vaBicepCurlBayesian = {
  ProgramGroup.biceps: Assign(
    1,
    'elbow flexion with loading on all lengths, in anatomic position (strongest)',
  ),
  ProgramGroup.wristFlexors: Assign(0.25, 'isometric'),
};
const vaBicepCurlPreacher = {
  ProgramGroup.biceps: Assign(
    1,
    'elbow flexion with loading at longer length, but shortened (weakened)',
  ),
  ProgramGroup.wristFlexors: Assign(0.25, 'isometric'),
};
const vaBicepCurlConcentration = {
  ProgramGroup.biceps: Assign(1, 'elbow flexion with loading at mid-point, shortened (weakened)'),
  ProgramGroup.wristFlexors: Assign(0.25, 'isometric'),
};
const vaBicepCurlLying = {
  ProgramGroup.biceps: Assign(1, 'elbow flexion with loading at longer length, while stretched'),
  ProgramGroup.wristFlexors: Assign(0.25, 'isometric'),
};
const vaAbCrunch = {ProgramGroup.abs: Assign(1, 'full ROM')};
const vaAbIsometric = {ProgramGroup.abs: Assign(1, 'isometric')};
const vaOblRotationIso = {ProgramGroup.obliques: Assign(1, 'spine rotation isometric')};
const vaOblRotation = {ProgramGroup.obliques: Assign(1, 'spine rotation')};
const vaWristExtension = {ProgramGroup.wristExtensors: Assign(1, 'active ROM')};
const vaWristFlexion = {ProgramGroup.wristFlexors: Assign(1, 'active ROM')};

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
// cable/dumbbell presses
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
bench press (inclide, decline, barbell, dumbbell)
pull-downs (chinup, neutral grip, wide, etc), also assisted vs unassisted
pull-ups (chinup, neutral grip, wide, etc)

for volume assignments, we use
- exact names (e.g. dumbbell overhead press). i guess you can always split up further. seated, standing, maybe unilateral though that could be an execution specific thing that is orthogonal to the exercise, etc
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
