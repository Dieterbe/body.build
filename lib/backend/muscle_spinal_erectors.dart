// spinal erectors aka erector spinae
// group of muscles that stabilize the vertebral column
import 'package:ptc/backend/articulations.dart';
import 'package:ptc/backend/bones.dart';
import 'package:ptc/backend/movements.dart';
import 'package:ptc/backend/muscles.dart';

final erectorSpinae = Muscle(
  nick: [],
  pseudo: false,
  insertion: Bone.spine,
  movements: [
    const Movement(
      articulation: Articulation.spinalExtension,
      rangeStart: 85,
      rangeEnd: 0,
      strength: 6,
    ),
    const Movement(
      articulation: Articulation.spinalHyperextension,
      rangeStart: 0,
      rangeEnd: -25,
      strength: 6,
    ),
  ],
  heads: {
    // the biggest one
    'longissimus': const Head(
      nick: [],
      movements: [
        Movement(
          articulation: Articulation.cervicalSpineLateralFlexion,
          strength: 4,
          rangeStart: 0,
          rangeEnd: 45,
        ),
        Movement(
          articulation: Articulation.cervicalSpineRotation,
          strength: 2,
          rangeStart: 0,
          rangeEnd: 80,
        )
      ],
      name: 'longissimus',
      articular: 1,
      origin: [Bone.spine],
    ),
    // most lateral (outside)

    'iliocostalis': const Head(
      nick: [],
      movements: [
        Movement(
          articulation: Articulation.spinalLateralFlexion,
          strength: 4,
          rangeStart: 0,
          rangeEnd: 45,
        ),
        Movement(
          articulation: Articulation.spinalRotationLumbarThoracic,
          strength: 2,
          rangeStart: 0,
          rangeEnd: 80,
        )
      ],
      name: 'iliocostalis',
      articular: 1,
      origin: [Bone.iliacCrest],
    ),
    // closest to spine (medial)

    'spinalis': const Head(
      nick: [],
      movements: [
        Movement(
          articulation: Articulation.cervicalSpineLateralFlexion,
          strength: 4,
          rangeStart: 0,
          rangeEnd: 45,
        ),
        Movement(
          articulation: Articulation.cervicalSpineRotation,
          strength: 2,
          rangeStart: 0,
          rangeEnd: 80,
        )
      ],
      name: 'spinalis',
      articular: 1,
      origin: [Bone.spine],
    )
  },
);
