import 'package:ptc/backend/articulations.dart';
import 'package:ptc/backend/bones.dart';
import 'package:ptc/backend/movements.dart';
import 'package:ptc/backend/muscles.dart';

final deltoids = MultiHeadMuscle(
  id: MuscleId.deltoids,
  categories: [MuscleCategory.delts],
  insertion: Bone.humerus,
  movements: [],
  headsMap: {
    // standard U length-tension relation. optimum at middle
    MuscleId.deltoidsAnteriorHead: const Head(
      id: MuscleId.deltoidsAnteriorHead,
      name: 'anterior head',
      nick: ['front'],
      origin: [Bone.clavicle],
      movements: [
        Movement(
          articulation: Articulation.shoulderTransverseAdduction,
          strength: 2, // very weak
          rangeStart: 0,
          rangeEnd: 90,
        ),
        Movement(
          articulation: Articulation.shoulderTransverseFlexion,
          strength: 5,
// best leverage horizontal 0 -45degrees, then its pecs
          rangeStart: 0,
          rangeEnd: 90,
        ),
        Movement(
          // better leverage than pecs, especially with higher arms
          articulation: Articulation.shoulderFlexion,
          strength: 6,
          rangeStart: 0,
          rangeEnd: 160,
        ),
        Movement(
          articulation: Articulation.shoulderInternalRotation,
          strength: 4,
          rangeStart: 0,
          rangeEnd: 70,
        ),
        Movement(
          // (when shoulder is externally rotated)
          articulation: Articulation.shoulderAbduction,
          strength: 4,
        )
      ],
    ),
    // standard U length-tension relation. optimum at middle
// weakest at full contraction
    MuscleId.deltoidsLateralHead: const Head(
      id: MuscleId.deltoidsLateralHead,
      name: 'lateral head',
      movements: [
        Movement(
          // higher up is more leverage, upto at least 12 degrees of flexion
          articulation: Articulation.shoulderAbduction,
          strength: 6,
          rangeStart: 0,
          rangeEnd: 170,
        ),
        Movement(
          // less than front delts
          // mainly when shoulder is internally rotated
          articulation: Articulation.shoulderFlexion,
          strength: 3,
          rangeStart: 0,
          rangeEnd: 160,
        ),
        Movement(
          articulation: Articulation.shoulderTransverseAbduction,
          strength: 4, // less than rear delts
          rangeStart: -145,
          rangeEnd: 45,
        ),
      ],
      nick: ['side delts'],
      origin: [Bone.scapula],
    ),
    // max length is most strong
// weak when shortened
    MuscleId.deltoidsPosteriorHead: const Head(
      id: MuscleId.deltoidsPosteriorHead,
      name: 'posterior head',
      nick: ['rear delts'],
      origin: [Bone.scapula],
      movements: [
        Movement(
          articulation: Articulation.shoulderTransverseAbduction,
          rangeStart: -145,
          rangeEnd: 45,
          strength: 5, // less leverage than trans. extension
        ),
        Movement(
          articulation: Articulation.shoulderTransverseExtension,
          strength: 6,
          rangeStart: -145,
          rangeEnd: 45,
        ),
        Movement(
            // best leverage at side or behind back
            // http://doi.org/10.1111/joa.12903
            // more flexion is less moment arm
            articulation: Articulation.shoulderExtension,
            strength: 4,
            rangeStart: 170,
            rangeEnd: 0),
        Movement(
          // best leverage at side or behind back
// http://doi.org/10.1111/joa.12903
          // more flexion is less moment arm

          articulation: Articulation.shoulderHyperextension,
          strength:
              6, // primary mover. pecs/lats can't extend beyond anatomical
          rangeStart: 0,
          rangeEnd: -40,
        ),
        Movement(
          articulation: Articulation.shoulderExternalRotation,
          strength: 4,
          rangeStart: 0,
          rangeEnd: 90,
        ),
        Movement(
          // higher up is more leverage, upto at least 12 degrees of flexion
          articulation: Articulation.shoulderAbduction,
          strength: 2,
          rangeStart: 0,
          rangeEnd: 170,
        ),
      ],
    ),
  },
);
