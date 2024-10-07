// extracurricular https://www.sciencedirect.com/topics/engineering/brachioradialis
// some of the details might be incorrect
import 'package:ptc/backend/articulations.dart';
import 'package:ptc/backend/bones.dart';
import 'package:ptc/backend/movements.dart';
import 'package:ptc/backend/muscles.dart';

final forearmPronators = SingleHeadMuscle(
  id: MuscleId.forearmPronators,
  categories: [MuscleCategory.forearm],
  pseudo: true,
  insertion: Bone.radioUlnarJoint,
  movements: [
    const Movement(
      articulation: Articulation.forearmPronation,
      rangeStart: -85,
      rangeEnd: 75,
      strength: 5,
    ),
  ],
  origin: [Bone.humerus],
);

final wristExtensors = SingleHeadMuscle(
  id: MuscleId.wristExtensors,
  categories: [MuscleCategory.forearm],
  pseudo: true,
  origin: [Bone.radius], // just a guess
  insertion: Bone.hand,
  movements: [
    const Movement(
      articulation: Articulation.wristExtension,
      strength: 6,
      rangeStart: 0,
      rangeEnd: 80,
    ),
  ],
);
final wristFlexors = SingleHeadMuscle(
  id: MuscleId.wristFlexors,
  categories: [MuscleCategory.forearm],
  pseudo: true,
  origin: [Bone.radius], // just a guess
  insertion: Bone.hand,
  movements: [
    const Movement(
      articulation: Articulation.wristFlexion,
      strength: 6,
      rangeStart: 0,
      rangeEnd: 90,
    ),
  ],
);
