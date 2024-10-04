import 'package:ptc/backend/articulations.dart';
import 'package:ptc/backend/bones.dart';
import 'package:ptc/backend/movements.dart';
import 'package:ptc/util.dart';

enum Muscle {
  pectoralisMajor(
      pseudo: false,
      nick: ['chest', 'pecs'],
      insertion: Bone.humerus,
      movements: [
        Movement(
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
          articulation: Articulation.shoulderTransverseAdduction,
          rangeStart: 0,
          rangeEnd: 90,
          momentMax:
              null, // not quite sure. probably similar, but less than transverseFlexion
          // secondary primary pec function

          strength: 5,
        ),
        Movement(
          articulation: Articulation.shoulderInternalRotation,
          rangeStart: 0,
          rangeEnd: 70,
          strength: 4,
        ),
      ],
      heads: {
        'clavicular': Head(
          name: 'clavicular',
          nick: ['upper'],
          origin: [Bone.clavicle],
          articular: 1,
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
        'sternal': Head(
          name: 'sternal',
          nick: ['lower'],
          origin: [Bone.sternum],
          articular: 1,
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
      }),
  tricepsBrachii(
    pseudo: false,
    nick: ['tris'],
    insertion: Bone.ulna,
    movements: [
      Movement(
        articulation: Articulation.elbowExtension,
        rangeStart: 145,
        rangeEnd: 0,
        momentMax:
            10, // "nearly straight", see https://www.ncbi.nlm.nih.gov/pubmed/20655050
        // Leverage deteriorates with increasing elbow flexion up to around a 20% loss when the arms are fully bent.
        // The triceps can operate effectively over the full range of elbow extension with relatively little loss of force production capacity when stretched,
        // as it doesn’t change length much, at least when your arms are at your side in the case of the long head
        // no other muscle does elbow extension, and its the main function of the triceps
        strength: 6,
      ),
    ],
    heads: {
      // inside of arm
      'long': Head(
        name: 'long',
        nick: [],
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
      'lateral': Head(
        name: 'lateral',
        nick: [],
        origin: [Bone.humerus], // top of
        articular: 1, movements: [],
      ),
      // covered
      'medial': Head(
        name: 'medial',
        nick: [],
        origin: [Bone.humerus], // middle of
        articular: 1, movements: [],
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
    movements: [
      Movement(
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
      Movement(
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
      Movement(
        articulation: Articulation.shoulderInternalRotation,
        rangeStart: 0,
        rangeEnd: 70,
        strength: 4,
      ),
      // weak
      Movement(
        articulation: Articulation.shoulderFlexion,
        rangeStart: -60,
        rangeEnd: 0,
        strength: 3,
      ),
      Movement(
        articulation: Articulation.shoulderTransverseExtension,
        // very weak due to low internal moment arm
        // https://www.ncbi.nlm.nih.gov/pubmed/9356931
        strength: 2,
      ),
      Movement(
        articulation: Articulation.scapularRetraction,
        rangeStart: 0,
        rangeEnd: 25,
        // very weak. mainly horizontal fibers attached to scapula
        strength: 2,
      ),
      Movement(
        articulation: Articulation.scapularDepression,
        // probably mainly from the illiac crest fibers
        rangeStart: 0,
        rangeEnd: 10,
        // very weak
        strength: 2,
      ),
      Movement(
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
    heads: {
      'whole': Head(
          name: 'whole',
          nick: [],
          articular: 1,
          movements: [],
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

  // none of the elbow flexors are really affected by shoulder position
  // see https://www.ncbi.nlm.nih.gov/pubmed/8429057
  bicepsBrachii(
      nick: ['biceps'],
      pseudo: false,
      insertion: Bone.radius,
      movements: [
        Movement(
          articulation: Articulation.elbowFlexion,
          rangeStart: 0,
          rangeEnd: 150,
          momentMax:
              90, // and when supinated https://www.ncbi.nlm.nih.gov/pubmed/7775488
          // most tension in anatomic position (max length). short head loses 80% when shortening. long head barely active when fully shortened
          strength: 6,
        ),
        Movement(
          articulation: Articulation.forearmSupination,
// best moment arm when pronated. less leverage with more supination
          strength: 6,
          rangeStart: -75,
          rangeEnd: 85,
          momentMax: -75,
        ),
        Movement(
          articulation: Articulation.shoulderFlexion,
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
          strength: 2,
          // this is what Dieter figures based on the biceps insertion
          rangeStart: 0,
          rangeEnd: 180,
        ),
      ],
      heads: {
        'long': Head(
          name: 'long',
          nick: ['outer'],
          origin: [Bone.scapula],
          articular: 3,
          movements: [],
        ),
        'short': Head(
          name: 'short',
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
      }),

  brachialis(
      // small and simple. covered by biceps
      nick: [],
      pseudo: false,
      insertion: Bone.ulna,
      movements: [
        Movement(
          articulation: Articulation.elbowFlexion,
          rangeStart: 0,
          rangeEnd: 150,
          momentMax: 90,
          // most tension in anatomic position (max length). looses half strength when shorten
          strength: 5,
        ),
      ],
      heads: {
        'whole': Head(
          name: 'whole',
          nick: [],
          origin: [Bone.humerus],
          articular: 1,
          movements: [],
        )
      }),
  brachioradialis(
    nick: [],
    pseudo: false,
    insertion: Bone.radioUlnarJoint,
    movements: [
      Movement(
        articulation: Articulation.elbowFlexion,
        rangeStart: 0,
        rangeEnd: 150,
        momentMax: 90, // and in neutral
        // most tension in anatomic position (max length). barely active when fully shortened
        strength: 5,
      ),
      Movement(
        articulation: Articulation.forearmSupination,
        rangeStart: -75,
        rangeEnd: 0,
        // best moment arm when pronated. no leverage past neutral
        momentMax: -75,
        strength: 5,
      ),
      Movement(
        articulation: Articulation.forearmPronation,
        // best moment arm when supinated. no leverage past neutral
        strength: 6,
        rangeStart: -85,
        rangeEnd: 0,
        momentMax: -85,
      ),
    ],
    heads: {
      'whole': Head(
        name: 'whole',
        nick: [],
        origin: [
          Bone.humerus,
        ],
        articular: 1, // note: kindof by convention. could be sort of 1.5
        movements: [],
      )
    },
  ),
  // extracurricular https://www.sciencedirect.com/topics/engineering/brachioradialis
  // some of the details might be incorrect
  forearmPronators(
    pseudo: true,
    nick: [],
    insertion: Bone.radioUlnarJoint,
    movements: [
      Movement(
        articulation: Articulation.forearmPronation,
        rangeStart: -85,
        rangeEnd: 75,
        strength: 5,
      ),
    ],
    heads: {
      'whole': Head(
        name: 'whole',
        nick: [],
        origin: [
          Bone.humerus,
        ],
        articular: 1,
        movements: [],
      )
    },
  ),
  // TRAPS
  //	- traps are also stabilizers during many movements
  // most strong near full length. least force when fully contracted
  // main function, shoulder needs to be somewhat abducted. e.g. wide grip shrugs
  trapeziusUpper(
      nick: ['upper traps'],
      pseudo: true,
      insertion: Bone.clavicle,
      movements: [
        Movement(
          articulation: Articulation.scapularElevation,
          strength: 6,
          rangeStart: 0,
          rangeEnd: 40,
        ),
      ],
      heads: {
        'upper fibers': Head(
          name: 'upper fibers',
          nick: [],
          origin: [
            Bone.skull,
          ],
          articular: 2,
          movements: [
            Movement(
                articulation: Articulation.cervicalSpineLateralFlexion,
                strength: 1, // weak for growth
                rangeStart: 0,
                rangeEnd: 35),
            Movement(
                articulation: Articulation.cervicalSpineExtension,
                strength: 1, // weak for growth
                rangeStart: 65,
                rangeEnd: 0),
            Movement(
                articulation: Articulation.cervicalSpineHyperextension,
                strength: 1, // weak for growth
                rangeStart: 0,
                rangeEnd: -40),
            Movement(
                articulation: Articulation.cervicalSpineRotation,
                strength: 2, // weak
                rangeStart: 0,
                rangeEnd: 30),
          ],
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
          movements: [
            Movement(
              articulation: Articulation.scapularRetraction,
              strength: 3,
              rangeStart: 0,
              rangeEnd: 25,
            ),
          ],
        ),
      }),
  trapeziusMiddle(
      nick: ['middle traps'],
      pseudo: true,
      insertion: Bone.scapula,
      movements: [
        Movement(
            articulation: Articulation.scapularRetraction, // main function
            strength: 4,
            rangeStart: 0,
            rangeEnd: 25),
        Movement(
          articulation: Articulation.scapularElevation,
          strength: 2, // very weak. don't count it
          rangeStart: 0,
          rangeEnd: 60,
        ),
        Movement(
          // don't typically target this with training. occurs during overhead pressing
          articulation: Articulation.scapularUpwardRotation,
          strength: 4,
          rangeStart: 0, rangeEnd: 60,
        ),
      ],
      heads: {
        'whole': Head(
          name: 'whole',
          nick: [],
          origin: [Bone.spineC7T1],
          articular: 1,
          movements: [],
        ),
      }),
  trapeziusLower(
      nick: ['lower traps'],
      pseudo: true,
      insertion: Bone.scapula,
      movements: [
        Movement(
            articulation: Articulation.scapularDepression,
            strength: 4,
            rangeStart: 0,
            rangeEnd: 10),
        Movement(
            articulation: Articulation.scapularRetraction,
            strength: 4,
            rangeStart: 0,
            rangeEnd: 25),
        Movement(
          articulation: Articulation.scapularUpwardRotation,
          strength: 4,
          rangeStart: 0,
          rangeEnd: 60,
        ),
      ],
      heads: {
        'whole': Head(
          name: 'whole',
          nick: [],
          origin: [Bone.spineThoracic],
          articular: 1,
          movements: [],
        )
      }),
  // standard U length-tension relation. optimum at middle
  deltoidAnterior(
    nick: ['front delts'],
    pseudo: false,
    insertion: Bone.humerus,
    movements: [
      Movement(
        articulation: Articulation.shoulderTransverseAdduction,
        strength: 2, // very weak
        rangeStart: 0,
        rangeEnd: 90,
      ),
      Movement(
        articulation: Articulation.shoulderTransverseFlexion,
        strength: 5,
// best leverage horizontal 0 -45degrees, then its pecs
        rangeStart: 0,
        rangeEnd: 90,
      ),
      Movement(
        // better leverage than pecs, especially with higher arms
        articulation: Articulation.shoulderFlexion,
        strength: 6,
        rangeStart: 0,
        rangeEnd: 160,
      ),
      Movement(
        articulation: Articulation.shoulderInternalRotation,
        strength: 4,
        rangeStart: 0,
        rangeEnd: 70,
      ),
      Movement(
        // (when shoulder is externally rotated)
        articulation: Articulation.shoulderAbduction,
        strength: 4,
      )
    ],
    heads: {
      'whole': Head(
        name: 'whole',
        nick: [],
        origin: [Bone.clavicle],
        articular: 1,
        movements: [],
      ),
    },
  ),
  // standard U length-tension relation. optimum at middle
// weakest at full contraction
  deltoidLateral(
      nick: ['side delts'],
      pseudo: false,
      insertion: Bone.humerus,
      movements: [
        Movement(
          // higher up is more leverage, upto at least 12 degrees of flexion
          articulation: Articulation.shoulderAbduction,
          strength: 6,
          rangeStart: 0,
          rangeEnd: 170,
        ),
        Movement(
          // less than front delts
          // mainly when shoulder is internally rotated
          articulation: Articulation.shoulderFlexion,
          strength: 3,
          rangeStart: 0,
          rangeEnd: 160,
        ),
        Movement(
          articulation: Articulation.shoulderTransverseAbduction,
          strength: 4, // less than rear delts
          rangeStart: -145,
          rangeEnd: 45,
        ),
      ],
      heads: {
        'whole': Head(
          name: 'whole',
          articular: 1,
          movements: [],
          nick: [],
          origin: [Bone.scapula],
        )
      }),
  // max length is most strong
  // weak when shortened
  deltoidPosterior(
      nick: ['rear delts'],
      pseudo: false,
      insertion: Bone.humerus,
      movements: [
        Movement(
          articulation: Articulation.shoulderTransverseAbduction,
          rangeStart: -145,
          rangeEnd: 45,
          strength: 5, // less leverage than trans. extension
        ),
        Movement(
          articulation: Articulation.shoulderTransverseExtension,
          strength: 6,
          rangeStart: -145,
          rangeEnd: 45,
        ),
        Movement(
            // best leverage at side or behind back
            // http://doi.org/10.1111/joa.12903
            // more flexion is less moment arm
            articulation: Articulation.shoulderExtension,
            strength: 4,
            rangeStart: 170,
            rangeEnd: 0),
        Movement(
          // best leverage at side or behind back
// http://doi.org/10.1111/joa.12903
          // more flexion is less moment arm

          articulation: Articulation.shoulderHyperextension,
          strength:
              6, // primary mover. pecs/lats can't extend beyond anatomical
          rangeStart: 0,
          rangeEnd: -40,
        ),
        Movement(
          articulation: Articulation.shoulderExternalRotation,
          strength: 4,
          rangeStart: 0,
          rangeEnd: 90,
        ),
        Movement(
          // higher up is more leverage, upto at least 12 degrees of flexion
          articulation: Articulation.shoulderAbduction,
          strength: 2,
          rangeStart: 0,
          rangeEnd: 170,
        ),
      ],
      heads: {
        'whole': Head(
          name: 'whole',
          articular: 1,
          movements: [],
          nick: [],
          origin: [Bone.scapula],
        )
      }),
  gluteMaximus(
    nick: [],
    pseudo: false,
    insertion: Bone.femur,
    movements: [
      // bend knee -> shorter hammies -> weaker hammies -> glute max primary
      // straight knee : both hammie and glute max
      Movement(
        articulation: Articulation.hipExtension,
        strength: 6,
        rangeStart: 120,
        rangeEnd: -30,
        momentMax: 0,
        // https://pubmed.ncbi.nlm.nih.gov/3988782/
        // leverage best near full extension (anatomical)
        // most force in anatomic position, decreases with flex
      ),
      Movement(
          // likely mainly upper fibers
          articulation: Articulation.hipExternalRotation,
          strength: 4,
          rangeStart: 0,
          rangeEnd: 45),
      Movement(
          articulation: Articulation.hipTransverseAbduction,
          strength: 6, // primary when hip is flexed
          rangeStart: 0,
          rangeEnd: 50),
      Movement(
        articulation: Articulation.hipAbduction,
        strength:
            4, // in this case - not bent at the hip - medius and minimus are primary
        rangeStart: 0,
        rangeEnd: 50,
      ),
      Movement(
          articulation: Articulation.hipAdduction,
          strength: 4,
          rangeStart: 30,
          rangeEnd: 0), // speculatively, lower fibers only
    ],
    heads: {
      'whole': Head(
        name: 'whole',
        articular: 1,
        movements: [],
        nick: [],
        origin: [Bone.iliacCrest, Bone.sacrum],
      ),
    },
  ),
  gluteMedius(
// wide hips
    nick: [],
    pseudo: false,
    insertion: Bone.femur,
    // note: rotations are impractical to train, so just focus on hip abduction in extension position
    movements: [
      // only up to 90 degrees of hip flexion.
      // strongest when hip extended, strength weakens as you flex the hip
      // https://pubmed.ncbi.nlm.nih.gov/3952148/
      Movement(
        articulation: Articulation.hipAbduction,
        strength: 6,
        rangeStart: 0,
        rangeEnd: 90,
      ),
// during parts of hip abduction
      Movement(articulation: Articulation.hipExternalRotation, strength: 4),
// most anterior fibers only. so hopefully something else does this stronger
      Movement(articulation: Articulation.hipInternalRotation, strength: 4),
    ],
    heads: {
      'whole': Head(
        name: 'whole',
        articular: 1,
        movements: [],
        nick: [],
        origin: [Bone.iliacCrest],
      )
    },
  ),
  gluteMinimus(
    // invisible muscle
    nick: [],
    pseudo: false,
    insertion: Bone.femur,
    movements: [
      Movement(articulation: Articulation.hipAbduction, strength: 6),
      Movement(
          articulation: Articulation.hipInternalRotation,
          strength: 4), // during abduction only. strange movement pattern
    ],
    heads: {
      'whole': Head(
        name: 'whole',
        articular: 1,
        movements: [],
        nick: [],
        origin: [Bone.iliacCrest],
      )
    },
  ),
  quadricepsFemoris(
      nick: ['quads'],
      pseudo: false,
      insertion: Bone.patella,
      movements: [
        Movement(
          articulation: Articulation.kneeExtension,
          rangeStart: 150,
          rangeEnd: 0,
          momentMax:
              45, // leverage close to optimal up to full extension. bending more than 45 deteriorates leverage
          // most tension in anatomical position, bending produces less force
          strength: 6, // quads are the only knee extensors
        )
      ],
      heads: {
        'rectus femoris': Head(
          origin: [Bone.hip],
          articular: 2,
          name: 'rectus femoris',
          nick: [],
          activeInsufficiency: Insufficiency(
            comment:
                'fully contracted at knee and hip (lean back during knee extensions to simulate rectus femoris)',
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
        'vastus lateralis': Head(
          articular: 1,
          origin: [Bone.femur],
          name: 'vastus lateralis',
          nick: [],
          movements: [],
        ),
        'vastus intermedius': Head(
          articular: 1,
          origin: [Bone.femur],
          name: 'vastus intermedius',
          nick: [],
          movements: [],
        ),
        // includes VMO
        'vastus medialis': Head(
          articular: 1,
          origin: [Bone.femur],
          name: 'vastus medialis',
          nick: [],
          movements: [],
        ),
      }),
  hamstrings(
    nick: ['hams', 'hammies'],
    pseudo: false,
    insertion: Bone.tibiaFibula,
    movements: [
      Movement(
        articulation: Articulation.kneeFlexion,
        rangeStart: 0,
        rangeEnd: 150,
        strength: 6,
        // leverage is constant until 90, then bending further greatly reduces leverage
        // http://doi.org/10.1016/S0268-0033(98)00055-2

        // all heads produce most tension in anatomic position
        // gradual loss of force at greater / smaller length (so U curve)
        // all heads losee all their force when fully stretched/extended
        // except for semitendinosus.
        // the hammies, specifically the semimembranosus and long head of bicepis femoris
        // have possitve insufficiency when stretched to near max @ both joints
        // (straight legs and flexed hips)
        // full contraction -> active insufficiency
        // leg curls -> avoid full hip extension
        // hip extension -> avoid knees bent
        //
      )
    ],
    heads: {
      'biceps femoris, short head': Head(
        name: 'biceps femoris, short head',
        articular: 1,
        origin: [Bone.femur],
        nick: [],
        movements: [
          Movement(
            articulation: Articulation.kneeExternalRotation,
            strength: 6,
            rangeStart: 0,
            rangeEnd: 30,
          ),
        ],
      ),
      'biceps femoris, long head': Head(
        name: 'biceps femoris, long head',
        articular: 2,
        nick: [],
        origin: [Bone.hip],
        movements: [
          Movement(
            articulation: Articulation.hipExtension,
            strength: 6,
            rangeStart: 120,
            rangeEnd: -20, // when going into hyperextension becomes weak
            momentMax: 45, // decreases substantially in higher/lower flexion
          ),
          Movement(
            articulation: Articulation.kneeExternalRotation,
            strength: 6,
            rangeStart: 0,
            rangeEnd: 30,
          ),
        ],
      ),
      'semitendinosus': Head(
        name: 'semitendinosus',
        nick: [],
        articular: 1,
        origin: [Bone.hip],
        movements: [
          Movement(
            articulation: Articulation.hipExtension,
            strength: 6,
            rangeStart: 120,
            rangeEnd: -20, // when going into hyperextension becomes weak
            momentMax: 45, // decreases substantially in higher/lower flexion
          ),
          Movement(
            articulation: Articulation.kneeInternalRotation,
            strength: 6,
            rangeStart: 0,
            rangeEnd: 10,
          ),
        ],
      ),
      'semimembranosus': Head(
        name: 'semimembranosus',
        nick: [],
        articular: 1,
        origin: [Bone.hip],
        movements: [
          Movement(
            articulation: Articulation.hipExtension,
            strength: 6,
            rangeStart: 120,
            rangeEnd: -20, // when going into hyperextension becomes weak
            momentMax: 45, // decreases substantially in higher/lower flexion
          ),
          Movement(
            articulation: Articulation.kneeInternalRotation,
            strength: 6,
            rangeStart: 0,
            rangeEnd: 10,
          ),
        ],
      )
    },
  ),
  // tricepsSurae and calves comprise of 2 separate muscles
  gastrocnemius(
    nick: [],
    pseudo: false,
    movements: [
      Movement(
        articulation: Articulation.anklePlantarFlexion,
        strength: 6,
        rangeStart: 0,
        rangeEnd: 50,
      ),
      Movement(
          // active insufficiency when flexed to a certain level at both joints
          // leg curl with plantar flexed -> take out gastroc contribution
          // with foot dorsiflexed -> gastroc contributes
          // calf raises with knee flexed shortens gastroc,
          // they can produce less tension or even enter active insufficiency
          // good way to takee out gastroc contribution.
          // https://www.ncbi.nlm.nih.gov/pubmed/22190157/
          // also: some studies show pointing feet out is more growth of medial, and feet in more lateral
          // yes:// Nunes et. al. 2020 - https://www.researchgate.net/publication/340730817_Different_foot_positioning_during_calf_training_to_induce_portion-specific_gastrocnemius_muscle_hypertrophy/stats
          // EMG https://content.iospress.com/articles/isokinetics-and-exercise-science/ies654
          // but not this study: https://doi.org/10.17784/mtprehabjournal.2017.15.529
          articulation: Articulation.kneeFlexion,
          strength: 4,
          rangeStart: 0,
          rangeEnd: 150),
    ],
    insertion: Bone.heel,
    heads: {
      'medial': Head(
        nick: [],
        movements: [],
        articular: 2,
        name: 'medial',
        origin: [Bone.femur],
      ),
      'lateral': Head(
        nick: [],
        movements: [],
        name: 'lateral',
        articular: 2,
        origin: [Bone.femur],
      ),
    },
  ),
  soleus(
    nick: [],
    pseudo: false,
    insertion: Bone.heel,
    movements: [
      Movement(
        articulation: Articulation.anklePlantarFlexion,
        strength: 6,
        rangeStart: 0,
        rangeEnd: 50,
      ),
    ],
    heads: {
      'whole': Head(
        nick: [],
        movements: [],
        name: 'whole',
        articular: 1,
        origin: [Bone.tibiaFibula],
      )
    },
  ),
  // spinal erectors aka erector spinae
  // group of muscles that stabilize the vertebral column
  erectorSpinae(
    nick: [],
    pseudo: false,
    insertion: Bone.spine,
    movements: [
      Movement(
        articulation: Articulation.spinalExtension,
        rangeStart: 85,
        rangeEnd: 0,
        strength: 6,
      ),
      Movement(
        articulation: Articulation.spinalHyperextension,
        rangeStart: 0,
        rangeEnd: -25,
        strength: 6,
      ),
    ],
    heads: {
      // the biggest one
      'longissimus': Head(
        nick: [],
        movements: [
          Movement(
            articulation: Articulation.cervicalSpineLateralFlexion,
            strength: 4,
            rangeStart: 0,
            rangeEnd: 45,
          ),
          Movement(
            articulation: Articulation.cervicalSpineRotation,
            strength: 2,
            rangeStart: 0,
            rangeEnd: 80,
          )
        ],
        name: 'longissimus',
        articular: 1,
        origin: [Bone.spine],
      ),
      // most lateral (outside)

      'iliocostalis': Head(
        nick: [],
        movements: [
          Movement(
            articulation: Articulation.spinalLateralFlexion,
            strength: 4,
            rangeStart: 0,
            rangeEnd: 45,
          ),
          Movement(
            articulation: Articulation.spinalRotationLumbarThoracic,
            strength: 2,
            rangeStart: 0,
            rangeEnd: 80,
          )
        ],
        name: 'iliocostalis',
        articular: 1,
        origin: [Bone.iliacCrest],
      ),
      // closest to spine (medial)

      'spinalis': Head(
        nick: [],
        movements: [
          Movement(
            articulation: Articulation.cervicalSpineLateralFlexion,
            strength: 4,
            rangeStart: 0,
            rangeEnd: 45,
          ),
          Movement(
            articulation: Articulation.cervicalSpineRotation,
            strength: 2,
            rangeStart: 0,
            rangeEnd: 80,
          )
        ],
        name: 'spinalis',
        articular: 1,
        origin: [Bone.spine],
      )
    },
  ),
  abdominals(
      nick: ['abs'],
      pseudo: false,
      insertion: Bone.pelvis, // TODO this is wrong. see insertions below
      movements: [],
      heads: {
        'rectus abdominis': Head(
          nick: ['sixpack'],
          movements: [
            Movement(
              articulation: Articulation.spinalFlexion,
              strength: 4,
              rangeStart: 0,
              rangeEnd: 85,
            ),
            Movement(
              articulation: Articulation.intraAbdominalPressure,
              strength: 4,
            ),
          ],
          name: 'rectus abdominis',
          articular: 1,
          // inserts into sternum
          origin: [Bone.pelvis, Bone.pubicCrest],
        ),
        // lateral
        'external obliques': Head(
          nick: [],
          movements: [
            Movement(
              articulation: Articulation.spinalFlexion,
              strength: 4,
              rangeStart: 0,
              rangeEnd: 85,
            ),
            Movement(
              articulation: Articulation.spinalLateralFlexion,
              strength: 4,
              rangeStart: 0,
              rangeEnd: 40,
            ),
            Movement(
              articulation: Articulation.spinalRotation,
              strength: 2,
              rangeStart: 0,
              rangeEnd: 40,
            ),
            Movement(
              articulation: Articulation.intraAbdominalPressure,
              strength: 6,
            ),
          ],
          name: 'external obliques',
          articular: 1,
          // insert into iliciac Crest, pubic crest
          origin: [Bone.lowerRibs],
        ),
        // inner & invisible
        'internal obliques': Head(
          nick: [],
          movements: [],
          name: 'internal obliques',
          articular: 1,
          origin: [Bone.spine],
        ),
        // inner & invisible
        'transverse abdominis': Head(
          nick: [],
          movements: [],
          name: 'transverse abdominis',
          articular: 1,
          origin: [Bone.spine],
        )
      });

  const Muscle({
    required this.nick,
    required this.pseudo,
    required this.insertion,
    required this.heads,
    required this.movements,
  });

  final List<String> nick;
  final bool pseudo;
  final Bone insertion;
  final List<Movement> movements;
  final Map<String, Head> heads;

  String nameWithHead(String? head) =>
      name.camelToTitle() + (head != null ? ' ($head head)' : '');

  List<MovementStruct> getMovements(Articulation a) => movements
      .where((mo) => mo.articulation == a)
      .map((mo) => MovementStruct(this, null, mo))
      .toList()
    ..addAll(heads.values.expand((head) => head.movements
        .where((mo) => mo.articulation == a)
        .map((mo) => MovementStruct(this, head.name, mo))));

  List<Articulation> getArticulations() => <Articulation>{
        ...movements.map((m) => m.articulation),
        ...heads.values.expand((h) => h.movements.map((m) => m.articulation))
      }.toList();
}

class Head {
  const Head({
    required this.name,
    required this.nick,
    required this.origin,
    required this.articular,
    required this.movements,
    this.activeInsufficiency,
    this.passiveInsufficiency,
  });

  final String name;
  final List<String> nick;
  final List<Bone> origin;
  final int articular;
  final List<Movement> movements;
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

class MovementStruct {
  final Muscle muscle;
  final String? head;
  final Movement mo;

  MovementStruct(this.muscle, this.head, this.mo);
}
