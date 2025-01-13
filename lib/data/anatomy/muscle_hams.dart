import 'package:bodybuild/data/anatomy/articulations.dart';
import 'package:bodybuild/data/anatomy/bones.dart';
import 'package:bodybuild/model/anatomy/movements.dart';
import 'package:bodybuild/data/anatomy/muscles.dart';

final hamstrings = MultiHeadMuscle(
  id: MuscleId.hamstrings,
  categories: [MuscleCategory.hams],
  nick: ['hams', 'hammies'],
  insertion: Bone.tibiaFibula,
  movements: [
    const Movement(
      articulation: Articulation.kneeFlexion,
      rangeStart: 0,
      rangeEnd: 150,
      strength: 6,
      // leverage is constant until 90, then bending further greatly reduces leverage
      // http://doi.org/10.1016/S0268-0033(98)00055-2

      // all heads produce most tension in anatomic position
      // gradual loss of force at greater / smaller length (so U curve)
      // all heads losee all their force when fully stretched/extended
      // except for semitendinosus.
      // the hammies, specifically the semimembranosus and long head of bicepis femoris
      // have possitve insufficiency when stretched to near max @ both joints
      // (straight legs and flexed hips)
      // full contraction -> active insufficiency
      // leg curls -> avoid full hip extension
      // hip extension -> avoid knees bent
      //
    )
  ],
  headsMap: {
    MuscleId.bicepsFemorisShortHead: const Head(
      id: MuscleId.bicepsFemorisShortHead,
      name: 'biceps femoris, short head',
      origin: [Bone.femur],
      movements: [
        Movement(
          articulation: Articulation.kneeExternalRotation,
          strength: 6,
          rangeStart: 0,
          rangeEnd: 30,
        ),
      ],
    ),
    MuscleId.bicepsFemorisLongHead: const Head(
      id: MuscleId.bicepsFemorisLongHead,
      name: 'biceps femoris, long head',
      articular: 2,
      origin: [Bone.hip],
      movements: [
        Movement(
          articulation: Articulation.hipExtension,
          strength: 6,
          rangeStart: 120,
          rangeEnd: -20, // when going into hyperextension becomes weak
          momentMax: 45, // decreases substantially in higher/lower flexion
        ),
        Movement(
          articulation: Articulation.kneeExternalRotation,
          strength: 6,
          rangeStart: 0,
          rangeEnd: 30,
        ),
      ],
    ),
    MuscleId.semitendinosus: const Head(
      id: MuscleId.semitendinosus,
      name: 'semitendinosus',
      articular: 2,
      origin: [Bone.hip],
      movements: [
        Movement(
          articulation: Articulation.hipExtension,
          strength: 6,
          rangeStart: 120,
          rangeEnd: -20, // when going into hyperextension becomes weak
          momentMax: 45, // decreases substantially in higher/lower flexion
        ),
        Movement(
          articulation: Articulation.kneeInternalRotation,
          strength: 6,
          rangeStart: 0,
          rangeEnd: 10,
        ),
      ],
    ),
    MuscleId.semimembranosus: const Head(
      id: MuscleId.semimembranosus,
      name: 'semimembranosus',
      articular: 2,
      origin: [Bone.hip],
      movements: [
        Movement(
          articulation: Articulation.hipExtension,
          strength: 6,
          rangeStart: 120,
          rangeEnd: -20, // when going into hyperextension becomes weak
          momentMax: 45, // decreases substantially in higher/lower flexion
        ),
        Movement(
          articulation: Articulation.kneeInternalRotation,
          strength: 6,
          rangeStart: 0,
          rangeEnd: 10,
        ),
      ],
    )
  },
);
