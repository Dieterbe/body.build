import 'package:ptc/backend/articulations.dart';
import 'package:ptc/backend/bones.dart';
import 'package:ptc/backend/movements.dart';
import 'package:ptc/backend/muscles.dart';

final pectoralisMajor = MultiHeadMuscle(
    nick: ['chest', 'pecs'],
    insertion: Bone.humerus,
    movements: [
      const Movement(
        articulation: Articulation.shoulderTransverseFlexion,
        rangeStart: 0,
        rangeEnd: 90,
        momentMax:
            // In full extension, when your elbows are behind your body, the anterior deltoids have better leverage than the pecs
            45, // https://www.jshoulderelbow.org/article/S1058-2746(97)70049-1/abstract
        // most primary pec function.
        strength: 6,
      ),
      const Movement(
        articulation: Articulation.shoulderTransverseAdduction,
        rangeStart: 0,
        rangeEnd: 90,
        momentMax:
            null, // not quite sure. probably similar, but less than transverseFlexion
        // secondary primary pec function

        strength: 5,
      ),
      const Movement(
        articulation: Articulation.shoulderInternalRotation,
        rangeStart: 0,
        rangeEnd: 70,
        strength: 4,
      ),
    ],
    heads: {
      'clavicular': const Head(
        name: 'clavicular',
        nick: ['upper'],
        origin: [Bone.clavicle],
        movements: [
          Movement(
            articulation: Articulation.shoulderFlexion,
            rangeStart: 0,
            rangeEnd: 160,
            strength: 4,
          ),
          Movement(
            articulation: Articulation.shoulderAbduction,
            rangeStart: 0,
            rangeEnd: 180,
            momentMax: 0, // TODO where did this come from?
            strength: 4,
// note: pec activity is reduced if there is no shoulder flexion.
// e.g. a behind the neck press.
// see https://www.frontiersin.org/journals/physiology/articles/10.3389/fphys.2022.825880/full
          ),
        ],
      ),
      'sternal': const Head(
        name: 'sternal',
        nick: ['lower'],
        origin: [Bone.sternum],
        movements: [
          Movement(
            articulation: Articulation.shoulderExtension,
            rangeStart: 170,
            rangeEnd: 0,
            strength: 4,
          ),
          Movement(
            // only the lowest pec fibers are very active at higher angles of shoulder abduction
            // see https://www.sciencedirect.com/science/article/abs/pii/1050641194900175?via%3Dihub
            articulation: Articulation.shoulderAdduction,
            rangeStart: 170,
            rangeEnd: 0,
            strength: 4,
          ),
        ],
      )
    });
