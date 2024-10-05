import 'package:ptc/backend/articulations.dart';
import 'package:ptc/backend/bones.dart';
import 'package:ptc/backend/movements.dart';
import 'package:ptc/backend/muscles.dart';

final neckFlexors = Muscle(
    nick: [],
    pseudo: true,
    insertion: Bone.spineCervical,
    heads: {},
    movements: [
      const Movement(
        articulation: Articulation.cervicalSpineFlexion,
        strength: 6,
        rangeStart: 0,
        rangeEnd: 40,
      ),
    ]);
final neckExtensors = Muscle(
  nick: [],
  pseudo: true,
  insertion: Bone.spineCervical,
  heads: {},
  movements: [
    const Movement(
      articulation: Articulation.cervicalSpineExtension,
      strength: 6,
      rangeStart: 0,
      rangeEnd: 35,
    ),
  ],
);
