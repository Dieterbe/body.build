import 'package:bodybuild/data/dataset/articulations.dart';
import 'package:bodybuild/data/dataset/bones.dart';
import 'package:bodybuild/model/dataset/movements.dart';
import 'package:bodybuild/data/dataset/muscles.dart';

final neckFlexors = SingleHeadMuscle(
  id: MuscleId.neckFlexors,
  categories: [MuscleCategory.neck],
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
  id: MuscleId.neckExtensors,
  categories: [MuscleCategory.neck],
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
