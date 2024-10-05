//	traps are also stabilizers during many movements
// most strong near full length. least force when fully contracted
// main function, shoulder needs to be somewhat abducted. e.g. wide grip shrugs
import 'package:ptc/backend/articulations.dart';
import 'package:ptc/backend/bones.dart';
import 'package:ptc/backend/movements.dart';
import 'package:ptc/backend/muscles.dart';

final trapeziusUpper = MultiHeadMuscle(
    nick: ['upper traps'],
    pseudo: true,
    insertion: Bone.clavicle,
    movements: [
      const Movement(
        articulation: Articulation.scapularElevation,
        strength: 6,
        rangeStart: 0,
        rangeEnd: 40,
      ),
    ],
    heads: {
      'upper fibers': const Head(
        name: 'upper fibers',
        origin: [
          Bone.skull,
        ],
        articular: 2,
        movements: [
          Movement(
              articulation: Articulation.cervicalSpineLateralFlexion,
              strength: 1, // weak for growth
              rangeStart: 0,
              rangeEnd: 35),
          Movement(
              articulation: Articulation.cervicalSpineExtension,
              strength: 1, // weak for growth
              rangeStart: 65,
              rangeEnd: 0),
          Movement(
              articulation: Articulation.cervicalSpineHyperextension,
              strength: 1, // weak for growth
              rangeStart: 0,
              rangeEnd: -40),
          Movement(
              articulation: Articulation.cervicalSpineRotation,
              strength: 2, // weak
              rangeStart: 0,
              rangeEnd: 30),
        ],
        activeInsufficiency: Insufficiency(
          comment:
              "contracted at both neck and shoulder (technically, also a bit lower fibers). keep head forward during shrugs",
          factors: [
            InsufficiencyFactor(Articulation.cervicalSpineExtension, 361),
            InsufficiencyFactor(Articulation.scapularElevation, 361),
          ],
        ),
        passiveInsufficiency: Insufficiency(
          comment:
              "stretched at both neck and shoulder (technically, also a bit lower fibers)",
          factors: [
            InsufficiencyFactor(Articulation.cervicalSpineFlexion, 361),
            InsufficiencyFactor(Articulation.scapularDepression, 361)
          ],
        ),
      ),
      'lower fibers': const Head(
        name: 'lower fibers',
        origin: [Bone.spineCervical],
        articular: 2,
        movements: [
          Movement(
            articulation: Articulation.scapularRetraction,
            strength: 3,
            rangeStart: 0,
            rangeEnd: 25,
          ),
        ],
      ),
    });
final trapeziusMiddle = SingleHeadMuscle(
  nick: ['middle traps'],
  pseudo: true,
  insertion: Bone.scapula,
  movements: [
    const Movement(
        articulation: Articulation.scapularRetraction, // main function
        strength: 4,
        rangeStart: 0,
        rangeEnd: 25),
    const Movement(
      articulation: Articulation.scapularElevation,
      strength: 2, // very weak. don't count it
      rangeStart: 0,
      rangeEnd: 60,
    ),
    const Movement(
      // don't typically target this with training. occurs during overhead pressing
      articulation: Articulation.scapularUpwardRotation,
      strength: 4,
      rangeStart: 0, rangeEnd: 60,
    ),
  ],
  origin: [Bone.spineC7T1],
);
final trapeziusLower = SingleHeadMuscle(
  nick: ['lower traps'],
  pseudo: true,
  insertion: Bone.scapula,
  movements: [
    const Movement(
        articulation: Articulation.scapularDepression,
        strength: 4,
        rangeStart: 0,
        rangeEnd: 10),
    const Movement(
        articulation: Articulation.scapularRetraction,
        strength: 4,
        rangeStart: 0,
        rangeEnd: 25),
    const Movement(
      articulation: Articulation.scapularUpwardRotation,
      strength: 4,
      rangeStart: 0,
      rangeEnd: 60,
    ),
  ],
  origin: [Bone.spineThoracic],
);
