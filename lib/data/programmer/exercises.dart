import 'package:bodybuild/data/programmer/cues.dart';
import 'package:bodybuild/data/programmer/equipment.dart';
import 'package:bodybuild/data/programmer/groups.dart';
import 'package:bodybuild/data/programmer/modifier.dart';

// our own exercise class
// which allows to list exercises, categorized by base (so it can be matched)
// and wraps kaos.Exercise (when available) for more information,
// although not all information is used
// base is already a quite specific movement
// but the ex is an exact, specific, detailed exercise
// this class is built-in, and doesn't need to be persisted

// TODO: revisit menno's principles for exercise selection
class Ex {
  final VolumeAssignment volumeAssignment;
  final List<Equipment> equipment;
  final List<Modifier> modifiers;
  final Cues cues;
  final String
      id; // identifier to match to kaos exercise. does not need to be human friendly

  const Ex(this.volumeAssignment, this.id, this.equipment,
      [this.modifiers = const [], this.cues = defaultCues]);

  Assign recruitment(ProgramGroup pg, Map<String, String?> modifierOptions) {
    // establish base recruitment:
    var r = volumeAssignment.assign[pg] ?? const Assign(0);

    // Apply any equipment rules that apply
    for (final entry in volumeAssignment.assignEquip.entries) {
      if (equipment.contains(entry.key) && entry.value.containsKey(pg)) {
        r = r.merge(entry.value[pg]!);
      }
    }
    // Apply any modifiers that apply
    for (final modifier in modifiers) {
      final selectedOption =
          modifierOptions[modifier.name] ?? modifier.defaultVal;
      final optEffects = modifier.opts[selectedOption]!.$1;
      if (optEffects.containsKey(pg)) {
        r = r.merge(optEffects[pg]!);
      }
    }

    return r;
  }

  Assign recruitmentFiltered(
      ProgramGroup pg, Map<String, String?> modifierOptions, double cutoff) {
    final raw = recruitment(pg, modifierOptions);
    return raw.volume >= cutoff ? raw : const Assign(0);
  }

  double totalRecruitment(Map<String, String> modifierOptions) =>
      ProgramGroup.values.fold(0.0,
          (sum, group) => sum + recruitment(group, modifierOptions).volume);

  double totalRecruitmentFiltered(
          double cutoff, Map<String, String> modifierOptions) =>
      ProgramGroup.values.fold(
          0.0,
          (sum, group) =>
              sum + recruitmentFiltered(group, modifierOptions, cutoff).volume);
}

