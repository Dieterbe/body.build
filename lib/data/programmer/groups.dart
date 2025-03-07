//  Straight-arm pulldowns can stimulate higher muscle activity in the long head of triceps than barbell bench presses.
// https://www.scielo.br/j/motriz/a/jbfGfJrRsXbfc9BrfXgVSPy/?lang=en

import 'package:bodybuild/data/anatomy/muscles.dart';

// muscle groups for the purpose of training
// * uses a bit more "common language" (e.g. biceps to mean elbow flexors)
// * grouped based on whether they are trained together in exercises,
//   which differs from the anatomical categorization:
//   sometimes heads from the same muscle, or muscles from the same anatomical
//   group are not trained together; and likewise
//   training a certain group may involve specific heads or muscles belonging to
//   different groups or categories can contain heads and/or muscles,
//   in which case they should be "expanded" to mean to include all their heads

class Assign {
  final double volume;
  final bool multiplied;
  final String? modality; // work in progress
  const Assign(this.volume, [this.modality]) : multiplied = false;
  const Assign.merged(this.volume, this.multiplied, [this.modality]);

  Assign merge(Assign other) {
    final mergedModality = switch ((modality, other.modality)) {
      (null, null) => null,
      (String value, null) => value,
      (null, String value) => value,
      (String a, String b) => '$a, $b'
    };
    double newVolume;
    bool newMultiplied;
    if (volume == 0) {
      // if we didn't have a volume assignment yet, just use the new one
      newVolume = other.volume;
      newMultiplied = false;
    } else {
      // if we did, they are "multipliers" to one another.
      newVolume = volume * other.volume;
      newMultiplied = true;
    }

    if (newVolume > 1) {
      // in march 2025 this should never happen
      // in the future, we may want to allow it (to support extra-ordinary activation, e.g. eccentric overloading i think was an example. maybe also for leg curl with flexed hip)
      print('WARNING: Assign.merge -> volume > 1: $newVolume');
    }
    return Assign.merged(newVolume, newMultiplied, mergedModality);
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
