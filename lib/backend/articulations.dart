enum Articulation {
  cervicalSpineFlexion(nick: ['neck flexion'], constraint: null),
  cervicalSpineLateralFlexion(nick: ['neck lateral flexion'], constraint: null),
  cervicalSpineExtension(nick: ['neck extension'], constraint: null),
  cervicalSpineHyperExtension(nick: ['neck hyperextension'], constraint: null),
  cervicalRotation(nick: ['neck rotation'], constraint: null),
  scapularRetraction(
      nick: ['scapular adduction', 'scapular external rotation'],
      constraint: null),
  scapularDepression(nick: [], constraint: null),
  scapularDownardRotation(nick: [], constraint: null),
  scapularElevation(nick: [], constraint: null),
  scapularUpwardRotation(nick: [], constraint: null),
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
  shoulderTransverseAbduction(
      nick: [], constraint: "shoulder externally rotated"),
  shoulderInternalRotation(nick: ['arm internal rotation'], constraint: null),
  shoulderExternalRotation(nick: ['arm external rotation'], constraint: null),
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
  forearmPronation(nick: [], constraint: null),
  kneeFlexion(nick: [], constraint: null),
  kneeExtension(nick: [], constraint: null),
  kneeInternalRotation(nick: [], constraint: null),
  kneeExternalRotation(nick: [], constraint: null),
  anklePlantarFlexion(nick: [], constraint: null),
  hipAbduction(nick: [], constraint: null),
  hipAdduction(nick: [], constraint: null),
  hipFlexion(nick: [], constraint: null),
  hipExtension(nick: [], constraint: null),
  hipInternalRotation(nick: [], constraint: null),
  hipExternalRotation(nick: [], constraint: null),
  hipTransverseAbduction(nick: [], constraint: "hip flexed");

  const Articulation({
    required this.nick,
    required this.constraint,
  });

  final List<String> nick;
  final String? constraint;
}
