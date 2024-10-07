import 'package:ptc/backend/articulations.dart';
import 'package:ptc/backend/bones.dart';
import 'package:ptc/backend/movements.dart';
import 'package:ptc/backend/muscles.dart';

final rectusAbdominis = SingleHeadMuscle(
  categories: [MuscleCategory.abs],
  id: MuscleId.rectusAbdominis,
  insertion: Bone.sternum,

  nick: ['sixpack'],
  movements: [
    const Movement(
      articulation: Articulation.spineFlexion,
      strength: 4,
      rangeStart: 0,
      rangeEnd: 85,
    ),
    const Movement(
      articulation: Articulation.intraAbdominalPressure,
      strength: 4,
    ),
  ],
  //name: 'rectus abdominis',
  // inserts into sternum
  origin: [Bone.pelvis, Bone.pubicCrest],
);
final externalObliques = SingleHeadMuscle(
  // lateral
  categories: [MuscleCategory.abs],
  id: MuscleId.externalObliques,
  insertion: Bone.pubicCrest,
  movements: [
    const Movement(
      articulation: Articulation.spineFlexion,
      strength: 4,
      rangeStart: 0,
      rangeEnd: 85,
    ),
    const Movement(
      articulation: Articulation.spineLateralFlexion,
      strength: 4,
      rangeStart: 0,
      rangeEnd: 40,
    ),
    const Movement(
      articulation: Articulation.spineRotation,
      strength: 2,
      rangeStart: 0,
      rangeEnd: 40,
    ),
    const Movement(
      articulation: Articulation.intraAbdominalPressure,
      strength: 6,
    ),
  ],
  // the below 2 are inner, invisible
  // name: 'external obliques',
  // insert into iliciac Crest, pubic crest
  origin: [Bone.lowerRibs],
);
// inner & invisible
final internalObliques = SingleHeadMuscle(
  //  'internal obliques': const Head(
  categories: [MuscleCategory.abs],
  id: MuscleId.externalObliques,
  movements: [],
  // name: 'internal obliques',
  origin: [Bone.spine],
  insertion: Bone.pubicCrest,
);
final transverseAbdominis = SingleHeadMuscle(
  // inner & invisible
  categories: [MuscleCategory.abs],
  id: MuscleId.transverseAbdominis,
  movements: [],
  // name: 'transverse abdominis',
  origin: [Bone.spine],
  insertion: Bone.pubicCrest,
);
