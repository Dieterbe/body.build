import 'package:ptc/data/programmer/groups.dart';

// Exercise Base
// built-in: doesn't need to be persisted
enum EBase {
  goodMorning,
  deadlift,
  deadliftRDL, // romanian
  backExtension,
  hipExtension,
  pullThrough,
  legCurl,
  squatBB,
  squatGoblet,
  squatHack,
  squatBelt,
  squatBSQ, // bulgarian split squat
  legPress,
  lunge,
  stepUp,
  squatPistol,
  squatSissy,
  squatSissyAssisted,
  squatSpanish,
  legExtension,
  reverseNordicHamCurl,
  hipThrust,
  gluteKickback,
  hipAbductionHipFlexed,
  hipAbductionHipExtended,
  standingCalfRaise,
  seatedCalfRaise,
  calfJump,
  pullup,
  pullupNeutral,
  pullupSupinated,
  pullupWidePronated,
  pulldown,
  pulldownNeutral,
  pulldownSupinated,
  pulldownWidePronated,
  diagonalRow,
  cableRowWithForwardLean,
  bentOverRow,
  pullOver,
  latPrayer,
  highRow,
  rearDeltFly,
  rearDeltRaise,
  shoulderPull,
  facePull,
  benchPressBB,
  chestPressMachine,
  pushUp,
  benchPressDB,
  chestPressCable,
  fly,
  pecDeckHandGrip,
  pecDeckElbowPad,
  overheadPressBB,
  overheadPressDB,
  lateralRaise,
  shrug,
  tricepExtension,
  bicepCurl,
  abCrunch,
  abIsometric,
  wristFlexion,
  wristExtension,
}

enum EquipmentCategory {
  basics("Basic Equipment"),
  generalMachines("General Machines"),
  upperBodyMachines("Upper Body Machines"),
  coreAndGluteMachines("Core and Glute Machines"),
  lowerBodyMachines("Lower Body Machines");

  final String displayName;
  const EquipmentCategory(this.displayName);
}

// built-in: doesn't need to be persisted
// TODO: go over exercises and make sure all equipment is used
enum Equipment {
  // Basics
  barbell("Barbell", EquipmentCategory.basics),
  dumbbell("Dumbbells", EquipmentCategory.basics),
  kettlebell("Kettlebells", EquipmentCategory.basics),
  trx("TRX (or similar)", EquipmentCategory.basics),
  gymnasticRings("Gymnastic Rings", EquipmentCategory.basics),
  elastic("Resistance bands", EquipmentCategory.basics),

  // General machines
  smithMachineAngled("Smith Machine angled", EquipmentCategory.generalMachines),
  smithMachineVertical(
      "Smith Machine vertical", EquipmentCategory.generalMachines),
  cableTower("Cable Tower", EquipmentCategory.generalMachines),
  cableTowerDual("Dual Cable Tower", EquipmentCategory.generalMachines),

  // Upper body machines
  shoulderPressMachine(
      "Shoulder Press Machine", EquipmentCategory.upperBodyMachines),
  chestPressMachine("Chest Press Machine", EquipmentCategory.upperBodyMachines),
  pecDeckMachine("Pec Deck (elbow pad)", EquipmentCategory.upperBodyMachines),
  chestFlyMachine(
      "Chest Fly Machine (hand grips)", EquipmentCategory.upperBodyMachines),
  rearDeltFlyMachine(
      "Rear Delt Fly Machine", EquipmentCategory.upperBodyMachines),
  latPullDownMachine(
      "Lat Pulldown Machine", EquipmentCategory.upperBodyMachines),
  cableRowMachine("Cable Row Machine", EquipmentCategory.upperBodyMachines),
  preacherCurlMachine(
      "Preacher Curl Machine", EquipmentCategory.upperBodyMachines),
  bicepsCurlMachine("Biceps Curl Machine", EquipmentCategory.upperBodyMachines),

