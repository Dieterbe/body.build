import 'package:ptc/articulations.dart';
import 'package:ptc/muscles.dart';

class Movement {
  const Movement({
    this.muscle,
    this.head,
    required this.articulation,
    this.rangeBegin,
    this.rangeEnd,
    this.momentMax,
  });
  final Muscle? muscle;
  final Head? head; // if null, means all heads
  final Articulation articulation;
  final int? rangeBegin;
  final int? rangeEnd;
  final int? momentMax; // degrees of the movement for max moment
}

final movements = [
  // most primary pec function.
  const Movement(
    muscle: Muscle.pectoralisMajor,
    head: null,
    articulation: Articulation.shoulderTransverseFlexion,
    rangeBegin: 0,
    rangeEnd: 90,
    momentMax:
        // In full extension, when your elbows are behind your body, the anterior deltoids have better leverage than the pecs
        45, // https://www.jshoulderelbow.org/article/S1058-2746(97)70049-1/abstract
  ),
  // secondary primary pec function
  const Movement(
    muscle: Muscle.pectoralisMajor,
    head: null,
    articulation: Articulation.shoulderTransverseAdduction,
    rangeBegin: 0,
    rangeEnd: 90,
    momentMax:
        null, // not quite sure. probably similar, but less than transverseFlexion
  ),
  const Movement(
    muscle: Muscle.pectoralisMajor,
    articulation: Articulation.shoulderInternalRotation,
    rangeBegin: 0,
    rangeEnd: 70,
  ),
  Movement(
    articulation: Articulation.shoulderFlexion,
    head: Muscle.pectoralisMajor.heads['clavicular'],
    rangeBegin: 0,
    rangeEnd: 160,
  ),
  Movement(
    articulation: Articulation.shoulderAbduction,
    head: Muscle.pectoralisMajor.heads['clavicular'],
    rangeBegin: 0,
    rangeEnd: 180,
    momentMax: 0,
// note: pec activity is reduced if there is no shoulder flexion.
// e.g. a behind the neck press.
// see https://www.frontiersin.org/journals/physiology/articles/10.3389/fphys.2022.825880/full
  ),
  Movement(
    head: Muscle.pectoralisMajor.heads['sternal'],
    articulation: Articulation.shoulderExtension,
    rangeBegin: 0,
    rangeEnd: 170,
  ),
  Movement(
    // only the lowest pec fibers are very active at higher angles of shoulder abduction
    // see https://www.sciencedirect.com/science/article/abs/pii/1050641194900175?via%3Dihub
    articulation: Articulation.shoulderAdduction,
    head: Muscle.pectoralisMajor.heads['sternal'],
    rangeBegin: 0,
    rangeEnd: 170,
  ),
  const Movement(
      // no other muscle does elbow extension, and its the main function
      // of the triceps
      articulation: Articulation.elbowExtension,
      muscle: Muscle.tricepsBrachii,
      rangeBegin: 0,
      rangeEnd: 145,
      momentMax:
          10 // "nearly straight", see https://www.ncbi.nlm.nih.gov/pubmed/20655050
      // Leverage deteriorates with increasing elbow flexion up to around a 20% loss when the arms are fully bent.
      // The triceps can operate effectively over the full range of elbow extension with relatively little loss of force production capacity when stretched, as it doesn’t change length much, at least when your arms are at your side in the case of the long head
      ),
  // very weak compared to others such as lats
  Movement(
    articulation: Articulation.shoulderExtension,
    head: Muscle.tricepsBrachii.heads['long'],
    rangeBegin: 0,
    rangeEnd: 170,
    // https://www.ncbi.nlm.nih.gov/pmc/articles/PMC5827912/
    momentMax: 90, // arms are straight forward
    // not really impacted by elbow flexion
  ),
  Movement(
    articulation: Articulation.shoulderHyperExtension,
    head: Muscle.tricepsBrachii.heads['long'],
    rangeBegin: 0,
    rangeEnd: 40,
    // not really impacted by elbow flexion
  ),
  Movement(
    articulation: Articulation.shoulderAdduction,
    head: Muscle.tricepsBrachii.heads['long'],
    // mainly when shoulder is externally rotated. weak
  ),
];
