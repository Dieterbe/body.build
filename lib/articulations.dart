/*
- summary
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
  scapularRetraction(nick: ['scapular adduction'], constraint: null),
  scapularDepression(nick: [], constraint: null),
  scapularDownardRotation(nick: [], constraint: null),
  shoulderTransverseAdduction(
      nick: ['shoulder horizontal adduction'],
      constraint: "shoulder externally rotated (thumbs up)"),
  shoulderTransverseFlexion(
      nick: ['shoulder horizontal flexion'],
      constraint:
          "shoulder internally rotated (thumbs pointing towards each other or down)"),
  shoulderTransverseExtension(
      nick: ['shoulder horizontal extension'],
      constraint: "shoulder internally rotated"),
  shoulderInternalRotation(nick: ['arm internal rotation'], constraint: null),
  shoulderFlexion(nick: [], constraint: null),
  shoulderExtension(nick: [], constraint: null),
  shoulderHyperExtension(nick: [], constraint: null),
  shoulderAdduction(nick: [], constraint: null),
  shoulderAbduction(nick: [], constraint: null),
  spinalExtension(nick: [], constraint: null),
  spinalRotation(nick: [], constraint: null),
  spinalLateralFlexion(nick: [], constraint: null),
  elbowExtension(nick: [], constraint: null),
  elbowFlexion(nick: [], constraint: null),
  forearmSupination(nick: [], constraint: null),
  forearmPronation(nick: [], constraint: null);

  const Articulation({
    required this.nick,
    required this.constraint,
  });

  final List<String> nick;
  final String? constraint;
}
