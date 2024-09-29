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
        activeInsufficiency: Insufficiency(
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
  // teres major is ignored. train lats well = train teres major well
// teres major: shoulder extension, adduction, internal rotation
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
          activeInsufficiency: Insufficiency(
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
  ),
  trapeziusUpper(
      nick: ['upper traps'],
      pseudo: true,
      insertion: Bone.clavicle,
      heads: {
        'upper fibers': Head(
          name: 'upper fibers',
          nick: [],
          origin: [
            Bone.skull,
          ],
          articular: 2,
          activeInsufficiency: Insufficiency(
            comment:
                "contracted at both neck and shoulder (technically, also a bit lower fibers). keep head forward during shrugs",
            factors: [
              InsufficiencyFactor(Articulation.cervicalSpineExtension, 361),
              InsufficiencyFactor(Articulation.scapularElevation, 361),
            ],
          ),
          passiveInsufficiency: Insufficiency(
            comment:
                "stretched at both neck and shoulder (technically, also a bit lower fibers)",
            factors: [
              InsufficiencyFactor(Articulation.cervicalSpineFlexion, 361),
              InsufficiencyFactor(Articulation.scapularDepression, 361)
            ],
          ),
        ),
        'lower fibers': Head(
          name: 'lower fibers',
          nick: [],
          origin: [Bone.spineCervical],
          articular: 2,
        ),
      }),
  trapeziusMiddle(
      nick: ['middle traps'],
      pseudo: true,
      insertion: Bone.scapula,
      heads: {
        'whole': Head(
          name: 'whole',
          nick: [],
          origin: [Bone.spineC7T1],
          articular: 1,
        ),
      }),
  trapeziusLower(
      nick: ['lower traps'],
      pseudo: true,
      insertion: Bone.scapula,
      heads: {
        'whole': Head(
            name: 'whole', nick: [], origin: [Bone.spineThoracic], articular: 1)
      }),
  deltoidAnterior(
    nick: ['front delts'],
    pseudo: false,
    insertion: Bone.humerus,
    heads: {
      'whole': Head(
        name: 'whole',
        nick: [],
        origin: [Bone.clavicle],
        articular: 1,
      ),
    },
  ),
  deltoidLateral(
      nick: ['side delts'],
      pseudo: false,
      insertion: Bone.humerus,
      heads: {
        'whole': Head(
          name: 'whole',
          articular: 1,
          nick: [],
          origin: [Bone.scapula],
        )
      }),
  deltoidPosterior(
      nick: ['rear delts'],
      pseudo: false,
      insertion: Bone.humerus,
      heads: {
        'whole': Head(
          name: 'whole',
          articular: 1,
          nick: [],
          origin: [Bone.scapula],
        )
      });
  /*

	- Gluteals (‘glutes’/butt)
		- maximus
		- medius
		- minimus (invisible)

      */

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
    this.activeInsufficiency,
    this.passiveInsufficiency,
  });

  final String name;
  final List<String> nick;
  final List<Bone> origin;
  final int articular;
  final Insufficiency? activeInsufficiency;
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
