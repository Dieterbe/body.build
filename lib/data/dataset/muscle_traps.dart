//	traps are also stabilizers during many movements
// most strong near full length. least force when fully contracted
// main function, shoulder needs to be somewhat abducted. e.g. wide grip shrugs
import 'package:bodybuild/data/dataset/articulation.dart';
import 'package:bodybuild/data/dataset/bone.dart';
import 'package:bodybuild/model/dataset/movement.dart';
import 'package:bodybuild/data/dataset/muscle.dart';

const upperTrapeziusSharedMovements = [
  Movement(articulation: Articulation.scapularElevation, strength: 6, rangeStart: 0, rangeEnd: 40),
];
final trapezius = MultiHeadMuscle(
  id: MuscleId.trapezius,
  categories: [MuscleCategory.traps],
  movements: [],
  headsMap: {
    MuscleId.upperTrapsUpperFibers: const Head(
      id: MuscleId.upperTrapsUpperFibers,
      name: 'upper traps, upper fibers',
      insertion: Bone.clavicle,
      origin: [Bone.skull],
      articular: 2,
      movements: [
        ...upperTrapeziusSharedMovements,
        Movement(
          articulation: Articulation.cervicalSpineLateralFlexion,
          strength: 1, // weak for growth
          rangeStart: 0,
          rangeEnd: 35,
        ),
        Movement(
          articulation: Articulation.cervicalSpineExtension,
          strength: 1, // weak for growth
          rangeStart: 65,
          rangeEnd: 0,
        ),
        Movement(
          articulation: Articulation.cervicalSpineHyperextension,
          strength: 1, // weak for growth
          rangeStart: 0,
          rangeEnd: -40,
        ),
        Movement(
          articulation: Articulation.cervicalSpineRotation,
          strength: 2, // weak
          rangeStart: 0,
          rangeEnd: 30,
        ),
      ],
      activeInsufficiency: Insufficiency(
        comment: """contracted at both neck and shoulder (technically, also a bit lower fibers).
keep head forward during shrugs""",
        factors: [
          InsufficiencyFactor(Articulation.cervicalSpineExtension, 361),
          InsufficiencyFactor(Articulation.scapularElevation, 361),
        ],
      ),
      passiveInsufficiency: Insufficiency(
        comment: "stretched at both neck and shoulder (technically, also a bit lower fibers)",
        factors: [
          InsufficiencyFactor(Articulation.cervicalSpineFlexion, 361),
          InsufficiencyFactor(Articulation.scapularDepression, 361),
        ],
      ),
    ),
    MuscleId.upperTrapsLowerFibers: const Head(
      id: MuscleId.upperTrapsLowerFibers,
      name: 'upper traps, lower fibers',
      origin: [Bone.spineCervical],
      insertion: Bone.clavicle,
      articular: 2,
      movements: [
        ...upperTrapeziusSharedMovements,
        Movement(
          articulation: Articulation.scapularRetraction,
          strength: 3,
          rangeStart: 0,
          rangeEnd: 25,
        ),
      ],
    ),
    MuscleId.middleTraps: const Head(
      id: MuscleId.middleTraps,
      name: 'middle traps',
      insertion: Bone.scapula,
      movements: [
        Movement(
          articulation: Articulation.scapularRetraction, // main function
          strength: 4,
          rangeStart: 0,
          rangeEnd: 25,
        ),
        Movement(
          articulation: Articulation.scapularElevation,
          strength: 2, // very weak. don't count it
          rangeStart: 0,
          rangeEnd: 60,
        ),
        Movement(
          // don't typically target this with training. occurs during overhead pressing
          articulation: Articulation.scapularUpwardRotation,
          strength: 4,
          rangeStart: 0,
          rangeEnd: 60,
        ),
      ],
      origin: [Bone.spineC7T1],
    ),
    MuscleId.lowerTraps: const Head(
      id: MuscleId.lowerTraps,
      name: 'lower traps',
      insertion: Bone.scapula,
      movements: [
        Movement(
          articulation: Articulation.scapularDepression,
          strength: 4,
          rangeStart: 0,
          rangeEnd: 10,
        ),
        Movement(
          articulation: Articulation.scapularRetraction,
          strength: 4,
          rangeStart: 0,
          rangeEnd: 25,
        ),
        Movement(
          articulation: Articulation.scapularUpwardRotation,
          strength: 4,
          rangeStart: 0,
          rangeEnd: 60,
        ),
      ],
      origin: [Bone.spineThoracic],
    ),
  },
);
