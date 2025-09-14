import 'package:bodybuild/data/anatomy/articulations.dart';
import 'package:bodybuild/data/anatomy/bones.dart';
import 'package:bodybuild/model/anatomy/movements.dart';
import 'package:bodybuild/data/anatomy/muscles.dart';

final tricepsBrachii = MultiHeadMuscle(
  id: MuscleId.tricepsBrachii,
  categories: [MuscleCategory.triceps],
  nick: ['tris'],
  insertion: Bone.ulna,
  movements: [
    const Movement(
      articulation: Articulation.elbowExtension,
      rangeStart: 145,
      rangeEnd: 0,
      momentMax: 10, // "nearly straight", see https://www.ncbi.nlm.nih.gov/pubmed/20655050
      // Leverage deteriorates with increasing elbow flexion up to around a 20% loss when the arms are fully bent.
      // The triceps can operate effectively over the full range of elbow extension with relatively little loss of force production capacity when stretched,
      // as it doesn’t change length much, at least when your arms are at your side in the case of the long head
      // no other muscle does elbow extension, and its the main function of the triceps
      strength: 6,
    ),
  ],
  headsMap: {
    // inside of arm. biggest head of tricep and biggest part of arm
    MuscleId.tricepsBrachiiLongHead: const Head(
      id: MuscleId.tricepsBrachiiLongHead,
      name: 'long head',
      origin: [Bone.scapula],
      articular: 2,
      movements: [
        Movement(
          articulation: Articulation.shoulderExtension,
          rangeStart: 170,
          rangeEnd: 0,
          // https://www.ncbi.nlm.nih.gov/pmc/articles/PMC5827912/
          // not really impacted by elbow flexion
          momentMax: 90, // arms are straight forward
          // very weak compared to others such as lats
          strength: 2,
        ),
        Movement(
          articulation: Articulation.shoulderHyperextension,
          rangeStart: 0,
          rangeEnd: -40,
          // not really impacted by elbow flexion
          strength: 4,
        ),
        Movement(
          articulation: Articulation.shoulderAdduction,
          // mainly when shoulder is externally rotated. weak
          strength: 3,
        ),
      ],
    ),
    // outside of arm
    MuscleId.tricepsBrachiiLateralHead: const Head(
      id: MuscleId.tricepsBrachiiLateralHead,
      name: 'lateral head',
      origin: [Bone.humerus], // top of
      movements: [],
    ),
    // covered and small
    MuscleId.tricepsBrachiiMedialHead: const Head(
      id: MuscleId.tricepsBrachiiMedialHead,
      name: 'medial head',
      origin: [Bone.humerus], // middle of
      movements: [],
      activeInsufficiency: Insufficiency(
        comment: "arm extended behind body",
        factors: [
          InsufficiencyFactor(Articulation.elbowExtension, 0),
          InsufficiencyFactor(Articulation.shoulderFlexion, 20)
        ],
      ),
      passiveInsufficiency: Insufficiency(
        comment: "arm bent overhead, but even during overhead extension you don't reach this",
        factors: [
          InsufficiencyFactor(Articulation.shoulderFlexion, 160),
          InsufficiencyFactor(Articulation.elbowFlexion, 150)
        ],
      ),
    ),
  },
);
