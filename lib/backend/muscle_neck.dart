import 'package:ptc/backend/articulations.dart';
import 'package:ptc/backend/bones.dart';
import 'package:ptc/backend/movements.dart';
import 'package:ptc/backend/muscles.dart';

final neckFlexors = SingleHeadMuscle(
  pseudo: true,
  insertion: Bone.spineCervical,
  origin: [Bone.spineCervical],
  movements: [
    const Movement(
      articulation: Articulation.cervicalSpineFlexion,
      strength: 6,
      rangeStart: 0,
      rangeEnd: 40,
    ),
  ],
);
final neckExtensors = SingleHeadMuscle(
  pseudo: true,
  insertion: Bone.spineCervical,
  origin: [Bone.spineCervical],
  movements: [
    const Movement(
      articulation: Articulation.cervicalSpineExtension,
      strength: 6,
      rangeStart: 0,
      rangeEnd: 35,
    ),
  ],
);
