import 'dart:math';

import 'package:ptc/backend/articulations.dart';
import 'package:ptc/backend/muscles.dart';

// types of strength:
// "absolute" due to muscle length
// relative due to moment arm
// comparison to other muscles for a movement (so you know which muscles get trained)
// comparison to other movements for the same muscle (so you know how to train a muscle)
class Movement {
  Movement({
    required this.muscle,
    this.head,
    required this.articulation,
    this.rangeStart,
    this.rangeEnd,
    this.momentMax,
    required this.strength,
  });
  final Muscle muscle;
  final String? head; // if null, means all heads
  final Articulation articulation;
  final int? rangeStart;
  final int? rangeEnd;
  final int? momentMax; // degrees of the movement for max moment
  // strength. this is not an "absolute scale". it's wrt to the max strength you can achieve for
  // the given movement (so the primary knee extensor and the primary wrist extensor would get the same score)
  // 1: trivial, 2: very weak, 3: weak, 4: moderate or unknown (!), 5: strong, 6: strongest
  // best practice: put a comment in words any time you set this parameter, to easy future refactors
  // primary function -> 5/6 (depends on other muscles if they're stronger)
  // secondary function -> 4/5 (depends on other muscles if they're stronger)
  final int strength;
}
// NOTE: degrees of supination and pronation come from:
// https://musculoskeletalkey.com/structure-and-function-of-the-elbow-and-forearm-complex/

