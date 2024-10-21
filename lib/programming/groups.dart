//  Straight-arm pulldowns can stimulate higher muscle activity in the long head of triceps than barbell bench presses.
// https://www.scielo.br/j/motriz/a/jbfGfJrRsXbfc9BrfXgVSPy/?lang=en

import 'package:ptc/anatomy/muscles.dart';

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
  final String match;
  final Map<ProgramGroup, double> assign;
  const VolumeAssignment(this.match, this.assign);
}

List<VolumeAssignment> volumeAssignments = [
  const VolumeAssignment(
    'powerlift deadlift',
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
    'romanian deadlift',
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
    'goodmorning',
    {
      ProgramGroup.spinalErectors: 1,
      ProgramGroup.hams: 1,
      ProgramGroup.gluteMax: 1,
      ProgramGroup.abs: 0.25,
    },
  ),
  const VolumeAssignment(
    'hip extension and pull-throughs', // incl 45 & 90 degree hip extension, reverse hyperextension,
    {
      ProgramGroup.spinalErectors: 0.25,
      ProgramGroup.hams: 1,
      ProgramGroup.gluteMax: 1,
    },
  ),
  const VolumeAssignment(
    'back extensions',
    {
      ProgramGroup.spinalErectors: 1,
      ProgramGroup.hams: 1,
      ProgramGroup.gluteMax: 1,
    },
  ),
  const VolumeAssignment('leg curl', {
    ProgramGroup.hamsShortHead: 1,
    ProgramGroup.hams: 1,
    ProgramGroup.gastroc: 1 // assuming full dorsiflexion
  }),
  const VolumeAssignment(
    'barbell squat', // Incl. High-bar back squats, low-bar back squats, front squats, goblet squats
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
    'leg press, hack squat, belt squat',
    {
      ProgramGroup.spinalErectors: 0.25,
      ProgramGroup.quadsVasti: 1,
      ProgramGroup.gluteMax: 1,
      ProgramGroup.soleus: 0.5, // 0.25 if shins stay vertical
    },
  ),
  const VolumeAssignment('bulgarian split squat', {
    ProgramGroup.spinalErectors: 0.5,
    ProgramGroup.quadsVasti: 1,
    ProgramGroup.quadsRectusFemoris: 1,
    ProgramGroup.gluteMax: 1,
    ProgramGroup.gluteMed: 0.5,
    ProgramGroup.soleus: 0.5, // 0.25 if shins stay vertical
    ProgramGroup.abs: 0.25,
  }), // has RF, others don't. so do we assume upright posture? (hip extension)
  const VolumeAssignment(
      'lunges, step-ups, Reverse deficit lunges, modified step-ups, pistols, sissy/Spanish squats on apparatus',
      {
        ProgramGroup.spinalErectors: 0.5,
        ProgramGroup.quadsVasti: 1,
        ProgramGroup.gluteMax: 1,
        ProgramGroup.gluteMed: 0.5,
        ProgramGroup.soleus: 0.5, // 0.25 if shins stay vertical
        ProgramGroup.abs: 0.25,
      }),
  const VolumeAssignment(
      'leg extension, reverse nordic ham curls, unassisted sissy squats', {
    ProgramGroup.quadsVasti: 1,
    ProgramGroup.quadsRectusFemoris: 1,
  }),
  const VolumeAssignment('hip thrust, glute kickback, pendulum kickbacks', {
    ProgramGroup.quadsVasti:
        0.5, // depends.. more knee flexion -> more vasti involved
    ProgramGroup.gluteMax: 1,
  }),
  const VolumeAssignment('hip abduction with hip flexed', {
    ProgramGroup.gluteMax: 0.5, // upper fibers only
    ProgramGroup.gluteMed: 0.25,
  }),
  const VolumeAssignment('hip abduction', {
    ProgramGroup.gluteMed: 1,
  }),
  const VolumeAssignment('standing calf raise, calf jumps', {
    ProgramGroup.gastroc: 1,
    ProgramGroup.soleus: 1,
  }),
  const VolumeAssignment('seated calf raise', {
    ProgramGroup.gastroc: 0.25,
    ProgramGroup.soleus: 1,
  }),
  const VolumeAssignment(
      'chin-up, pull down, neutral grip chinup/pull down, diagonal rows', {
    ProgramGroup.lowerPecs: 0.25,
    ProgramGroup.rearDelts: 1,
    ProgramGroup.lowerTraps: 1,
    ProgramGroup.middleTraps: 0.75,
    ProgramGroup.lats: 1,
    ProgramGroup.biceps: 1,
  }),
  const VolumeAssignment('pull-up, wide pull down', {
    ProgramGroup.lowerPecs: 0.5,
    ProgramGroup.rearDelts: 0.25,
    ProgramGroup.lowerTraps: 1,
    ProgramGroup.middleTraps: 0.25,
    ProgramGroup.lats: 1,
    ProgramGroup.biceps: 1,
  }),
  const VolumeAssignment('cable row with spinal flexion, bent over rows', {
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
  const VolumeAssignment('pull-over, lat prayer', {
    ProgramGroup.lowerPecs: 0.5,
    ProgramGroup.rearDelts: 1,
    ProgramGroup.lats: 1,
    ProgramGroup.tricepsLongHead: 1,
  }),
  const VolumeAssignment(
      'high row, rear delt fly, side lying rear delt raises, shoulder pulls, face pulls',
      {
        ProgramGroup.rearDelts: 1,
        ProgramGroup.lowerTraps: 1,
        ProgramGroup.middleTraps: 1,
      }),
  const VolumeAssignment('barbell bench press, machine chest press, push-up', {
    ProgramGroup.lowerPecs: 1,
    ProgramGroup.upperPecs: 1,
    ProgramGroup.frontDelts: 1,
    ProgramGroup.triceps: 1,
    ProgramGroup.tricepsLongHead: 0.25,
  }),
  const VolumeAssignment(
      'dumbbell bench press, 15 incline dumbbell press, cable chest press', {
    ProgramGroup.lowerPecs: 1,
    ProgramGroup.upperPecs: 1,
    ProgramGroup.frontDelts: 1,
    ProgramGroup.triceps: 0.5,
  }),
  const VolumeAssignment('chest fly, bayesian fly, pec deck', {
    ProgramGroup.lowerPecs: 1,
    ProgramGroup.upperPecs: 1,
    ProgramGroup.frontDelts: 1,
  }), // no diff in lower vs upper?
  const VolumeAssignment('barbell overhead press', {
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
  const VolumeAssignment('dumbbell overhead press', {
    ProgramGroup.upperPecs: 0.25,
    ProgramGroup.frontDelts: 1,
    ProgramGroup.sideDelts: 1,
    ProgramGroup.lowerTraps: 0.25,
    ProgramGroup.middleTraps: 0.25,
    ProgramGroup.upperTraps: 0.25,
    ProgramGroup.triceps: 0.5,
    ProgramGroup.abs: 0.25,
  }),
  const VolumeAssignment('lateral raise', {
    ProgramGroup.upperPecs: 0.25,
    ProgramGroup.frontDelts: 1,
    ProgramGroup.sideDelts: 1,
    ProgramGroup.lowerTraps: 0.25,
    ProgramGroup.middleTraps: 0.25,
    ProgramGroup.upperTraps: 0.25,
  }),
  const VolumeAssignment('shrug', {
    ProgramGroup.upperTraps: 1,
  }),
  const VolumeAssignment('tricep extension, skull-overs, tricep kickbacks',
      {ProgramGroup.triceps: 1, ProgramGroup.tricepsLongHead: 1}),
  const VolumeAssignment('bicep curl', {ProgramGroup.biceps: 1}),
  const VolumeAssignment('ab crunch', {ProgramGroup.abs: 1}),
];

// why no seperation in lats activation for rows vs prayers. various triceps extensions