// TODO add pullup negatives. this is not eccentric overloads (those still have concentric)
// form modifiers like unilateral concentrics, unilateral, e.g. for leg ext, leg curls, calf raises
// important: id's should not change! perhaps we should introduce seperate human friendly naming
// TODO: annotate which exercises are 'preferred' by way of menno's recommendations, also those that are deficit or have larger ROM
// and also which are complimentary (e.g. bicep curls and rows to train at different lengths)
// for advanced, prefer barbell DL's over deadlifts maybe? and things like back extensions will use more than bodyweidht, bodyweight exercises like push-ups, squats don't make sense anymore
// generally machines/cables should come out better compared to body weight (e.g. nordic curls is less comfortable at least)
// todo give exercises properties to sort their quality by. e.g. range, train at long length, and also setup time
final List<Ex> exes = [
  const Ex(vaGoodMorning, "standing barbell good morning", [Equipment.barbell]),
  const Ex(
      vaGoodMorning, "standing dumbbell good morning", [Equipment.dumbbell]),
  const Ex(vaGoodMorning, "seated barbell good morning", [Equipment.barbell]),
  const Ex(vaGoodMorning, "seated dumbbell good morning", [Equipment.dumbbell]),

  const Ex(vaDeadlift, "deadlift (powerlift)", [Equipment.barbell]),
  const Ex(vaDeadlift, "deadlift", [Equipment.barbell]),
  const Ex(vaDeadlift, "dumbbell deadlift", [Equipment.dumbbell]),
  const Ex(vaDeadliftRDL, "romanian deadlift", [Equipment.barbell]),
  const Ex(vaDeadliftRDL, "dummbbell romanian deadlift", [Equipment.dumbbell]),

  const Ex(vaBackExtension, "45° back extension", [Equipment.hyper45]),
  const Ex(vaHipExtension, "45° hip extension", [Equipment.hyper45]),
  const Ex(vaHipExtension, "90° hip extension", [Equipment.hyper90]),
  const Ex(vaHipExtension, "reverse hyperextension", [Equipment.hyperReverse]),
  const Ex(vaPullThrough, "cable pull-through", [Equipment.cableTower]),

  Ex(vaLegCurlHipFlexed, "seated leg curl machine",
      [Equipment.hamCurlMachineSeated], [legCurlAnkleDorsiflexed]),
  Ex(vaLegCurlHipExtended, "standing unilateral leg curl machine",
      [Equipment.hamCurlMachineStanding], [legCurlAnkleDorsiflexed]),
  Ex(vaLegCurlHipExtended, "lying leg curl machine",
      [Equipment.hamCurlMachineLying], [legCurlAnkleDorsiflexed]),
  Ex(vaLegCurl, "bodyweight leg curl with trx", [Equipment.trx],
      [legCurlAnkleDorsiflexed, legCurlHipFlexion]),
  Ex(vaLegCurl, "bodyweight leg curl with rings", [Equipment.gymnasticRings],
      [legCurlAnkleDorsiflexed, legCurlHipFlexion]),
  Ex(vaLegCurl, "nordic curl", [],
      [legCurlAnkleDorsiflexed, legCurlHipFlexion]),

  Ex(vaSquatBBAndGoblet, "barbell squat", [Equipment.squatRack],
      [squatBarPlacement, squatLowerLegMovement]),
  Ex(vaSquatBBAndGoblet, "goblet squat", [], [
    squatLowerLegMovement
  ]), // for this one, the lower leg probably *always* moves
  Ex(vaLegPressSquatHackSquatBelt, "machine hack squat",
      [Equipment.hackSquatMachine], [squatLowerLegMovement]),
  Ex(vaLegPressSquatHackSquatBelt, "smith machine hack squat",
      [Equipment.smithMachineVertical], [squatLowerLegMovement]),
  Ex(vaLegPressSquatHackSquatBelt, "belt squat", [Equipment.beltSquatMachine],
      [squatLowerLegMovement]),
  Ex(vaSquatBSQ, "dumbbell bulgarian split squat", [Equipment.dumbbell],
      [bsqRearLeg, squatLowerLegMovement, deficit]),
  Ex(vaSquatBSQ, "barbell bulgarian split squat", [Equipment.barbell],
      [bsqRearLeg, squatLowerLegMovement, deficit]),
  Ex(
      vaSquatBSQ,
      "smith machine (vertical) bulgarian split squat",
      [Equipment.smithMachineVertical],
      [bsqRearLeg, squatLowerLegMovement, deficit]),
  Ex(
      vaSquatBSQ,
      "smith machine (angled) bulgarian split squat",
      [Equipment.smithMachineAngled],
      [bsqRearLeg, squatLowerLegMovement, deficit]),

  Ex(vaLegPressSquatHackSquatBelt, "machine leg press",
      [Equipment.legPressMachine], [squatLowerLegMovement]),
  Ex(vaLungeStepUp, "forward lunge", [], [squatLowerLegMovement, deficit]),
  Ex(vaLungeStepUp, "backward lunge", [], [squatLowerLegMovement, deficit]),
  Ex(vaLungeStepUp, "walking lunge", [], [squatLowerLegMovement]),
  Ex(vaLungeStepUp, "dumbbell forward lunge", [Equipment.dumbbell],
      [squatLowerLegMovement, deficit]),
  Ex(vaLungeStepUp, "dumbbell backward lunge", [Equipment.dumbbell],
      [squatLowerLegMovement, deficit]),
  Ex(vaLungeStepUp, "dumbbell walking lunge", [Equipment.dumbbell],
      [squatLowerLegMovement]),
  Ex(vaLungeStepUp, "step up", [], [squatLowerLegMovement]),

  Ex(vaSquatPistolSissyAssistedSpanish, "pistol squat", [],
      [squatLowerLegMovement]),
  Ex(vaLegExtensionReverseNordicHamCurlSquatSissy, "sissy squat", [],
      [legExtensionLean]),
  Ex(vaSquatPistolSissyAssistedSpanish, "assisted sissy squat", [],
      [legExtensionLean]),
  Ex(vaSquatPistolSissyAssistedSpanish, "spanish squat", [Equipment.elastic],
      [squatLowerLegMovement]),

  Ex(
      vaLegExtensionReverseNordicHamCurlSquatSissy,
      "seated leg extension machine",
      [Equipment.legExtensionMachine],
      [legExtensionLean],
      legExtensionCues),

  Ex(vaLegExtensionReverseNordicHamCurlSquatSissy, "reverse nordic ham curl",
      [], [legExtensionLean]),

  Ex(vaHipThrustGluteKickback, "barbell hip thrust", [Equipment.barbell],
      [hipExtensionKneeFlexion]),
  Ex(vaHipThrustGluteKickback, "smith machine hip thrust",
      [Equipment.smithMachineVertical], [hipExtensionKneeFlexion]),
  Ex(vaHipThrustGluteKickback, "machine hip thrust",
      [Equipment.hipThrustMachine], [hipExtensionKneeFlexion]),

  Ex(vaHipThrustGluteKickback, "glute kickback machine",
      [Equipment.gluteKickbackMachine], [hipExtensionKneeFlexion]),
  Ex(vaHipThrustGluteKickback, "pendulum glute kickback",
      [Equipment.pendulumGluteKickback], [hipExtensionKneeFlexion]),

  Ex(
      vaHipAbduction,
      "hip abduction machine",
      [Equipment.hipAdductionAbductionMachine],
      [hipAbductionHipFlexion('90°')]),
  Ex(vaHipAbduction, "standing cable hip abduction", [Equipment.cableTower],
      [hipAbductionHipFlexion('0°')]),
  Ex(
    vaHipAbductionStraightHip,
    "lying cable hip abduction",
    [Equipment.cableTower],
  ),

// TODO: unilateral modifiers and other forms
  const Ex(vaStandingCalfRaiseCalfJump, "standing calf raise machine",
      [Equipment.calfRaiseMachineStanding], [], standingCalfRaiseCues),
  const Ex(vaStandingCalfRaiseCalfJump, "barbell standing calf raise",
      [Equipment.barbell], [], standingCalfRaiseCues),
  const Ex(vaStandingCalfRaiseCalfJump, "dumbbell standing calf raise",
      [Equipment.dumbbell], [], standingCalfRaiseCues),
  const Ex(vaStandingCalfRaiseCalfJump, "smith machine standing calf raise",
      [Equipment.smithMachineVertical], [], standingCalfRaiseCues),
  const Ex(vaStandingCalfRaiseCalfJump, "leg press straight leg calf raise",
      [Equipment.legPressMachine], [], standingCalfRaiseCues),
  const Ex(vaSeatedCalfRaise, "seated calf raise machine",
      [Equipment.calfRaiseMachineSeated]),

  const Ex(vaStandingCalfRaiseCalfJump, "bodyweight calf jumps", []),
  const Ex(
      vaStandingCalfRaiseCalfJump, "dumbbell calf jumps", [Equipment.dumbbell]),
  const Ex(vaStandingCalfRaiseCalfJump, "leg press calf jumps",
      [Equipment.legPressMachine]),

  const Ex(vaPullupPulldownWidePronatedPullupWidePronated, "pullup",
      []), // just outside shoulder width
  // Ex(EBase.?, "pullup close grip pronated", []),

  const Ex(
      vaPullupSupinatedPulldownSupinatedPullDownPulldownNeutralPullupNeutralDiagonalRow,
      "pullup gymnastic rings",
      [Equipment.gymnasticRings]), // TODO see if recruitment should be adjusted
  const Ex(
      vaPullupSupinatedPulldownSupinatedPullDownPulldownNeutralPullupNeutralDiagonalRow,
      "pullup neutral grip", []),
  const Ex(
      vaPullupSupinatedPulldownSupinatedPullDownPulldownNeutralPullupNeutralDiagonalRow,
      "pullup supinated grip", []), // chin-up
  const Ex(vaPullupPulldownWidePronatedPullupWidePronated,
      "pullup wide pronated grip", []),

  const Ex(vaPullupPulldownWidePronatedPullupWidePronated, "lat pulldown",
      [Equipment.latPullDownMachine]),
  const Ex(
      vaPullupSupinatedPulldownSupinatedPullDownPulldownNeutralPullupNeutralDiagonalRow,
      "lat pulldown neutral grip",
      [Equipment.latPullDownMachine]),
  const Ex(
      vaPullupSupinatedPulldownSupinatedPullDownPulldownNeutralPullupNeutralDiagonalRow,
      "lat pulldown supinated grip",
      [Equipment.latPullDownMachine]),
  const Ex(vaPullupPulldownWidePronatedPullupWidePronated,
      "lat pulldown wide pronated grip", [Equipment.latPullDownMachine]),

  const Ex(
      vaPullupSupinatedPulldownSupinatedPullDownPulldownNeutralPullupNeutralDiagonalRow,
      "kneeling diagonal cable row",
      [Equipment.cableTower]),
  Ex(vaRow, "seated cable row", [
    Equipment.cableRowMachine
  ], [
    Modifier('spine', 'still', {
      'still': (
        {
          ProgramGroup.lats: const Assign(1, 'not full stretch'),
          ProgramGroup.spinalErectors: const Assign(0.25, 'isometric'),
        },
        'keep the spine upright'
      ),
      'dynamic': (
        {
          ProgramGroup.lats: const Assign(1, 'near full stretch'),
          ProgramGroup.spinalErectors:
              const Assign(0.5, 'flexion & extension cycles'),
        },
        'flex/extend the spine to go beyond the normal rowing motion, to achieve greater lat stretch and erector spinae workout'
      )
    }),
    Modifier('grip width', 'shoulder', {
      'shoulder': ({}, ''),
      'wide': (
        {
          ProgramGroup.rearDelts: const Assign(
              1, 'shoulder horizontal extension + shoulder extension'),
          ProgramGroup.lowerTraps:
              const Assign(1, 'scapular retraction + depression'),
          ProgramGroup.lats:
              const Assign(1, 'shoulder extension + shoulder adduction'),
        },
        ''
      )
    })
  ]),

  // TODO many different grips. those should affect recruitment similar to pullup types
  const Ex(
      vaRowWithSpineIso, "standing bent over barbell row", [Equipment.barbell]),

  const Ex(vaRowWithoutSpine, "bench supported single arm dumbbell rows",
      [Equipment.dumbbell]),
  const Ex(vaRowWithoutSpine, "chest supported machine rows",
      [Equipment.rowMachine]),

  const Ex(vaPullOverLatPrayer, "pull over", [Equipment.cableTower]),
  const Ex(vaPullOverLatPrayer, "lat prayer", [Equipment.cableTower]),
  const Ex(vaHighRowRearDeltFlyRearDeltRaiseShoulderPullFacePull,
      "seated cable high row", [Equipment.cableRowMachine]),

  const Ex(
      vaHighRowRearDeltFlyRearDeltRaiseShoulderPullFacePull,
      "rear delt fly machine",
      [Equipment.rearDeltFlyMachine]), // TODO unilateral has more ROM
  const Ex(vaHighRowRearDeltFlyRearDeltRaiseShoulderPullFacePull,
      "standing unilateral cable rear delt fly", [Equipment.cableTower]),

  const Ex(vaHighRowRearDeltFlyRearDeltRaiseShoulderPullFacePull,
      "side lying rear delt dumbbell raise", [Equipment.dumbbell]),

// TODO: what's the diff again with face pulls? can we do this on trx?
  const Ex(vaHighRowRearDeltFlyRearDeltRaiseShoulderPullFacePull,
      "standing cable shoulder pull", [Equipment.cableTower]),
  const Ex(vaHighRowRearDeltFlyRearDeltRaiseShoulderPullFacePull,
      "seated cable shoulder pull", [Equipment.cableRowMachine]),

  const Ex(vaHighRowRearDeltFlyRearDeltRaiseShoulderPullFacePull,
      "standing cable face pull", [Equipment.cableTower]),
  const Ex(vaHighRowRearDeltFlyRearDeltRaiseShoulderPullFacePull,
      "seated cable face pull", [Equipment.cableRowMachine]),
  const Ex(vaHighRowRearDeltFlyRearDeltRaiseShoulderPullFacePull,
      "TRX face pull", [Equipment.trx]),

  const Ex(vaBenchPressBBChestPressMachineDip,
      "flat barbell bench press (powerlift)", [Equipment.barbell]),
  const Ex(vaBenchPressBBChestPressMachineDip, "flat barbell bench press",
      [Equipment.barbell]),
  const Ex(vaBenchPressBBChestPressMachineDip, "15° barbell bench press",
      [Equipment.barbell]),
  const Ex(vaBenchPressBBChestPressMachineDip, "flat bench press smith machine",
      [Equipment.smithMachineAngled]),

  const Ex(vaBenchPressBBChestPressMachineDip, "chest press machine",
      [Equipment.chestPressMachine]),

  Ex(vaPushUp, "push-up", [], [deficit]),
  const Ex(vaBenchPressDBChestPressCable, "flat dumbbell bench press",
      [Equipment.dumbbell]),
  const Ex(vaBenchPressDBChestPressCable, "15° dumbbell bench press",
      [Equipment.dumbbell]),
  const Ex(vaBenchPressDBChestPressCable, "cable chest press",
      [Equipment.cableTowerDual]),

  const Ex(vaBenchPressBBChestPressMachineDip, "dip", []),
  const Ex(vaBenchPressBBChestPressMachineDip, "assisted dip machine",
      [Equipment.assistedDipMachine]),
  Ex(vaFlyPecDeckHandGrip, "laying dumbbell fly", [Equipment.dumbbell],
      [flyThumbs]),
  Ex(vaFlyPecDeckHandGrip, "chest fly machine", [Equipment.chestFlyMachine],
      [flyThumbs]),

  Ex(vaFlyPecDeckHandGrip, "bayesian fly", [
    Equipment.cableTower
  ], [
    flyThumbs
  ]), // TODO: what makes it bayesian? machine vs single vs dual cables? seated or standing? ROM?
  const Ex(
      vaPecDeckElbowPad, "pec deck (elbow pad)", [Equipment.pecDeckMachine]),
  Ex(vaFlyPecDeckHandGrip, "chest machine fly (pec deck with hand grip)",
      [Equipment.chestFlyMachine], [flyThumbs]),

  const Ex(vaOverheadPressDB, "dumbbell overhead press", [Equipment.dumbbell]),
  const Ex(vaOverheadPressBB, "barbell overhead press", [Equipment.barbell]),
  const Ex(vaOverheadPressBB, "shoulder press machine",
      [Equipment.shoulderPressMachine]),

  Ex(vaLateralRaise, "standing dumbbell lateral raise", [Equipment.dumbbell],
      [lateralRaiseShoulderRotation]),
  Ex(vaLateralRaise, "standing cable lateral raise", [Equipment.cableTower],
      [lateralRaiseShoulderRotation, lateralRaiseCablePath]),
  const Ex(vaShrug, "barbell shrug", [Equipment.barbell]),
  const Ex(vaShrug, "wide grip barbell shrug", [Equipment.barbell]),
  const Ex(vaShrug, "dumbbell shrug", [Equipment.dumbbell]),

  const Ex(vaTricepExtensionOverhead, "cable overhead tricep extension", [
    Equipment.cableTower
  ], [], {
    "RP style": (
      false,
      "use small bar. elbows in - up & back to down & forward. see [this instagram reel](https://www.instagram.com/reel/DEUw9COM-K8)"
    )
  }),
  const Ex(vaTricepExtensionOverhead, "dumbbell overhead tricep extension",
      [Equipment.dumbbell]),
  const Ex(vaTricepExtension, "dumbbell skull-over", [Equipment.dumbbell]),
  const Ex(vaTricepExtension, "barbell skull-over", [Equipment.barbell]),
  const Ex(vaTricepExtension, "elastic skull-over", [Equipment.elastic]),
  const Ex(vaTricepExtension, "tricep kickback", [Equipment.dumbbell]),
  const Ex(vaTricepExtension, "tricep cable pushdown", [Equipment.cableTower]),

  const Ex(vaBicepCurl, "barbell bicep curl", [Equipment.barbell]),
  const Ex(vaBicepCurl, "cable bicep curl", [Equipment.cableTower]),
  const Ex(vaBicepCurl, "dumbbell bicep curl", [Equipment.dumbbell]),
  const Ex(vaBicepCurl, "dumbbell hammer bicep curl", [Equipment.dumbbell]),
  const Ex(vaBicepCurl, "kettlebell bicep curl", [Equipment.kettlebell]),
  const Ex(vaBicepCurl, "preacher bicep curl machine",
      [Equipment.preacherCurlMachine]),
  const Ex(vaBicepCurl, "preacher bicep curl bench/barbell",
      [Equipment.preacherCurlBench]),
  const Ex(vaBicepCurl, "bicep curl machine", [Equipment.bicepCurlMachine]),
  const Ex(vaBicepCurl, "bayesian curl", [Equipment.cableTower]),
  const Ex(
      vaBicepCurl, "concentration curl", [Equipment.dumbbell]), // unilateral

  const Ex(vaAbCrunch, "ab crunch machine", [Equipment.abCrunchMachine]),
  const Ex(vaAbCrunch, "cable ab crunch", [Equipment.cableTower]),
  const Ex(vaAbCrunch, "laying ab crunch", []),
  const Ex(vaAbIsometric, "plank", []),
  const Ex(vaWristFlexion, "dumbbell wrist curls", [Equipment.dumbbell]),
  const Ex(vaWristExtension, "dumbbell wrist extensions", [Equipment.dumbbell]),
];

