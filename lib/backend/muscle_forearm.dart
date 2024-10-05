// extracurricular https://www.sciencedirect.com/topics/engineering/brachioradialis
// some of the details might be incorrect
import 'package:ptc/backend/articulations.dart';
import 'package:ptc/backend/bones.dart';
import 'package:ptc/backend/movements.dart';
import 'package:ptc/backend/muscles.dart';

final forearmPronators = Muscle(
  pseudo: true,
  nick: [],
  insertion: Bone.radioUlnarJoint,
  movements: [
    const Movement(
      articulation: Articulation.forearmPronation,
      rangeStart: -85,
      rangeEnd: 75,
      strength: 5,
    ),
  ],
  heads: {
    'whole': const Head(
      name: 'whole',
      nick: [],
      origin: [
        Bone.humerus,
      ],
      articular: 1,
      movements: [],
    )
  },
);

final wristExtensors = Muscle(
  nick: [],
  pseudo: true,
  insertion: Bone.hand,
  heads: {},
  movements: [
    Movement(
      articulation: Articulation.wristExtension,
      strength: 6,
      rangeStart: 0,
      rangeEnd: 80,
    ),
  ],
);
final wristFlexors = Muscle(
  nick: [],
  pseudo: true,
  insertion: Bone.hand,
  heads: {},
  movements: [
    Movement(
      articulation: Articulation.wristFlexion,
      strength: 6,
      rangeStart: 0,
      rangeEnd: 90,
    ),
  ],
);
