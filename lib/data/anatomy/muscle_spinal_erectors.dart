// spinal erectors aka erector spinae
// group of muscles that stabilize the vertebral column
import 'package:ptc/data/anatomy/articulations.dart';
import 'package:ptc/data/anatomy/bones.dart';
import 'package:ptc/model/anatomy/movements.dart';
import 'package:ptc/data/anatomy/muscles.dart';

final erectorSpinaeSharedMovements = [
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
];
final longissimus = SingleHeadMuscle(
  id: MuscleId.longissimus,
  categories: [MuscleCategory.spinalErectors],
  // the biggest one
  insertion: Bone.spine,
  movements: [
    ...erectorSpinaeSharedMovements,
    const Movement(
      articulation: Articulation.cervicalSpineLateralFlexion,
      strength: 4,
      rangeStart: 0,
      rangeEnd: 45,
    ),
    const Movement(
      articulation: Articulation.cervicalSpineRotation,
      strength: 2,
      rangeStart: 0,
      rangeEnd: 80,
    )
  ],
  //name: 'longissimus',
  origin: [Bone.spine],
);
// most lateral (outside)
final iliocostalis = SingleHeadMuscle(
  id: MuscleId.iliocostalis,
  categories: [MuscleCategory.spinalErectors],
  movements: [
    ...erectorSpinaeSharedMovements,
    const Movement(
      articulation: Articulation.spineLateralFlexion,
      strength: 4,
      rangeStart: 0,
      rangeEnd: 45,
    ),
    const Movement(
      articulation: Articulation.lumbarThoracicSpineRotation,
      strength: 2,
      rangeStart: 0,
      rangeEnd: 80,
    )
  ],
  // name: 'iliocostalis',
  origin: [Bone.iliacCrest],
  insertion: Bone.spine,
);

// closest to spine (medial)
final spinalis = SingleHeadMuscle(
  id: MuscleId.spinalis,
  categories: [MuscleCategory.spinalErectors],
  movements: [
    ...erectorSpinaeSharedMovements,
    const Movement(
      articulation: Articulation.cervicalSpineLateralFlexion,
      strength: 4,
      rangeStart: 0,
      rangeEnd: 45,
    ),
    const Movement(
      articulation: Articulation.cervicalSpineRotation,
      strength: 2,
      rangeStart: 0,
      rangeEnd: 80,
    )
  ],
  //name: 'spinalis',
  origin: [Bone.spine],
  insertion: Bone.spine,
);
