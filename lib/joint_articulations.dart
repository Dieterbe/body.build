/*
- summary
	- *bi- or tri- articulate cursive*
	- Pectoralis major (chest/‘pecs’)
		- sternum&clavicle - humerus
		- entire muscle
			- shoulder transverse adduction (thumbs up)
			- shoulder transverse flexion (shoulder internally rotated. thumbs inside/down)
			- arm internal rotation
		- clavicular head
			- shoulder flexion
			- shoulder abduction (needs some shoulder transverse? flexion)
		- sternal head
			- shoulder extension
			- shoulder adduction (low activation/moment arm)
	- Triceps brachii
		- *long head (scapula), inside*
		- lateral head (top of humerus) - outside of arm
		- medial head (middle of humerus) - covered
		- entire muscle
			- elbow extension. max leverage @ straight
		- *long head*
			- shoulder extension and hyperextension (very weak)
			- shoulder adduction  (weak)
			- active insufficiency when adduction/extension + elbow extension and passive, when vice versa
	- Latissimus dorsi (‘lats’)
		- spine & sacrum
		- pelvis
		- lower 3/4 ribs
		- scapula (very weak)
		- insertion point: front of humerus
		- helper for shoulder extension, adduction and internal rotation: teres major
		- bio
			- shoulder extension (peak at 45 degrees, zero at 120 and more)
				- ( (slight emphasis on upper lats) )
			- shoulder adduction (especially with external rotation, e.g. wide grip pull up) (peak at 75 degrees)
				- (emphasis on lower lats)
			- internal arm rotation
			- horizontal shoulder extension (very weak)
			- scapular retraction (auddiction) (very weak)
			- scapular depression (very weak)
			- scapular downward rotation (very weak)
			- spinal extension, rotation, lateral flexion (very weak)
	- Biceps brachii / elbow flexors
		- 3 elbow flexors:
			- *biceps brachii: short and long head, both from scapula*
			- brachialis (small, invisible under biceps) (humerus)
			- *brachioradialis: also pronator/supinator to neutral (humerus to radioulnar)*
			- most flexion leverage at 90degrees
			- brachioradialis greater moment arm in neutral (hammer grip)
			- biceps greater moment arm in supinated grip
				- TODO does the moment arm say anything about hypertrophy? greater moment arm means less force needed for same torque, so less growth?
			- forearm supination
				- both biceps and brachioradialis
				- more pronation is more moment arm
			- shoulder flexion, abduction (biceps, very weak)
				- shortening muscle can read to insufficiency
	- Trapezius (‘traps’)
		- stabilizers during many movements
		- *upper (to clavicle)*
			- verticalish from skull
			- from cervical spine (neck)
			- bio
				- scapular elevation
					- need some level of abduction. e.g. wide grip shrugs
					- keep head forward, otherwise active insufficiency
				- neck lateral flexion (upper)
				- neck/cervical spine extension & hyperextension (upper)
				- neck rotation (upper)
				- scapular retraction (weak)
		- middle: horizontal to scapula
			- scapular retraction/adduction
			- scapular elevation (very weak, low engagement)
			- scapular upward rotation
		- lower: spine to scapula
			- scapular depression
			- scapular retration/adduction
			- scapular upward rotation
	- Deltoids (shoulders/‘delts’)
		- front: clavicle to humerus
			- transverse adduction (externally rotated) (very weak)
			- transverse flexion (internally rotated)
				- best leverage horizontal til 45degrees, then its pecs
			- shoulder flexion
				- better leverage than pecs, especially with higher arms
			- shoulder internal rotation
			- shoulder abduction (when shoulder is externally rotated)
		- lateral delt: scapula to humerus
			- shoulder abduction
			- shoulder flexion (esp when shoulder internally rotated)
			- horizontal abduction (when shoulder externally rotated)
		- rear delt: scapula to humerus
			- transverse abduction and extension
				- (internal rotation, ie extension, gives better leverage)
			- shoulder extension and hyperextension
				- best leverage at the side or behind back
			- external rotation
	- Gluteals (‘glutes’/butt)
		- maximus
		- medius
		- minimus (invisible)
			- hip abduction
			- internal hip rotation during abduction
		-
	-
  */
// this list is not exhaustive
// it's just meant to reference our muscle's insertions and origins
enum Bone {
  humerus, // upper arm
  sternum, // center chest
  clavicle,
}

enum Muscle {
  pectoralisMajor(
      pseudo: false,
      nick: ['chest', 'pecs'],
      insertion: Bone.humerus,
      heads: {
        'clavicular': Head(
          name: 'clavicular',
          nick: ['upper'],
          origin: Bone.clavicle,
          articular: 1,
        ),
        'sternal': Head(
          name: 'sternal',
          nick: ['lower'],
          origin: Bone.sternum,
          articular: 1,
        )
      });

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
}

class Head {
  const Head({
    required this.name,
    required this.nick,
    required this.origin,
    required this.articular,
  });

  final String name;
  final List<String> nick;
  final Bone origin;
  final int articular;
}

enum Articulation {
  shoulderTransverseAdduction(
      nick: ['shoulder horizontal adduction'],
      constraint: "shoulder externally rotated (thumbs up)"),
  shoulderTransverseFlexion(
      nick: ['shoulder horizontal flexion'],
      constraint:
          "shoulder internally rotated (thumbs pointing towards each other or down)"),
  shoulderInternalRotation(nick: ['arm internal rotation'], constraint: null),
  shoulderFlexion(nick: [], constraint: null),
  shoulderExtension(nick: [], constraint: null),
  shoulderAdduction(nick: [], constraint: null),
  shoulderAbduction(nick: [], constraint: null);

  const Articulation({
    required this.nick,
    required this.constraint,
  });

  final List<String> nick;
  final String? constraint;
}

class Movement {
  const Movement({
    required this.muscle,
    required this.head,
    required this.articulation,
    required this.rangeBegin,
    required this.rangeEnd,
    required this.momentMax,
  });
  final Muscle? muscle;
  final Head? head; // if null, means all heads
  final Articulation articulation;
  final int rangeBegin;
  final int rangeEnd;
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
    head: null,
    articulation: Articulation.shoulderInternalRotation,
    rangeBegin: 0,
    rangeEnd: 70,
    momentMax: null,
  ),
  Movement(
    articulation: Articulation.shoulderFlexion,
    muscle: null,
    head: Muscle.pectoralisMajor.heads['clavicular'],
    rangeBegin: 0,
    rangeEnd: 160,
    momentMax: null,
  ),
  Movement(
    articulation: Articulation.shoulderAbduction,
    muscle: null,
    head: Muscle.pectoralisMajor.heads['clavicular'],
    rangeBegin: 0,
    rangeEnd: 180,
    momentMax: 0,
// note: pec activity is reduced if there is no shoulder flexion.
// e.g. a behind the neck press.
// see https://www.frontiersin.org/journals/physiology/articles/10.3389/fphys.2022.825880/full
  ),
  Movement(
    muscle: null,
    head: Muscle.pectoralisMajor.heads['sternal'],
    articulation: Articulation.shoulderExtension,
    rangeBegin: 0,
    rangeEnd: 170,
    momentMax: null,
  ),
  Movement(
      // only the lowest pec fibers are very active at higher angles of shoulder abduction
      // see https://www.sciencedirect.com/science/article/abs/pii/1050641194900175?via%3Dihub
      articulation: Articulation.shoulderAdduction,
      muscle: null,
      head: Muscle.pectoralisMajor.heads['sternal'],
      rangeBegin: 0,
      rangeEnd: 170,
      momentMax: null),
];