  // Core and glute machines
  abCrunchMachine("Ab Crunch Machine", EquipmentCategory.coreAndGluteMachines),
  hyper45("45° Back Extension", EquipmentCategory.coreAndGluteMachines),
  hyper90("90° Back Extension", EquipmentCategory.coreAndGluteMachines),
  hyperReverse("Reverse Hyper", EquipmentCategory.coreAndGluteMachines),
  hipThrustMachine(
      "Hip Thrust Machine", EquipmentCategory.coreAndGluteMachines),
  gluteKickbackMachine(
      "Glute Kickback Machine", EquipmentCategory.coreAndGluteMachines),
  pendulumGluteKickback(
      "Pendulum Kickback", EquipmentCategory.coreAndGluteMachines),
  hipAdductionAbductionMachine(
      "Hip (Add/Abd)uction Machine", EquipmentCategory.coreAndGluteMachines),

  // Lower body machines

  beltSquatMachine("Belt Squat Machine", EquipmentCategory.lowerBodyMachines),
  hackSquatMachine("Hack Squat Machine", EquipmentCategory.lowerBodyMachines),
  squatRack("Squat rack/cage", EquipmentCategory.lowerBodyMachines),
  hamCurlMachineLying(
      "Lying Leg Curl Machine", EquipmentCategory.lowerBodyMachines),
  hamCurlMachineSeated(
      "Seated Leg Curl Machine", EquipmentCategory.lowerBodyMachines),
  hamCurlMachineStanding(
      "Standing Leg Curl Machine", EquipmentCategory.lowerBodyMachines),
  legExtensionMachine(
      "Leg Extension Machine", EquipmentCategory.lowerBodyMachines),
  legPressMachine("Leg Press Machine", EquipmentCategory.lowerBodyMachines),
  calfRaiseMachineSeated(
      "Seated Calf Raise Machine", EquipmentCategory.lowerBodyMachines),
  calfRaiseMachineStanding(
      "Standing Calf Raise Machine", EquipmentCategory.lowerBodyMachines);

  final String displayName;
  final EquipmentCategory category;
  const Equipment(this.displayName, this.category);
}

/*
others that menno asks about:
a glute-ham raise?
a dip/chin-up belt?
a pair of knee wraps? 
powerlifting bands (not the light home workout stuff)?
powerlifting chains?



*/

// our own exercise class
// which allows to list exercises, categorized by base (so it can be matched)
// and wraps kaos.Exercise (when available) for more information,
// although not all information is used
// base is already a quite specific movement
// but the ex is an exact, specific, detailed exercise
// though i'm not sure if i want to keep execution details (e.g. unilateral)
// as separate exercises, those should perhaps be "modifiers"
// this class is built-in, and doesn't need to be persisted
class Ex {
  EBase base;
  List<Equipment> equipment;
  String
      id; // identifier to match to kaos exercise. does not need to be human friendly
  // TODO: in fact, should be super specific here? to account for future additions of other
  // variations? e.g. add "barbell" even when that is obvious
  //Exercise? exercise;
  late VolumeAssignment va;

