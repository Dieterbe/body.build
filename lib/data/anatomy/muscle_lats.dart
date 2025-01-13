import 'package:bodybuild/data/anatomy/articulations.dart';
import 'package:bodybuild/data/anatomy/bones.dart';
import 'package:bodybuild/model/anatomy/movements.dart';
import 'package:bodybuild/data/anatomy/muscles.dart';

final latissimusDorsi = SingleHeadMuscle(
    id: MuscleId.latissimusDorsi,
    categories: [MuscleCategory.lats],
    nick: ['lats'],
    insertion: Bone.humerus,
    movements: [
      const Movement(
        // lengthening -> little reduction of force production. so effective over ROM
        articulation: Articulation.shoulderExtension,
        // full muscle, but a bit more emphasis on upper, thoraccic fibers when submax contracting
        rangeStart: 170,
        rangeEnd: 0,
        momentMax:
            45, // beyond 120 or beyond 0 it's zero. at that point it's teres minor, teres major and rear delts
        // main function of lats
        // https://www.ncbi.nlm.nih.gov/pubmed/24462394
        strength: 6,
      ),
      const Movement(
        articulation: Articulation.shoulderAdduction,
        // mainly lower, lumbopelvic fibers
        // see https://www.ncbi.nlm.nih.gov/pubmed/7498076
        rangeStart: 170,
        rangeEnd: 0,
        momentMax:
            75, // elbows just below shoulders. but considerably positive over entire ROM
        // second most important function
        // especially when shoulder is somewhat externally rotated,
        // e.g. during wide grip pull ups
        strength: 5,
      ),
      const Movement(
        articulation: Articulation.shoulderInternalRotation,
        rangeStart: 0,
        rangeEnd: 70,
        strength: 4,
      ),
      // weak
      const Movement(
        articulation: Articulation.shoulderFlexion,
        rangeStart: -60,
        rangeEnd: 0,
        strength: 3,
      ),
      const Movement(
        articulation: Articulation.shoulderTransverseExtension,
        // very weak due to low internal moment arm
        // https://www.ncbi.nlm.nih.gov/pubmed/9356931
        strength: 2,
      ),
      const Movement(
        articulation: Articulation.scapularRetraction,
        rangeStart: 0,
        rangeEnd: 25,
        // very weak. mainly horizontal fibers attached to scapula
        strength: 2,
      ),
      const Movement(
        articulation: Articulation.scapularDepression,
        // probably mainly from the illiac crest fibers
        rangeStart: 0,
        rangeEnd: 10,
        // very weak
        strength: 2,
      ),
      const Movement(
        articulation: Articulation.scapularDownardRotation,
        // very weak
        strength: 2,
        // these numbers are best guess by dieter
        rangeStart: 0,
        rangeEnd: 20,
      ),
      // technically lats also assist with spinal extension, rotation and lateral flex
      // but trivial compared to spinal erectors
      // https://www.ncbi.nlm.nih.gov/pubmed/11415812
    ],
    origin: [
      Bone.lowerSpine,
      Bone.sacrum,
      Bone.iliacCrest,
      Bone.lowerRibs,
      Bone.scapula
    ]);
  // teres major is ignored. train lats well = train teres major well
// teres major: shoulder extension, adduction, internal rotation