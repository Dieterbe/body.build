import 'package:ptc/backend/articulations.dart';
import 'package:ptc/backend/bones.dart';
import 'package:ptc/backend/movements.dart';
import 'package:ptc/backend/muscles.dart';

final quadricepsFemoris = MultiHeadMuscle(
    id: MuscleId.quadricepsFemoris,
    categories: [MuscleCategory.quads],
    nick: ['quads'],
    insertion: Bone.patella,
    movements: [
      const Movement(
        articulation: Articulation.kneeExtension,
        rangeStart: 150,
        rangeEnd: 0,
        momentMax:
            45, // leverage close to optimal up to full extension. bending more than 45 deteriorates leverage
        // most tension in anatomical position, bending produces less force
        strength: 6, // quads are the only knee extensors
      )
    ],
    headsMap: {
      MuscleId.rectusFemoris: const Head(
        id: MuscleId.rectusFemoris,
        origin: [Bone.hip],
        articular: 2,
        name: 'rectus femoris',
        activeInsufficiency: Insufficiency(
          comment:
              'fully contracted at knee and hip (lean back during knee extensions to stimulate rectus femoris)',
          factors: [
            InsufficiencyFactor(Articulation.kneeFlexion, 0),
            InsufficiencyFactor(Articulation.hipFlexion, 140)
          ],
        ),
        movements: [
          Movement(
              articulation: Articulation.hipFlexion,
              strength: 6,
              rangeStart: 0,
              momentMax:
                  0, // pull up knees worsens moment. https://www.ncbi.nlm.nih.gov/pubmed/2079066
              // tesnion-> length best in anatomic position, worsens when lengthen or contracts
              rangeEnd: 140),
        ],
      ),
      MuscleId.vastusLateralis: const Head(
        id: MuscleId.vastusLateralis,
        origin: [Bone.femur],
        name: 'vastus lateralis',
        movements: [],
      ),
      MuscleId.vastusIntermedius: const Head(
        id: MuscleId.vastusIntermedius,
        origin: [Bone.femur],
        name: 'vastus intermedius',
        movements: [],
      ),
      // includes VMO
      MuscleId.vastusMedialis: const Head(
        id: MuscleId.vastusMedialis,
        origin: [Bone.femur],
        name: 'vastus medialis',
        movements: [],
      ),
    });
