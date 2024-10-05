import 'package:ptc/backend/articulations.dart';
import 'package:ptc/backend/bones.dart';
import 'package:ptc/backend/movements.dart';
import 'package:ptc/backend/muscles.dart';

final gluteMaximus = Muscle(
  nick: [],
  pseudo: false,
  insertion: Bone.femur,
  movements: [
    // bend knee -> shorter hammies -> weaker hammies -> glute max primary
    // straight knee : both hammie and glute max
    const Movement(
      articulation: Articulation.hipExtension,
      strength: 6,
      rangeStart: 120,
      rangeEnd: -30,
      momentMax: 0,
      // https://pubmed.ncbi.nlm.nih.gov/3988782/
      // leverage best near full extension (anatomical)
      // most force in anatomic position, decreases with flex
    ),
    const Movement(
        // likely mainly upper fibers
        articulation: Articulation.hipExternalRotation,
        strength: 4,
        rangeStart: 0,
        rangeEnd: 45),
    const Movement(
        articulation: Articulation.hipTransverseAbduction,
        strength: 6, // primary when hip is flexed
        rangeStart: 0,
        rangeEnd: 50),
    const Movement(
      articulation: Articulation.hipAbduction,
      strength:
          4, // in this case - not bent at the hip - medius and minimus are primary
      rangeStart: 0,
      rangeEnd: 50,
    ),
    const Movement(
        articulation: Articulation.hipAdduction,
        strength: 4,
        rangeStart: 30,
        rangeEnd: 0), // speculatively, lower fibers only
  ],
  heads: {
    'whole': const Head(
      name: 'whole',
      articular: 1,
      movements: [],
      nick: [],
      origin: [Bone.iliacCrest, Bone.sacrum],
    ),
  },
);
final gluteMedius = Muscle(
// wide hips
  nick: [],
  pseudo: false,
  insertion: Bone.femur,
  // note: rotations are impractical to train, so just focus on hip abduction in extension position
  movements: [
    // only up to 90 degrees of hip flexion.
    // strongest when hip extended, strength weakens as you flex the hip
    // https://pubmed.ncbi.nlm.nih.gov/3952148/
    const Movement(
      articulation: Articulation.hipAbduction,
      strength: 6,
      rangeStart: 0,
      rangeEnd: 90,
    ),
// during parts of hip abduction
    const Movement(articulation: Articulation.hipExternalRotation, strength: 4),
// most anterior fibers only. so hopefully something else does this stronger
    const Movement(articulation: Articulation.hipInternalRotation, strength: 4),
  ],
  heads: {
    'whole': const Head(
      name: 'whole',
      articular: 1,
      movements: [],
      nick: [],
      origin: [Bone.iliacCrest],
    )
  },
);
final gluteMinimus = Muscle(
  // invisible muscle
  nick: [],
  pseudo: false,
  insertion: Bone.femur,
  movements: [
    const Movement(articulation: Articulation.hipAbduction, strength: 6),
    const Movement(
        articulation: Articulation.hipInternalRotation,
        strength: 4), // during abduction only. strange movement pattern
  ],
  heads: {
    'whole': const Head(
      name: 'whole',
      articular: 1,
      movements: [],
      nick: [],
      origin: [Bone.iliacCrest],
    )
  },
);
