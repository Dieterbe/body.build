import 'package:bodybuild/data/dataset/articulation.dart';
import 'package:bodybuild/data/dataset/bone.dart';
import 'package:bodybuild/model/dataset/movement.dart';
import 'package:bodybuild/data/dataset/muscle.dart';

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
