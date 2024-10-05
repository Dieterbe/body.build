import 'package:ptc/backend/articulations.dart';
import 'package:ptc/backend/bones.dart';
import 'package:ptc/backend/movements.dart';
import 'package:ptc/backend/muscles.dart';
// standard U length-tension relation. optimum at middle

final deltoidAnterior = Muscle(
  nick: ['front delts'],
  pseudo: false,
  insertion: Bone.humerus,
  movements: [
    const Movement(
      articulation: Articulation.shoulderTransverseAdduction,
      strength: 2, // very weak
      rangeStart: 0,
      rangeEnd: 90,
    ),
    const Movement(
      articulation: Articulation.shoulderTransverseFlexion,
      strength: 5,
// best leverage horizontal 0 -45degrees, then its pecs
      rangeStart: 0,
      rangeEnd: 90,
    ),
    const Movement(
      // better leverage than pecs, especially with higher arms
      articulation: Articulation.shoulderFlexion,
      strength: 6,
      rangeStart: 0,
      rangeEnd: 160,
    ),
    const Movement(
      articulation: Articulation.shoulderInternalRotation,
      strength: 4,
      rangeStart: 0,
      rangeEnd: 70,
    ),
    const Movement(
      // (when shoulder is externally rotated)
      articulation: Articulation.shoulderAbduction,
      strength: 4,
    )
  ],
  heads: {
    'whole': const Head(
      name: 'whole',
      nick: [],
      origin: [Bone.clavicle],
      articular: 1,
      movements: [],
    ),
  },
);
// standard U length-tension relation. optimum at middle
// weakest at full contraction
final deltoidLateral = Muscle(
    nick: ['side delts'],
    pseudo: false,
    insertion: Bone.humerus,
    movements: [
      const Movement(
        // higher up is more leverage, upto at least 12 degrees of flexion
        articulation: Articulation.shoulderAbduction,
        strength: 6,
        rangeStart: 0,
        rangeEnd: 170,
      ),
      const Movement(
        // less than front delts
        // mainly when shoulder is internally rotated
        articulation: Articulation.shoulderFlexion,
        strength: 3,
        rangeStart: 0,
        rangeEnd: 160,
      ),
      const Movement(
        articulation: Articulation.shoulderTransverseAbduction,
        strength: 4, // less than rear delts
        rangeStart: -145,
        rangeEnd: 45,
      ),
    ],
    heads: {
      'whole': const Head(
        name: 'whole',
        articular: 1,
        movements: [],
        nick: [],
        origin: [Bone.scapula],
      )
    });
// max length is most strong
// weak when shortened
final deltoidPosterior = Muscle(
    nick: ['rear delts'],
    pseudo: false,
    insertion: Bone.humerus,
    movements: [
      const Movement(
        articulation: Articulation.shoulderTransverseAbduction,
        rangeStart: -145,
        rangeEnd: 45,
        strength: 5, // less leverage than trans. extension
      ),
      const Movement(
        articulation: Articulation.shoulderTransverseExtension,
        strength: 6,
        rangeStart: -145,
        rangeEnd: 45,
      ),
      const Movement(
          // best leverage at side or behind back
          // http://doi.org/10.1111/joa.12903
          // more flexion is less moment arm
          articulation: Articulation.shoulderExtension,
          strength: 4,
          rangeStart: 170,
          rangeEnd: 0),
      const Movement(
        // best leverage at side or behind back
// http://doi.org/10.1111/joa.12903
        // more flexion is less moment arm

        articulation: Articulation.shoulderHyperextension,
        strength: 6, // primary mover. pecs/lats can't extend beyond anatomical
        rangeStart: 0,
        rangeEnd: -40,
      ),
      const Movement(
        articulation: Articulation.shoulderExternalRotation,
        strength: 4,
        rangeStart: 0,
        rangeEnd: 90,
      ),
      const Movement(
        // higher up is more leverage, upto at least 12 degrees of flexion
        articulation: Articulation.shoulderAbduction,
        strength: 2,
        rangeStart: 0,
        rangeEnd: 170,
      ),
    ],
    heads: {
      'whole': const Head(
        name: 'whole',
        articular: 1,
        movements: [],
        nick: [],
        origin: [Bone.scapula],
      )
    });
