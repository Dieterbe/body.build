/*
- summary
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
  shoulderHyperExtension(nick: [], constraint: null),
  shoulderAdduction(nick: [], constraint: null),
  shoulderAbduction(nick: [], constraint: null),
  elbowExtension(nick: [], constraint: null),
  elbowFlexion(nick: [], constraint: null);

  const Articulation({
    required this.nick,
    required this.constraint,
  });

  final List<String> nick;
  final String? constraint;
}
