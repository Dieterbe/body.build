import 'package:ptc/backend/articulations.dart';
import 'package:ptc/backend/bones.dart';
import 'package:ptc/util.dart';

enum Muscle {
  pectoralisMajor(
      pseudo: false,
      nick: ['chest', 'pecs'],
      insertion: Bone.humerus,
      heads: {
        'clavicular': Head(
          name: 'clavicular',
          nick: ['upper'],
          origin: [Bone.clavicle],
          articular: 1,
        ),
        'sternal': Head(
          name: 'sternal',
          nick: ['lower'],
          origin: [Bone.sternum],
          articular: 1,
        )
      }),
  tricepsBrachii(
    pseudo: false,
    nick: ['tris'],
    insertion: Bone.ulna,
    heads: {
      // inside of arm
      'long': Head(
        name: 'long',
        nick: [],
        origin: [Bone.scapula],
        articular: 2,
      ),
      // outside of arm
      'lateral': Head(
        name: 'lateral',
        nick: [],
        origin: [Bone.humerus], // top of
        articular: 1,
      ),
      // covered
      'medial': Head(
        name: 'medial',
        nick: [],
        origin: [Bone.humerus], // middle of
        articular: 1,
        activeInsuffiency: Insufficiency(
          comment: "arm extended behind body",
          factors: [
            InsufficiencyFactor(Articulation.elbowExtension, 0),
            InsufficiencyFactor(Articulation.shoulderFlexion, 20)
          ],
        ),
        passiveInsufficiency: Insufficiency(
          comment:
              "arm bent overhead, but even during overhead extension you don't reach this",
          factors: [
            InsufficiencyFactor(Articulation.shoulderFlexion, 160),
            InsufficiencyFactor(Articulation.elbowFlexion, 150)
          ],
        ),
      ),
    },
  ),
  latissimusDorsi(
    pseudo: false,
    nick: ['lats'],
    insertion: Bone.humerus,
    heads: {
      'whole': Head(
          name: 'whole',
          nick: [],
          articular: 1,
          origin: [
            Bone.lowerSpine,
            Bone.sacrum,
            Bone.iliacCrest,
            Bone.lowerRibs,
            Bone.scapula
          ])
    },
  ),
  bicepsBrachii(
      nick: ['biceps'],
      pseudo: false,
      insertion: Bone.radius,
      heads: {
        'long': Head(
          name: 'long',
          nick: ['outer'],
          origin: [Bone.scapula],
          articular: 3,
        ),
        'short': Head(
          name: 'short',
          nick: ['inner'],
          origin: [Bone.scapula],
          articular: 3,
          passiveInsufficiency: Insufficiency(
            factors: [
              InsufficiencyFactor(Articulation.elbowExtension, 0),
              InsufficiencyFactor(Articulation.shoulderExtension, 0)
            ],
          ),
          activeInsuffiency: Insufficiency(
            factors: [
              InsufficiencyFactor(Articulation.elbowFlexion, 180),
              InsufficiencyFactor(Articulation.shoulderExtension, 180)
            ],
          ),
        ),
      }),

  brachialis(
      // small and simple. covered by biceps
      nick: [],
      pseudo: false,
      insertion: Bone.ulna,
      heads: {
        'whole': Head(
          name: 'whole',
          nick: [],
          origin: [Bone.humerus],
          articular: 1,
        )
      }),
  brachioradialis(
    nick: [],
    pseudo: false,
    insertion: Bone.radioUlnarJoint,
    heads: {
      'whole': Head(
        name: 'whole',
        nick: [],
        origin: [
          Bone.humerus,
        ],
        articular: 1, // note: kindof by convention. could be sort of 1.5
      )
    },
  ),
  // extracurricular https://www.sciencedirect.com/topics/engineering/brachioradialis
  // some of the details might be incorrect
  forearmPronators(
    pseudo: true,
    nick: [],
    insertion: Bone.radioUlnarJoint,
    heads: {
      'whole': Head(
        name: 'whole',
        nick: [],
        origin: [
          Bone.humerus,
        ],
        articular: 1,
      )
    },
  );

// teres major is ignored. train lats well = train teres major well
// teres major: shoulder extension, adduction, internal rotation
  const Muscle({
    required this.nick,
    required this.pseudo,
    required this.insertion,
    required this.heads,
  });

  final List<String> nick;
  final bool pseudo;
  final Bone insertion;
  final Map<String, Head> heads;

  String nameWithHead(String? head) =>
      name.camelToTitle() + (head != null ? ' ($head head)' : '');
}

class Head {
  const Head({
    required this.name,
    required this.nick,
    required this.origin,
    required this.articular,
    this.activeInsuffiency,
    this.passiveInsufficiency,
  });

  final String name;
  final List<String> nick;
  final List<Bone> origin;
  final int articular;
  final Insufficiency? activeInsuffiency;
  final Insufficiency? passiveInsufficiency;
}

class Insufficiency {
  final List<InsufficiencyFactor> factors;
  final String? comment;

  const Insufficiency({this.comment, required this.factors});
}

class InsufficiencyFactor {
  const InsufficiencyFactor(this.articulation, this.degrees);

  final Articulation articulation;
  final int degrees;

  @override
  String toString() {
    return '${articulation.name.camelToTitle()} @ $degrees';
  }
}