final movements = [
  Movement(
    muscle: Muscle.pectoralisMajor,
    head: null,
    articulation: Articulation.shoulderTransverseFlexion,
    rangeStart: 0,
    rangeEnd: 90,
    momentMax:
        // In full extension, when your elbows are behind your body, the anterior deltoids have better leverage than the pecs
        45, // https://www.jshoulderelbow.org/article/S1058-2746(97)70049-1/abstract
    // most primary pec function.
    strength: 6,
  ),
  Movement(
    muscle: Muscle.pectoralisMajor,
    head: null,
    articulation: Articulation.shoulderTransverseAdduction,
    rangeStart: 0,
    rangeEnd: 90,
    momentMax:
        null, // not quite sure. probably similar, but less than transverseFlexion
    // secondary primary pec function

    strength: 5,
  ),
  Movement(
    muscle: Muscle.pectoralisMajor,
    articulation: Articulation.shoulderInternalRotation,
    rangeStart: 0,
    rangeEnd: 70,
    strength: 4,
  ),
  Movement(
    articulation: Articulation.shoulderFlexion,
    muscle: Muscle.pectoralisMajor,
    head: 'clavicular',
    rangeStart: 0,
    rangeEnd: 160,
    strength: 4,
  ),
  Movement(
    articulation: Articulation.shoulderAbduction,
    muscle: Muscle.pectoralisMajor,
    head: 'clavicular',
    rangeStart: 0,
    rangeEnd: 180,
    momentMax: 0, // TODO where did this come from?
    strength: 4,
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
    strength: 4,
  ),
  Movement(
    // only the lowest pec fibers are very active at higher angles of shoulder abduction
    // see https://www.sciencedirect.com/science/article/abs/pii/1050641194900175?via%3Dihub
    articulation: Articulation.shoulderAdduction,
    muscle: Muscle.pectoralisMajor,
    head: 'sternal',
    rangeStart: 0,
    rangeEnd: 170,
    strength: 4,
  ),
  Movement(
    articulation: Articulation.elbowExtension,
    muscle: Muscle.tricepsBrachii,
    rangeStart: 0,
    rangeEnd: 145,
    momentMax:
        10, // "nearly straight", see https://www.ncbi.nlm.nih.gov/pubmed/20655050
    // Leverage deteriorates with increasing elbow flexion up to around a 20% loss when the arms are fully bent.
    // The triceps can operate effectively over the full range of elbow extension with relatively little loss of force production capacity when stretched, as it doesn’t change length much, at least when your arms are at your side in the case of the long head
    // no other muscle does elbow extension, and its the main function of the triceps

    strength: 6,
  ),
  Movement(
    articulation: Articulation.shoulderExtension,
    muscle: Muscle.tricepsBrachii,
    head: 'long',
    rangeStart: 0,
    rangeEnd: 170,
    // https://www.ncbi.nlm.nih.gov/pmc/articles/PMC5827912/
    // not really impacted by elbow flexion

    momentMax: 90, // arms are straight forward
    // very weak compared to others such as lats
    strength: 2,
  ),
  Movement(
    articulation: Articulation.shoulderHyperExtension,
    muscle: Muscle.tricepsBrachii,
    head: 'long',
    rangeStart: 0,
    rangeEnd: 40,
    // not really impacted by elbow flexion
    strength: 4,
  ),
  Movement(
    articulation: Articulation.shoulderAdduction,
    muscle: Muscle.tricepsBrachii,
    head: 'long',
    // mainly when shoulder is externally rotated. weak
    strength: 3,
  ),

  Movement(
    // lengthening -> little reduction of force production. so effective over ROM
    articulation: Articulation.shoulderExtension,
    muscle: Muscle
        .latissimusDorsi, // full muscle, but a bit more emphasis on upper, thoraccic fibers when submax contracting
    rangeStart: 0,
    rangeEnd: 170,
    momentMax:
        45, // beyond 120 or beyond 0 it's zero. at that point it's teres minor, teres major and rear delts
    // main function of lats
    // https://www.ncbi.nlm.nih.gov/pubmed/24462394
    strength: 6,
  ),

  Movement(
    articulation: Articulation.shoulderAdduction,
    muscle: Muscle.latissimusDorsi, // mainly lower, lumbopelvic fibers
    // see https://www.ncbi.nlm.nih.gov/pubmed/7498076
    rangeStart: 0,
    rangeEnd: 170,
    momentMax:
        75, // elbows just below shoulders. but considerably positive over entire ROM
    // second most important function
    // especially when shoulder is somewhat externally rotated,
    // e.g. during wide grip pull ups
    strength: 5,
  ),
  Movement(
    articulation: Articulation.shoulderInternalRotation,
    muscle: Muscle.latissimusDorsi,
    rangeStart: 0,
    rangeEnd: 70,
    strength: 4,
  ),
  // weak
  Movement(
    articulation: Articulation.shoulderFlexion,
    muscle: Muscle.latissimusDorsi,
    rangeStart: -60,
    rangeEnd: 0,
    strength: 3,
  ),
  Movement(
    articulation: Articulation.shoulderTransverseExtension,
    muscle: Muscle.latissimusDorsi,
    // very weak due to low internal moment arm
    // https://www.ncbi.nlm.nih.gov/pubmed/9356931
    strength: 2,
  ),
  Movement(
    articulation: Articulation.scapularRetraction,
    muscle: Muscle.latissimusDorsi,
    rangeStart: 0,
    rangeEnd: 25,
    // very weak. mainly horizontal fibers attached to scapula
    strength: 2,
  ),
  Movement(
    articulation: Articulation.scapularDepression,
    muscle: Muscle.latissimusDorsi, // probably mainly from the illiac crest
    rangeStart: 0,
    rangeEnd: 10,
    // very weak
    strength: 2,
  ),
  Movement(
    articulation: Articulation.scapularDownardRotation,
    muscle: Muscle.latissimusDorsi,
    // very weak
    strength: 2,
    // these numbers are best guess by dieter
    rangeStart: 0,
    rangeEnd: 20,
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
    strength: 6,
  ),
  Movement(
    articulation: Articulation.elbowFlexion,
    muscle: Muscle.brachialis,
    rangeStart: 0,
    rangeEnd: 150,
    momentMax: 90,
    // most tension in anatomic position (max length). looses half strength when shorten
    strength: 5,
  ),
  Movement(
    articulation: Articulation.elbowFlexion,
    muscle: Muscle.brachioradialis,
    rangeStart: 0,
    rangeEnd: 150,
    momentMax: 90, // and in neutral
    // most tension in anatomic position (max length). barely active when fully shortened
    strength: 5,
  ),
  Movement(
    articulation: Articulation.forearmSupination,
    muscle: Muscle.bicepsBrachii,
// best moment arm when pronated. less leverage with more supination
    strength: 6,
    rangeStart: -75,
    rangeEnd: 85,
    momentMax: -75,
  ),
  Movement(
    articulation: Articulation.forearmSupination,
    muscle: Muscle.brachioradialis,
    rangeStart: -75,
    rangeEnd: 0,
    // best moment arm when pronated. no leverage past neutral
    momentMax: -75,
    strength: 5,
  ),
  Movement(
    articulation: Articulation.forearmPronation,
    muscle: Muscle.brachioradialis,
    // best moment arm when supinated. no leverage past neutral
    strength: 6,
    rangeStart: -85,
    rangeEnd: 0,
    momentMax: -85,
  ),
  // extracurricular https://www.sciencedirect.com/topics/engineering/brachioradialis
  Movement(
    articulation: Articulation.forearmPronation,
    muscle: Muscle.forearmPronators,
    rangeStart: -85,
    rangeEnd: 75,
    strength: 5,
  ),

  Movement(
    articulation: Articulation.shoulderFlexion,
    muscle: Muscle.bicepsBrachii,
    rangeStart: 30,
    rangeEnd: 60,
    // very weak. partly indirect and passive by the tendon of the long head.
    // first 30-60 deg only.
    // https://doi.org/10.1016/j.jelekin.2006.09.012
    strength: 2,
  ),
  Movement(
    // very weak, and only when forearm supinated
    // https://journals.lww.com/jbjsjournal/pages/articleviewer.aspx?year=1957&issue=39050&article=00011&type=Abstract
    articulation: Articulation.shoulderAbduction,
    muscle: Muscle.bicepsBrachii,
    strength: 2,
    // this is what Dieter figures based on the biceps insertion
    rangeStart: 0,
    rangeEnd: 180,
  ),
  // TRAPS
  //	- traps are also stabilizers during many movements
  // most strong near full length. least force when fully contracted
// main function, shoulder needs to be somewhat abducted. e.g. wide grip shrugs
  Movement(
    articulation: Articulation.scapularElevation,
    muscle: Muscle.trapeziusUpper,
    strength: 6,
    rangeStart: 0,
    rangeEnd: 40,
  ),
  Movement(
    articulation: Articulation.scapularRetraction,
    muscle: Muscle.trapeziusUpper,
    head: "lower fibers",
    strength: 3,
    rangeStart: 0,
    rangeEnd: 25,
  ),
  Movement(
      articulation: Articulation.cervicalSpineLateralFlexion,
      muscle: Muscle.trapeziusUpper,
      head: "upper fibers",
      strength: 1, // weak for growth
      rangeStart: 0,
      rangeEnd: 35),
  Movement(
      articulation: Articulation.cervicalSpineExtension,
      muscle: Muscle.trapeziusUpper,
      head: "upper fibers",
      strength: 1, // weak for growth
      rangeStart: 0,
      rangeEnd: 65),
  Movement(
      articulation: Articulation.cervicalSpineHyperExtension,
      muscle: Muscle.trapeziusUpper,
      head: "upper fibers",
      strength: 1, // weak for growth
      rangeStart: 0,
      rangeEnd: 40),
  Movement(
      articulation: Articulation.cervicalRotation,
      muscle: Muscle.trapeziusUpper,
      head: "upper fibers",
      strength: 2, // weak
      rangeStart: 0,
      rangeEnd: 30),
  Movement(
      articulation: Articulation.scapularRetraction, // main function
      muscle: Muscle.trapeziusMiddle,
      strength: 4,
      rangeStart: 0,
      rangeEnd: 25),
  Movement(
    articulation: Articulation.scapularElevation,
    muscle: Muscle.trapeziusMiddle,
    strength: 2, // very weak. don't count it
    rangeStart: 0,
    rangeEnd: 60,
  ),
  Movement(
    // don't typically target this with training. occurs during overhead pressing
    articulation: Articulation.scapularUpwardRotation,
    muscle: Muscle.trapeziusMiddle,
    strength: 4,
    rangeStart: 0, rangeEnd: 60,
  ),
  Movement(
      articulation: Articulation.scapularDepression,
      muscle: Muscle.trapeziusLower,
      strength: 4,
      rangeStart: 0,
      rangeEnd: 10),
  Movement(
      articulation: Articulation.scapularRetraction,
      muscle: Muscle.trapeziusLower,
      strength: 4,
      rangeStart: 0,
      rangeEnd: 25),
  Movement(
    articulation: Articulation.scapularUpwardRotation,
    muscle: Muscle.trapeziusLower,
    strength: 4,
    rangeStart: 0,
    rangeEnd: 60,
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