  Ex(this.base, this.id, this.equipment) {
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

  double recruitment(ProgramGroup pg) {
    // first see if there's an equipment specific rule that describes our pg.
    for (final entry in va.assignEquip.entries) {
      if (equipment.contains(entry.key) && entry.value.containsKey(pg)) {
        return entry.value[pg]!;
      }
    }
    // if not, let's see if we have a general rule
    return va.assign[pg] ?? 0.0;
  }

  double recruitmentFiltered(ProgramGroup pg, double cutoff) {
    final raw = recruitment(pg);
    return raw >= cutoff ? raw : 0.0;
  }

  double totalRecruitment() =>
      ProgramGroup.values.fold(0.0, (sum, group) => sum + recruitment(group));

  double totalRecruitmentFiltered(double cutoff) => ProgramGroup.values
      .fold(0.0, (sum, group) => sum + recruitmentFiltered(group, cutoff));
}

// TODO add pullup negatives. this is not eccentric overloads (those still have concentric)
// form modifiers like unilateral concentrics, unilateral
// important: id's should not change! perhaps we should introduce seperate human friendly naming
final List<Ex> exes = [
  Ex(EBase.goodMorning, "standing good morning", [Equipment.barbell]),
  Ex(EBase.goodMorning, "seated good morning", [Equipment.barbell]),
  Ex(EBase.deadlift, "deadlift (powerlift)", [Equipment.barbell]),
  Ex(EBase.deadlift, "deadlift", [Equipment.barbell]),
  Ex(EBase.deadliftRDL, "romanian deadlift", [Equipment.barbell]),
  Ex(EBase.backExtension, "45° back extension", [Equipment.hyper45]),
  Ex(EBase.hipExtension, "45° hip extension", [Equipment.hyper45]),
  Ex(EBase.hipExtension, "90° hip extension", [Equipment.hyper90]),
  Ex(EBase.hipExtension, "reverse hyperextension", [Equipment.hyperReverse]),
  Ex(EBase.pullThrough, "cable pull-through", [Equipment.cableTower]),
  Ex(EBase.legCurl, "seated leg curl machine",
      [Equipment.hamCurlMachineSeated]),
  Ex(EBase.legCurl, "standing unilateral leg curl machine",
      [Equipment.hamCurlMachineStanding]),
  Ex(EBase.legCurl, "lying leg curl", [Equipment.hamCurlMachineLying]),
  Ex(EBase.squatBB, "high bar back squat", [Equipment.squatRack]),
  Ex(EBase.squatBB, "low bar back squat", [Equipment.squatRack]),
  Ex(EBase.squatBB, "front squat", [Equipment.squatRack]),
  Ex(EBase.squatGoblet, "goblet squat", []),
  Ex(EBase.squatHack, "machine hack squat", [Equipment.hackSquatMachine]),
  Ex(EBase.squatBelt, "belt squat", [Equipment.beltSquatMachine]),
  Ex(EBase.squatBSQ, "dumbbell bulgarian split squat", [Equipment.dumbbell]),
  Ex(EBase.squatBSQ, "barbell bulgarian split squat", [Equipment.barbell]),
  Ex(EBase.squatBSQ, "smith machine bulgarian split squat",
      [Equipment.smithMachineVertical]),
  Ex(EBase.squatBSQ, "dumbbell bulgarian split squat from deficit",
      [Equipment.dumbbell]),
  Ex(EBase.squatBSQ, "barbell bulgarian split squat from deficit",
      [Equipment.barbell]),
  Ex(EBase.squatBSQ, "smith machine bulgarian split squat from deficit",
      [Equipment.smithMachineVertical]),
  Ex(EBase.legPress, "machine leg press", [Equipment.legPressMachine]),
  Ex(EBase.lunge, "forward lunge", []),
  Ex(EBase.lunge, "backward lunge", []),
  Ex(EBase.lunge, "backward deficit lunge", []),
  Ex(EBase.lunge, "forward deficit lunge", []),
  Ex(EBase.lunge, "walking lunge", []),
  Ex(EBase.lunge, "dumbbell forward lunge", [Equipment.dumbbell]),
  Ex(EBase.lunge, "dumbbell backward lunge", [Equipment.dumbbell]),
  Ex(EBase.lunge, "dumbbell backward deficit lunge", [Equipment.dumbbell]),
  Ex(EBase.lunge, "dumbbell forward deficit lunge", [Equipment.dumbbell]),
  Ex(EBase.lunge, "dumbbell walking lunge", [Equipment.dumbbell]),
  Ex(EBase.stepUp, "step up", []),
  Ex(EBase.squatPistol, "pistol squat", []),
  Ex(EBase.squatSissyAssisted, "assisted sissy squat", []),
  Ex(EBase.squatSpanish, "spanish squat", [Equipment.elastic]),
  Ex(EBase.legExtension, "seated leg extension machine",
      [Equipment.legExtensionMachine]),
  Ex(EBase.reverseNordicHamCurl, "reverse nordic ham curl", []),
  Ex(EBase.squatSissy, "sissy squat", []),
  Ex(EBase.hipThrust, "barbell hip thrust", [Equipment.barbell]),
  Ex(EBase.hipThrust, "smith machine hip thrust",
      [Equipment.smithMachineVertical]),
  Ex(EBase.hipThrust, "machine hip thrust", [Equipment.hipThrustMachine]),
  Ex(EBase.gluteKickback, "glute kickback machine",
      [Equipment.gluteKickbackMachine]),
  Ex(EBase.gluteKickback, "pendulum glute kickback",
      [Equipment.pendulumGluteKickback]),
  Ex(EBase.hipAbductionHipFlexed, "seated hip abduction machine",
      [Equipment.hipAdductionAbductionMachine]),
  Ex(EBase.hipAbductionHipExtended, "standing cable hip abduction",
      [Equipment.cableTower]),
  Ex(EBase.standingCalfRaise, "smith machine standing calf raise",
      [Equipment.smithMachineVertical]),
  Ex(EBase.standingCalfRaise, "smith machine standing calf raise (unilateral)",
      [Equipment.smithMachineVertical]),
  Ex(EBase.calfJump, "bodyweight calf jumps", []),
  Ex(EBase.calfJump, "dumbbell calf jumps", [Equipment.dumbbell]),
  Ex(EBase.seatedCalfRaise, "seated calf raise machine",
      [Equipment.calfRaiseMachineSeated]),
  Ex(EBase.pullup, "pullup", []),
  Ex(EBase.pullupNeutral, "pullup neutral grip", []),
  Ex(EBase.pullupSupinated, "pullup supinated grip", []),
  Ex(EBase.pullupWidePronated, "pullup wide pronated grip", []),
  Ex(EBase.pulldown, "lat pulldown", [Equipment.latPullDownMachine]),
  Ex(EBase.pulldownNeutral, "lat pulldown neutral grip",
      [Equipment.latPullDownMachine]),
  Ex(EBase.pulldownSupinated, "lat pulldown supinated grip",
      [Equipment.latPullDownMachine]),
  Ex(EBase.pulldownWidePronated, "lat pulldown wide pronated grip",
      [Equipment.latPullDownMachine]),
  Ex(EBase.diagonalRow, "kneeling diagonal cable row", [Equipment.cableTower]),
  Ex(EBase.cableRowWithForwardLean, "seated cable row with forward lean",
      [Equipment.cableRowMachine]),
  Ex(EBase.bentOverRow, "standing bent over barbell row", [Equipment.barbell]),
  Ex(EBase.pullOver, "pull over", [Equipment.cableTower]),
  Ex(EBase.latPrayer, "lat prayer", [Equipment.cableTower]),
  Ex(EBase.highRow, "seated cable high row", [Equipment.cableRowMachine]),
  Ex(EBase.rearDeltFly, "rear delt fly machine",
      [Equipment.rearDeltFlyMachine]),
  Ex(EBase.rearDeltRaise, "side lying rear delt dumbbell raise",
      [Equipment.dumbbell]),
  Ex(EBase.shoulderPull, "standing cable shoulder pull",
      [Equipment.cableTower]),
  Ex(EBase.shoulderPull, "seated cable shoulder pull", [Equipment.cableTower]),
  Ex(EBase.facePull, "standing cable face pull", [Equipment.cableTower]),
  Ex(EBase.facePull, "seated cable face pull", [Equipment.cableTower]),
  Ex(EBase.facePull, "TRX face pull", [Equipment.trx]),
  Ex(EBase.benchPressBB, "flat barbell bench press", [Equipment.barbell]),
  Ex(EBase.benchPressBB, "15° barbell bench press", [Equipment.barbell]),
  // TODO add smitch machine bench press
  Ex(EBase.chestPressMachine, "chest press machine",
      [Equipment.chestPressMachine]),
  Ex(EBase.pushUp, "push-up", []),
  Ex(EBase.benchPressDB, "flat dumbbell bench press", [Equipment.dumbbell]),
  Ex(EBase.benchPressDB, "15° dumbbell bench press", [Equipment.dumbbell]),
  Ex(EBase.chestPressCable, "cable chest press", [Equipment.cableTower]),
  Ex(EBase.fly, "laying dumbbell fly", [Equipment.dumbbell]),
  Ex(EBase.fly, "chest fly machine", [Equipment.chestFlyMachine]),
  Ex(EBase.fly, "bayesian fly", [Equipment.cableTower]),
  Ex(EBase.pecDeckElbowPad, "pec deck (elbow pad)", [Equipment.pecDeckMachine]),
  Ex(EBase.pecDeckHandGrip, "chest machine fly (pec deck withhand grip)",
      [Equipment.chestFlyMachine]),
  Ex(EBase.overheadPressDB, "dumbbell overhead press", [Equipment.dumbbell]),
  Ex(EBase.overheadPressBB, "barbell overhead press", [Equipment.barbell]),
  Ex(EBase.lateralRaise, "standing dumbbell lateral raise",
      [Equipment.dumbbell]),
  Ex(EBase.lateralRaise, "standing cable lateral raise",
      [Equipment.cableTower]),
  Ex(EBase.tricepExtension, "cable overhead tricep extension",
      [Equipment.cableTower]),
  Ex(EBase.tricepExtension, "dumbbell overhead tricep extension",
      [Equipment.dumbbell]),
  Ex(EBase.tricepExtension, "dumbbell skull-over", [Equipment.dumbbell]),
  Ex(EBase.tricepExtension, "barbell skull-over", [Equipment.barbell]),
  Ex(EBase.tricepExtension, "elastic skull-over", [Equipment.elastic]),
  Ex(EBase.tricepExtension, "tricep kickback", [Equipment.dumbbell]),
  Ex(EBase.tricepExtension, "tricep cable pushdown", [Equipment.cableTower]),
  Ex(EBase.shrug, "barbell shrug", [Equipment.barbell]),
  Ex(EBase.shrug, "dumbbell shrug", [Equipment.dumbbell]),
  Ex(EBase.shrug, "wide grip barbell shrug", [Equipment.barbell]),
  Ex(EBase.bicepCurl, "barbell bicep curl", [Equipment.barbell]),
  Ex(EBase.bicepCurl, "cable bicep curl", [Equipment.cableTower]),
  Ex(EBase.bicepCurl, "dumbbell bicep curl", [Equipment.dumbbell]),
  Ex(EBase.bicepCurl, "dumbbell hammer bicep curl", [Equipment.dumbbell]),
  Ex(EBase.bicepCurl, "kettlebell bicep curl", [Equipment.kettlebell]),
  Ex(EBase.bicepCurl, "preacher bicep curl", [Equipment.barbell]),
  Ex(EBase.bicepCurl, "bayesian curl", [Equipment.cableTower]),
  Ex(EBase.bicepCurl, "concentration curl", [Equipment.dumbbell]),
  Ex(EBase.abCrunch, "ab crunch machine", [Equipment.abCrunchMachine]),
  Ex(EBase.abCrunch, "cable ab crunch", [Equipment.cableTower]),
  Ex(EBase.abCrunch, "laying ab crunch", []),
  Ex(EBase.abIsometric, "plank", []),
  Ex(EBase.wristFlexion, "dumbbell wrist curls", [Equipment.dumbbell]),
  Ex(EBase.wristExtension, "dumbbell wrist extensions", [Equipment.cableTower]),
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