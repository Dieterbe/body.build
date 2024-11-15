import 'package:ptc/data/anatomy/articulations.dart';
import 'package:ptc/data/anatomy/bones.dart';
import 'package:ptc/model/anatomy/movements.dart';
import 'package:ptc/data/anatomy/muscles.dart';
// biceps https://www.instagram.com/p/CiDdmgFLeTo/
// A study by Sato et al. (2021) found that training the biceps over the bottom 0-50° of elbow flexion – at longer lengths – resulted in triple the growth compared to training the biceps over the top 80-130° of elbow flexion– at shorter lengths

// none of the elbow flexors are really affected by shoulder position
// see https://www.ncbi.nlm.nih.gov/pubmed/8429057
final bicepsBrachii = MultiHeadMuscle(
    id: MuscleId.bicepsBrachii,
    categories: [MuscleCategory.elbowFlexors],
    nick: ['biceps'],
    insertion: Bone.radius,
    movements: [
      const Movement(
        articulation: Articulation.elbowFlexion,
        rangeStart: 0,
        rangeEnd: 150,
        momentMax:
            90, // and when supinated https://www.ncbi.nlm.nih.gov/pubmed/7775488
        // most tension in anatomic position (max length). short head loses 80% when shortening. long head barely active when fully shortened
        strength: 6,
      ),
      const Movement(
        articulation: Articulation.forearmSupination,
// best moment arm when pronated. less leverage with more supination
        strength: 6,
        rangeStart: -75,
        rangeEnd: 85,
        momentMax: -75,
      ),
      const Movement(
        articulation: Articulation.shoulderFlexion,
        rangeStart: 30,
        rangeEnd: 60,
        // very weak. partly indirect and passive by the tendon of the long head.
        // first 30-60 deg only.
        // https://doi.org/10.1016/j.jelekin.2006.09.012
        strength: 2,
      ),
      const Movement(
        // very weak, and only when forearm supinated
        // https://journals.lww.com/jbjsjournal/pages/articleviewer.aspx?year=1957&issue=39050&article=00011&type=Abstract
        articulation: Articulation.shoulderAbduction,
        strength: 2,
        // this is what Dieter figures based on the biceps insertion
        rangeStart: 0,
        rangeEnd: 180,
      ),
    ],
    headsMap: {
      MuscleId.bicepsBrachiiLongHead: const Head(
        id: MuscleId.bicepsBrachiiLongHead,
        name: 'long head',
        nick: ['outer'],
        origin: [Bone.scapula],
        articular: 3,
        movements: [],
      ),
      MuscleId.bicepsBrachiiShortHead: const Head(
        id: MuscleId.bicepsBrachiiShortHead,
        name: 'short head',
        nick: ['inner'],
        origin: [Bone.scapula],
        articular: 3,
        movements: [],
        passiveInsufficiency: Insufficiency(
          factors: [
            InsufficiencyFactor(Articulation.elbowExtension, 0),
            InsufficiencyFactor(Articulation.shoulderExtension, 0)
          ],
        ),
        activeInsufficiency: Insufficiency(
          factors: [
            InsufficiencyFactor(Articulation.elbowFlexion, 180),
            InsufficiencyFactor(Articulation.shoulderExtension, 180)
          ],
        ),
      ),
    });

final brachialis = SingleHeadMuscle(
  id: MuscleId.brachialis,
  categories: [MuscleCategory.elbowFlexors],
  // small and simple. covered by biceps
  insertion: Bone.ulna,
  movements: [
    const Movement(
      articulation: Articulation.elbowFlexion,
      rangeStart: 0,
      rangeEnd: 150,
      momentMax: 90,
      // most tension in anatomic position (max length). looses half strength when shorten
      strength: 5,
    ),
  ],

  origin: [Bone.humerus],
);
final brachioradialis = SingleHeadMuscle(
  id: MuscleId.brachioradialis,
  categories: [MuscleCategory.elbowFlexors],
  insertion: Bone.radioUlnarJoint,
  movements: [
    const Movement(
      articulation: Articulation.elbowFlexion,
      rangeStart: 0,
      rangeEnd: 150,
      momentMax: 90, // and in neutral
      // most tension in anatomic position (max length). barely active when fully shortened
      strength: 5,
    ),
    const Movement(
      articulation: Articulation.forearmSupination,
      rangeStart: -75,
      rangeEnd: 0,
      // best moment arm when pronated. no leverage past neutral
      momentMax: -75,
      strength: 5,
    ),
    const Movement(
      articulation: Articulation.forearmPronation,
      // best moment arm when supinated. no leverage past neutral
      strength: 6,
      rangeStart: -85,
      rangeEnd: 0,
      momentMax: -85,
    ),
  ],
  origin: [Bone.humerus],
  articular: 1, // note: kindof by convention. could be sort of 1.5
);
