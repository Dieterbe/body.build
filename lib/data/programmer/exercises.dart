import 'package:bodybuild/data/programmer/equipment.dart';
import 'package:bodybuild/data/programmer/exercise_base.dart';
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
  EBase base;
  List<Equipment> equipment;
  List<Modifier> modifiers;
  String
      id; // identifier to match to kaos exercise. does not need to be human friendly
  // TODO: in fact, should be super specific here? to account for future additions of other
  // variations? e.g. add "barbell" even when that is obvious
  //Exercise? exercise;
  late VolumeAssignment va;

  Ex(this.base, this.id, this.equipment, [this.modifiers = const []]) {
    // for now, rely on the idea that we have 1 rule for each type of exercise
    // perhaps in the future we can do something more fancy with rules overriding each other etc
    for (var v in volumeAssignments) {
      if (v.match.contains(base)) {
        va = v;
        return;
      }
    }
    throw Exception(
        'no matching volume assignment found for exercise with id $id');
  }

  Assign recruitment(ProgramGroup pg, Map<String, String?> modifierOptions) {
    // establish base recruitment:
    var r = va.assign[pg] ?? const Assign(0);

    // Apply any equipment rules that apply
    for (final entry in va.assignEquip.entries) {
      if (equipment.contains(entry.key) && entry.value.containsKey(pg)) {
        r = r.merge(entry.value[pg]!);
      }
    }
    // Apply any modifiers that apply
    for (final modifier in modifiers) {
      final selectedOption =
          modifierOptions[modifier.name] ?? modifier.defaultVal;
      final optEffects = modifier.opts[selectedOption];
      if (optEffects != null && optEffects.containsKey(pg)) {
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
  Ex(EBase.goodMorning, "standing barbell good morning", [Equipment.barbell]),
  Ex(EBase.goodMorning, "standing dumbbell good morning", [Equipment.dumbbell]),
  Ex(EBase.goodMorning, "seated barbell good morning", [Equipment.barbell]),
  Ex(EBase.goodMorning, "seated dumbbell good morning", [Equipment.dumbbell]),

  Ex(EBase.deadlift, "deadlift (powerlift)", [Equipment.barbell]),
  Ex(EBase.deadlift, "deadlift", [Equipment.barbell]),
  Ex(EBase.deadlift, "dumbbell deadlift", [Equipment.dumbbell]),
  Ex(EBase.deadliftRDL, "romanian deadlift", [Equipment.barbell]),
  Ex(EBase.deadliftRDL, "dummbbell romanian deadlift", [Equipment.dumbbell]),

  Ex(EBase.backExtension, "45° back extension", [Equipment.hyper45]),
  Ex(EBase.hipExtension, "45° hip extension", [Equipment.hyper45]),
  Ex(EBase.hipExtension, "90° hip extension", [Equipment.hyper90]),
  Ex(EBase.hipExtension, "reverse hyperextension", [Equipment.hyperReverse]),
  Ex(EBase.pullThrough, "cable pull-through", [Equipment.cableTower]),

  Ex(EBase.legCurlHipFlexed, "seated leg curl machine",
      [Equipment.hamCurlMachineSeated], [legCurlAnkleDorsiflexed]),
  Ex(EBase.legCurlHipExtended, "standing unilateral leg curl machine",
      [Equipment.hamCurlMachineStanding], [legCurlAnkleDorsiflexed]),
  Ex(EBase.legCurlHipExtended, "lying leg curl machine",
      [Equipment.hamCurlMachineLying], [legCurlAnkleDorsiflexed]),
  Ex(EBase.legCurlHipExtended, "bodyweight leg curl with trx (hip extended)",
      [Equipment.trx], [legCurlAnkleDorsiflexed]),
  Ex(EBase.legCurlHipExtended, "bodyweight leg curl with rings (hip extended)",
      [Equipment.gymnasticRings], [legCurlAnkleDorsiflexed]),
  Ex(EBase.legCurlHipExtended, "nordic curl (hip extended)", [],
      [legCurlAnkleDorsiflexed]),

  Ex(EBase.squatBB, "barbell squat", [Equipment.squatRack],
      [squatBarPlacement, squatLowerLegMovement]),
  Ex(EBase.squatGoblet, "goblet squat", [], [
    squatLowerLegMovement
  ]), // for this one, the lower leg probably *always* moves
  Ex(EBase.squatHack, "machine hack squat", [Equipment.hackSquatMachine],
      [squatLowerLegMovement]),
  Ex(EBase.squatHack, "smith machine hack squat",
      [Equipment.smithMachineVertical], [squatLowerLegMovement]),
  Ex(EBase.squatBelt, "belt squat", [Equipment.beltSquatMachine],
      [squatLowerLegMovement]),
  Ex(EBase.squatBSQ, "dumbbell bulgarian split squat", [Equipment.dumbbell],
      [bsqRearLeg, squatLowerLegMovement, deficit]),
  Ex(EBase.squatBSQ, "barbell bulgarian split squat", [Equipment.barbell],
      [bsqRearLeg, squatLowerLegMovement, deficit]),
  Ex(
      EBase.squatBSQ,
      "smith machine (vertical) bulgarian split squat",
      [Equipment.smithMachineVertical],
      [bsqRearLeg, squatLowerLegMovement, deficit]),
  Ex(
      EBase.squatBSQ,
      "smith machine (angled) bulgarian split squat",
      [Equipment.smithMachineAngled],
      [bsqRearLeg, squatLowerLegMovement, deficit]),

  Ex(EBase.legPress, "machine leg press", [Equipment.legPressMachine],
      [squatLowerLegMovement]),
  Ex(EBase.lunge, "forward lunge", [], [squatLowerLegMovement, deficit]),
  Ex(EBase.lunge, "backward lunge", [], [squatLowerLegMovement, deficit]),
  Ex(EBase.lunge, "walking lunge", [], [squatLowerLegMovement]),
  Ex(EBase.lunge, "dumbbell forward lunge", [Equipment.dumbbell],
      [squatLowerLegMovement, deficit]),
  Ex(EBase.lunge, "dumbbell backward lunge", [Equipment.dumbbell],
      [squatLowerLegMovement, deficit]),
  Ex(EBase.lunge, "dumbbell walking lunge", [Equipment.dumbbell],
      [squatLowerLegMovement]),
  Ex(EBase.stepUp, "step up", [], [squatLowerLegMovement]),

  Ex(EBase.squatPistol, "pistol squat", [], [squatLowerLegMovement]),
  Ex(EBase.squatSissy, "sissy squat", [], [squatLowerLegMovement]),
  Ex(EBase.squatSissyAssisted, "assisted sissy squat", [],
      [squatLowerLegMovement]),
  Ex(EBase.squatSpanish, "spanish squat", [Equipment.elastic],
      [squatLowerLegMovement]),

  Ex(EBase.legExtension, "seated leg extension machine",
      [Equipment.legExtensionMachine], [legExtensionLean]),

  Ex(EBase.reverseNordicHamCurl, "reverse nordic ham curl", []),

  Ex(EBase.hipThrust, "barbell hip thrust", [Equipment.barbell],
      [hipExtensionKneeFlexion]),
  Ex(EBase.hipThrust, "smith machine hip thrust",
      [Equipment.smithMachineVertical], [hipExtensionKneeFlexion]),
  Ex(EBase.hipThrust, "machine hip thrust", [Equipment.hipThrustMachine],
      [hipExtensionKneeFlexion]),

  Ex(EBase.gluteKickback, "glute kickback machine",
      [Equipment.gluteKickbackMachine], [hipExtensionKneeFlexion]),
  Ex(EBase.gluteKickback, "pendulum glute kickback",
      [Equipment.pendulumGluteKickback], [hipExtensionKneeFlexion]),

  Ex(
      EBase.hipAbduction,
      "hip abduction machine",
      [Equipment.hipAdductionAbductionMachine],
      [hipAbductionHipFlexion('90°')]),
  Ex(EBase.hipAbduction, "standing cable hip abduction", [Equipment.cableTower],
      [hipAbductionHipFlexion('0°')]),
  Ex(
    EBase.hipAbduction,
    "lying cable hip abduction",
    [Equipment.cableTower],
  ),

  Ex(EBase.standingCalfRaise, "smith machine standing calf raise",
      [Equipment.smithMachineVertical]),
  Ex(EBase.standingCalfRaise, "smith machine standing calf raise (unilateral)",
      [Equipment.smithMachineVertical]),
  Ex(EBase.standingCalfRaise, "standing calf raise machine",
      [Equipment.calfRaiseMachineStanding]),
  // TODO add more standing ones: unilateral, dummbell, barbell, on leg press
  Ex(EBase.seatedCalfRaise, "seated calf raise machine",
      [Equipment.calfRaiseMachineSeated]),

  Ex(EBase.calfJump, "bodyweight calf jumps", []),
  Ex(EBase.calfJump, "dumbbell calf jumps", [Equipment.dumbbell]),
  Ex(EBase.calfJump, "leg press calf jumps", [Equipment.legPressMachine]),

  Ex(EBase.pullup, "pullup", []), // just outside shoulder width
  // Ex(EBase.?, "pullup close grip pronated", []),

  Ex(EBase.pullupNeutral, "pullup gymnastic rings",
      [Equipment.gymnasticRings]), // TODO see if recruitment should be adjusted
  Ex(EBase.pullupNeutral, "pullup neutral grip", []),
  Ex(EBase.pullupSupinated, "pullup supinated grip", []), // chin-up
  Ex(EBase.pullupWidePronated, "pullup wide pronated grip", []),

  Ex(EBase.pulldown, "lat pulldown", [Equipment.latPullDownMachine]),
  Ex(EBase.pulldownNeutral, "lat pulldown neutral grip",
      [Equipment.latPullDownMachine]),
  Ex(EBase.pulldownSupinated, "lat pulldown supinated grip",
      [Equipment.latPullDownMachine]),
  Ex(EBase.pulldownWidePronated, "lat pulldown wide pronated grip",
      [Equipment.latPullDownMachine]),

  Ex(EBase.diagonalRow, "kneeling diagonal cable row", [Equipment.cableTower]),
  Ex(EBase.rowWithSpine, "seated cable row with forward lean",
      [Equipment.cableRowMachine]),
  Ex(
      EBase.rowWithSpineWideGrip,
      "seated cable row with forward lean, wide grip",
      [Equipment.cableRowMachine]),

  // TODO many different grips. those should affect recruitment similar to pullup types
  Ex(EBase.rowWithSpineIso, "standing bent over barbell row",
      [Equipment.barbell]),
  Ex(EBase.rowWithSpineIso, "seated cable row (without forward lean)",
      [Equipment.cableRowMachine]),
  Ex(EBase.rowWithoutSpine, "bench supported single arm dumbbell rows",
      [Equipment.dumbbell]),
  Ex(EBase.rowWithoutSpine, "chest supported machine rows",
      [Equipment.rowMachine]),

  Ex(EBase.pullOver, "pull over", [Equipment.cableTower]),
  Ex(EBase.latPrayer, "lat prayer", [Equipment.cableTower]),
  Ex(EBase.highRow, "seated cable high row", [Equipment.cableRowMachine]),

  Ex(EBase.rearDeltFly, "rear delt fly machine",
      [Equipment.rearDeltFlyMachine]), // TODO unilateral has more ROM
  Ex(EBase.rearDeltFly, "standing unilateral cable rear delt fly",
      [Equipment.cableTower]),

  Ex(EBase.rearDeltRaise, "side lying rear delt dumbbell raise",
      [Equipment.dumbbell]),

// TODO: what's the diff again with face pulls? can we do this on trx?
  Ex(EBase.shoulderPull, "standing cable shoulder pull",
      [Equipment.cableTower]),
  Ex(EBase.shoulderPull, "seated cable shoulder pull",
      [Equipment.cableRowMachine]),

  Ex(EBase.facePull, "standing cable face pull", [Equipment.cableTower]),
  Ex(EBase.facePull, "seated cable face pull", [Equipment.cableRowMachine]),
  Ex(EBase.facePull, "TRX face pull", [Equipment.trx]),

  Ex(EBase.benchPressBB, "flat barbell bench press (powerlift)",
      [Equipment.barbell]),
  Ex(EBase.benchPressBB, "flat barbell bench press", [Equipment.barbell]),
  Ex(EBase.benchPressBB, "15° barbell bench press", [Equipment.barbell]),
  Ex(EBase.benchPressBB, "flat bench press smith machine",
      [Equipment.smithMachineAngled]),

  Ex(EBase.chestPressMachine, "chest press machine",
      [Equipment.chestPressMachine]),

  Ex(EBase.pushUp, "push-up", [], [deficit]),
  Ex(EBase.benchPressDB, "flat dumbbell bench press", [Equipment.dumbbell]),
  Ex(EBase.benchPressDB, "15° dumbbell bench press", [Equipment.dumbbell]),
  Ex(EBase.chestPressCable, "cable chest press", [Equipment.cableTowerDual]),

  Ex(EBase.fly, "laying dumbbell fly", [Equipment.dumbbell]),
  Ex(EBase.fly, "chest fly machine", [Equipment.chestFlyMachine]),
  Ex(EBase.flyShoulderExt, "chest fly machine (thumbs up)",
      [Equipment.chestFlyMachine]),

  Ex(EBase.fly, "bayesian fly", [
    Equipment.cableTower
  ]), // TODO: what makes it bayesian? machine vs single vs dual cables? seated or standing? ROM?
  Ex(EBase.pecDeckElbowPad, "pec deck (elbow pad)", [Equipment.pecDeckMachine]),
  Ex(EBase.pecDeckHandGrip, "chest machine fly (pec deck with hand grip)",
      [Equipment.chestFlyMachine]),

  Ex(EBase.overheadPressDB, "dumbbell overhead press", [Equipment.dumbbell]),
  Ex(EBase.overheadPressBB, "barbell overhead press", [Equipment.barbell]),
  Ex(EBase.overheadPressBB, "shoulder press machine",
      [Equipment.shoulderPressMachine]),

  Ex(EBase.lateralRaise, "standing dumbbell lateral raise",
      [Equipment.dumbbell], [lateralRaiseShoulderRotation]),
  Ex(EBase.lateralRaise, "standing cable lateral raise", [Equipment.cableTower],
      [lateralRaiseShoulderRotation, lateralRaiseCablePath]),
  Ex(EBase.shrug, "barbell shrug", [Equipment.barbell]),
  Ex(EBase.shrug, "wide grip barbell shrug", [Equipment.barbell]),
  Ex(EBase.shrug, "dumbbell shrug", [Equipment.dumbbell]),

  Ex(EBase.tricepExtensionOverhead, "cable overhead tricep extension",
      [Equipment.cableTower]),
  Ex(EBase.tricepExtensionOverhead, "dumbbell overhead tricep extension",
      [Equipment.dumbbell]),
  Ex(EBase.tricepExtension, "dumbbell skull-over", [Equipment.dumbbell]),
  Ex(EBase.tricepExtension, "barbell skull-over", [Equipment.barbell]),
  Ex(EBase.tricepExtension, "elastic skull-over", [Equipment.elastic]),
  Ex(EBase.tricepExtension, "tricep kickback", [Equipment.dumbbell]),
  Ex(EBase.tricepExtension, "tricep cable pushdown", [Equipment.cableTower]),

  Ex(EBase.bicepCurl, "barbell bicep curl", [Equipment.barbell]),
  Ex(EBase.bicepCurl, "cable bicep curl", [Equipment.cableTower]),
  Ex(EBase.bicepCurl, "dumbbell bicep curl", [Equipment.dumbbell]),
  Ex(EBase.bicepCurl, "dumbbell hammer bicep curl", [Equipment.dumbbell]),
  Ex(EBase.bicepCurl, "kettlebell bicep curl", [Equipment.kettlebell]),
  Ex(EBase.bicepCurl, "preacher bicep curl machine",
      [Equipment.preacherCurlMachine]),
  Ex(EBase.bicepCurl, "preacher bicep curl bench/barbell",
      [Equipment.preacherCurlBench]),
  Ex(EBase.bicepCurl, "bicep curl machine", [Equipment.bicepCurlMachine]),
  Ex(EBase.bicepCurl, "bayesian curl", [Equipment.cableTower]),
  Ex(EBase.bicepCurl, "concentration curl", [Equipment.dumbbell]), // unilateral

  Ex(EBase.abCrunch, "ab crunch machine", [Equipment.abCrunchMachine]),
  Ex(EBase.abCrunch, "cable ab crunch", [Equipment.cableTower]),
  Ex(EBase.abCrunch, "laying ab crunch", []),
  Ex(EBase.abIsometric, "plank", []),
  Ex(EBase.wristFlexion, "dumbbell wrist curls", [Equipment.dumbbell]),
  Ex(EBase.wristExtension, "dumbbell wrist extensions", [Equipment.dumbbell]),
];

/// Returns a filtered list of exercises based on various criteria:
/// - Excludes exercises specified in [excludedExercises]
/// - Excludes exercises with base types in [excludedBases]
/// - If [availEquipment] is provided, only includes exercises that use available equipment
List<Ex> getAvailableExercises({
  Set<Ex>? excludedExercises,
  Set<EBase>? excludedBases,
  Set<Equipment>? availEquipment,
}) {
  return exes.where((e) {
    if (excludedExercises?.contains(e) ?? false) return false;
    if (excludedBases?.contains(e.base) ?? false) return false;
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
