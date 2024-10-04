enum Articulation {
  cervicalSpineFlexion(nick: ['neck flexion'], constraint: null),
  cervicalSpineLateralFlexion(nick: ['neck lateral flexion'], constraint: null),
  cervicalSpineExtension(nick: ['neck extension'], constraint: null),
  cervicalSpineHyperextension(nick: ['neck hyperextension'], constraint: null),
  cervicalSpineRotation(nick: ['neck rotation'], constraint: null),
  scapularRetraction(
      nick: ['scapular adduction', 'scapular external rotation'],
      constraint: null),
  scapularProtraction(nick: ['scapular abduction'], constraint: null),
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
  shoulderHyperextension(nick: [], constraint: null),
  shoulderAdduction(nick: [], constraint: null),
  shoulderAbduction(nick: [], constraint: null),
  spinalExtension(nick: [], constraint: null),
  spinalHyperextension(nick: [], constraint: null),
  spinalFlexion(nick: [], constraint: null),
  spinalRotation(nick: [], constraint: null),
  spinalRotationLumbarThoracic(nick: [], constraint: null),
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
  ankleDorsiFlexion(nick: [], constraint: null),
  intraAbdominalPressure(
      nick: ["IAP"], constraint: "not an actual articulation"),
  hipAbduction(nick: [], constraint: null),
  hipAdduction(nick: [], constraint: null),
  hipFlexion(nick: [], constraint: null),
  hipExtension(nick: [], constraint: null),
  hipInternalRotation(nick: [], constraint: null),
  hipExternalRotation(nick: [], constraint: null),
  hipTransverseAbduction(nick: [], constraint: "hip flexed"),
  hipTransverseAdduction(nick: [], constraint: "hip flexed");

  const Articulation({
    required this.nick,
    required this.constraint,
  });

  final List<String> nick;
  final String? constraint;
}

// list relations between articulations
// we have two types of relations:
// directly related: the articulations go together in the same list at the deepest (2nd) level
// indirectly related: the articulations are in a group that is sibling with another group at the first level
// Note: at one point i considered making hyperextension part of extension, and have it be implicit (by passing 0)
// however, that's not how it works. e.g. glute maximus goes beyond 0 and it's just called extension, still
final _articulationRelated = [
  [
    [
      Articulation.cervicalSpineFlexion,
      Articulation.cervicalSpineExtension,
      Articulation.cervicalSpineHyperextension,
    ],
    [
      Articulation.spinalFlexion,
      Articulation.spinalExtension,
    ],
  ],
  [
    [
      Articulation.scapularProtraction,
      Articulation.scapularRetraction,
    ],
    [
      Articulation.scapularElevation,
      Articulation.scapularDepression,
    ],
    [
      Articulation.scapularDownardRotation,
      Articulation.scapularUpwardRotation,
    ],
  ],
  [
    [
      Articulation.shoulderTransverseAdduction,
      Articulation.shoulderTransverseAbduction,
    ],
    [
      Articulation.shoulderTransverseFlexion,
      Articulation.shoulderTransverseExtension,
    ],
    [
      Articulation.shoulderInternalRotation,
      Articulation.shoulderExternalRotation,
    ],
    [
      Articulation.shoulderFlexion,
      Articulation.shoulderExtension,
      Articulation.shoulderHyperextension,
    ],
    [
      Articulation.shoulderAdduction,
      Articulation.shoulderAbduction,
    ],
  ],
  [
    [
      Articulation.elbowFlexion,
      Articulation.elbowExtension,
    ],
    [
      Articulation.forearmPronation,
      Articulation.forearmSupination,
    ],
  ],
  [
    [
      Articulation.kneeFlexion,
      Articulation.kneeExtension,
    ],
    [
      Articulation.kneeInternalRotation,
      Articulation.kneeExternalRotation,
    ],
  ],
  [
    [
      Articulation.anklePlantarFlexion,
      Articulation.ankleDorsiFlexion,
    ],
  ],
  [
    [
      Articulation.hipAbduction,
      Articulation.hipAdduction,
    ],
    [
      Articulation.hipFlexion,
      Articulation.hipExtension,
    ],
    [
      Articulation.hipInternalRotation,
      Articulation.hipExternalRotation,
    ],
    [
      Articulation.hipTransverseAbduction,
      Articulation.hipTransverseAdduction,
    ],
  ],
];

// for the given articulation, return a tuple that has:
// the directly related articulations (deepest level)
// the indirectly related articulations (first level)
(List<Articulation>, List<Articulation>) relatedArticulations(
    Articulation articulation) {
  for (final group in _articulationRelated) {
    for (final subgroup in group) {
      if (subgroup.contains(articulation)) {
        final direct =
            subgroup.where((a) => a != articulation).toList(growable: false);

        final indirect = group
            .where((g) => g != subgroup)
            .expand((g) => g)
            .toList(growable: false);

        return (direct, indirect);
      }
    }
  }

  throw Exception('not found: $articulation');
}