/// Returns a filtered list of exercises based on various criteria:
/// - Excludes exercises specified in [excludedExercises]
/// - Excludes exercises with base types in [excludedBases]
/// - If [availEquipment] is provided, only includes exercises that use available equipment
List<Ex> getAvailableExercises({
  Set<Ex>? excludedExercises,
  Set<Equipment>? availEquipment,
}) {
  return exes.where((e) {
    if (excludedExercises?.contains(e) ?? false) return false;
    if (availEquipment != null && !e.equipment.every(availEquipment.contains)) {
      return false;
    }
    return true;
  }).toList();
}

/*
loadKaos() async {
  var warnings = 0;
  var matches = 0;
  var jsonString = await s.rootBundle.loadString('assets/exercises.json');
  var j = json.decode(jsonString);
  final kaosExs = ExerciseList.fromJson(j);
  for (var kaosEx in kaosExs.exercises) {
    if (kaosEx.category == Category.resistance) {
      var found = false;
      for (var ex in exes) {
        if (ex.id == kaosEx.id) {
          ex.exercise = kaosEx;
          found = true;
          matches++;
          break;
        }
      }
      if (!found) {
        warnings++;
        print('WARNING: no PTC exercise for kaos:${kaosEx.id}');
      }
    }
  }

  for (var ex in exes) {
    if (ex.exercise == null) {
      warnings++;
      print('WARNING: no kaos exercise for PTC ${ex.id}');
    }
  }
  print('total found: $matches - warnings: $warnings');
}
*/
/*
TODO
Plank - 1 Abs (needs some isometric ab work to learn to control his core rigidity and lumbopelvic movement
Gastrocs and soleus a little higher because they often need a little more volume
*/
