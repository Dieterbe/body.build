import 'dart:math';

import 'package:ptc/backend/articulations.dart';
import 'package:ptc/backend/muscles.dart';

class Movement {
  Movement({
    required this.muscle,
    this.head,
    required this.articulation,
    this.rangeStart,
    this.rangeEnd,
    this.momentMax,
  });
  final Muscle muscle;
  final String? head; // if null, means all heads
  final Articulation articulation;
  final int? rangeStart;
  final int? rangeEnd;
  final int? momentMax; // degrees of the movement for max moment
}

final movements = [
  // most primary pec function.
  Movement(
    muscle: Muscle.pectoralisMajor,
    head: null,
    articulation: Articulation.shoulderTransverseFlexion,
    rangeStart: 0,
    rangeEnd: 90,
    momentMax:
        // In full extension, when your elbows are behind your body, the anterior deltoids have better leverage than the pecs
        45, // https://www.jshoulderelbow.org/article/S1058-2746(97)70049-1/abstract
  ),
  // secondary primary pec function
  Movement(
    muscle: Muscle.pectoralisMajor,
    head: null,
    articulation: Articulation.shoulderTransverseAdduction,
    rangeStart: 0,
    rangeEnd: 90,
    momentMax:
        null, // not quite sure. probably similar, but less than transverseFlexion
  ),
  Movement(
    muscle: Muscle.pectoralisMajor,
    articulation: Articulation.shoulderInternalRotation,
    rangeStart: 0,
    rangeEnd: 70,
  ),
  Movement(
    articulation: Articulation.shoulderFlexion,
    muscle: Muscle.pectoralisMajor,
    head: 'clavicular',
    rangeStart: 0,
    rangeEnd: 160,
  ),
  Movement(
    articulation: Articulation.shoulderAbduction,
    muscle: Muscle.pectoralisMajor,
    head: 'clavicular',
    rangeStart: 0,
    rangeEnd: 180,
    momentMax: 0,
// note: pec activity is reduced if there is no shoulder flexion.
// e.g. a behind the neck press.
// see https://www.frontiersin.org/journals/physiology/articles/10.3389/fphys.2022.825880/full
  ),
  Movement(
    muscle: Muscle.pectoralisMajor,
    head: 'sternal',
    articulation: Articulation.shoulderExtension,
    rangeStart: 0,
    rangeEnd: 170,
  ),
  Movement(
    // only the lowest pec fibers are very active at higher angles of shoulder abduction
    // see https://www.sciencedirect.com/science/article/abs/pii/1050641194900175?via%3Dihub
    articulation: Articulation.shoulderAdduction,
    muscle: Muscle.pectoralisMajor,
    head: 'sternal',
    rangeStart: 0,
    rangeEnd: 170,
  ),
  Movement(
      // no other muscle does elbow extension, and its the main function
      // of the triceps
      articulation: Articulation.elbowExtension,
      muscle: Muscle.tricepsBrachii,
      rangeStart: 0,
      rangeEnd: 145,
      momentMax:
          10 // "nearly straight", see https://www.ncbi.nlm.nih.gov/pubmed/20655050
      // Leverage deteriorates with increasing elbow flexion up to around a 20% loss when the arms are fully bent.
      // The triceps can operate effectively over the full range of elbow extension with relatively little loss of force production capacity when stretched, as it doesn’t change length much, at least when your arms are at your side in the case of the long head
      ),
  // very weak compared to others such as lats
  Movement(
    articulation: Articulation.shoulderExtension,
    muscle: Muscle.tricepsBrachii,
    head: 'long',
    rangeStart: 0,
    rangeEnd: 170,
    // https://www.ncbi.nlm.nih.gov/pmc/articles/PMC5827912/
    momentMax: 90, // arms are straight forward
    // not really impacted by elbow flexion
  ),
  Movement(
    articulation: Articulation.shoulderHyperExtension,
    muscle: Muscle.tricepsBrachii,
    head: 'long',
    rangeStart: 0,
    rangeEnd: 40,
    // not really impacted by elbow flexion
  ),
  Movement(
    articulation: Articulation.shoulderAdduction,
    muscle: Muscle.tricepsBrachii,
    head: 'long',
    // mainly when shoulder is externally rotated. weak
  ),
  // main function of lats
  // https://www.ncbi.nlm.nih.gov/pubmed/24462394
  Movement(
    // lengthening -> little reduction of force production. so effective over ROM
    articulation: Articulation.shoulderExtension,
    muscle: Muscle
        .latissimusDorsi, // full muscle, but a bit more emphasis on upper, thoraccic fibers when submax contracting
    rangeStart: 0,
    rangeEnd: 170,
    momentMax:
        45, // beyond 120 or beyond 0 it's zero. at that point it's teres minor, teres major and rear delts
  ),
  // second most important function
  // especially when shoulder is somewhat externally rotated,
  // e.g. during wide grip pull ups
  Movement(
    articulation: Articulation.shoulderAdduction,
    muscle: Muscle.latissimusDorsi, // mainly lower, lumbopelvic fibers
    // see https://www.ncbi.nlm.nih.gov/pubmed/7498076
    rangeStart: 0,
    rangeEnd: 170,
    momentMax:
        75, // elbows just below shoulders. but considerably positive over entire ROM
  ),
  Movement(
    articulation: Articulation.shoulderInternalRotation,
    muscle: Muscle.latissimusDorsi,
    rangeStart: 0,
    rangeEnd: 70,
  ),
  // weak
  Movement(
    articulation: Articulation.shoulderFlexion,
    muscle: Muscle.latissimusDorsi,
    rangeStart: -60,
    rangeEnd: 0,
  ),
  Movement(
    // very weak due to low internal moment arm
    // https://www.ncbi.nlm.nih.gov/pubmed/9356931
    articulation: Articulation.shoulderTransverseExtension,
    muscle: Muscle.latissimusDorsi,
  ),
  Movement(
    // very weak. mainly horizontal fibers attached to scapula
    articulation: Articulation.scapularRetraction,
    muscle: Muscle.latissimusDorsi,
    rangeStart: 0,
    rangeEnd: 25,
  ),
  Movement(
      // very weak
      articulation: Articulation.scapularDepression,
      muscle: Muscle.latissimusDorsi, // probably mainly from the illiac crest
      rangeStart: 0,
      rangeEnd: 10),
  Movement(
    // very weak
    articulation: Articulation.scapularDownardRotation,
    muscle: Muscle.latissimusDorsi,
  ),
  // technically lats also assist with spinal extension, rotation and lateral flex
  // but trivial compared to spinal erectors
  // https://www.ncbi.nlm.nih.gov/pubmed/11415812
  // none of the elbow flexorrs are really affected by shoulder position
  // see https://www.ncbi.nlm.nih.gov/pubmed/8429057
  Movement(
    articulation: Articulation.elbowFlexion,
    muscle: Muscle.bicepsBrachii,
    rangeStart: 0,
    rangeEnd: 150,
    momentMax:
        90, // and when supinated https://www.ncbi.nlm.nih.gov/pubmed/7775488
    // most tension in anatomic position (max length). short head loses 80% when shortening. long head barely active when fully shortened
  ),
  Movement(
    articulation: Articulation.elbowFlexion,
    muscle: Muscle.brachialis,
    rangeStart: 0,
    rangeEnd: 150,
    momentMax: 90,
    // most tension in anatomic position (max length). looses half strength when shorten
  ),
  Movement(
    articulation: Articulation.elbowFlexion,
    muscle: Muscle.brachioradialis,
    rangeStart: 0,
    rangeEnd: 150,
    momentMax: 90, // and in neutral
    // most tension in anatomic position (max length). barely active when fully shortened
  ),
  Movement(
    articulation: Articulation.forearmSupination,
    muscle: Muscle.bicepsBrachii,
// best moment arm when pronated. less leverage with more supination
  ),
  Movement(
    articulation: Articulation.forearmSupination,
    muscle: Muscle.brachioradialis,
    // best moment arm when pronated. no leverage past neutral
  ),
  Movement(
    articulation: Articulation.forearmPronation,
    muscle: Muscle.brachioradialis,
    // best moment arm when supinated. no leverage past neutral
  ),
  Movement(
    // very weak. partly indirect and passive by the tendon of the long head.
    // first 30-60 deg only.
    // https://doi.org/10.1016/j.jelekin.2006.09.012
    articulation: Articulation.shoulderFlexion,
    muscle: Muscle.bicepsBrachii,
    rangeStart: 0,
    rangeEnd: 60,
  ),
  Movement(
    // very weak, and only when forearm supinated
    // https://journals.lww.com/jbjsjournal/pages/articleviewer.aspx?year=1957&issue=39050&article=00011&type=Abstract
    articulation: Articulation.shoulderAbduction,
    muscle: Muscle.bicepsBrachii,
  ),
];

// the result of compiling all movement information for any given articulation
class ArticulationMovements {
  final Articulation articulation;
  late List<Movement> moves;

  late int rangeStart;
  late int rangeEnd;

  ArticulationMovements(this.articulation) {
    moves = movements.where((m) => m.articulation == articulation).toList();
    assert(moves.isNotEmpty);
    final rangeStarts =
        moves.map((m) => m.rangeStart).whereType<int>().toList();
    final rangeEnds = moves.map((m) => m.rangeEnd).whereType<int>().toList();
    assert(rangeStarts.isNotEmpty);
    assert(rangeEnds.isNotEmpty);

    rangeStart = rangeStarts.fold(1000, min);
    rangeEnd = rangeEnds.fold(-1000, max);
    assert(rangeEnd > rangeStart);
  }

  int get range => rangeEnd - rangeStart;
}
