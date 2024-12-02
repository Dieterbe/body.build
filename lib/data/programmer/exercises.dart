import 'package:ptc/data/programmer/groups.dart';

// Exercise Base
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

enum Equipment {
  barbell,
  dumbbell,
  kettlebell,
  cable,
  smithMachine,
  machine,
  trx,
  squatRack, // assumes barbell also
  elastic,
}

// our own exercise class
// which allows to list exercises, categorized by base (so it can be matched)
// and wraps kaos.Exercise (when available) for more information,
// although not all information is used
// base is already a quite specific movement
// but the ex is an exact, specific, detailed exercise
// though i'm not sure if i want to keep execution details (e.g. unilateral)
// as separate exercises, those should perhaps be "modifiers"
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

final List<Ex> exes = [
  Ex(EBase.goodMorning, "standing good morning", [Equipment.barbell]),
  Ex(EBase.goodMorning, "seated good morning", [Equipment.barbell]),
  Ex(EBase.deadlift, "deadlift (powerlift)", [Equipment.barbell]),
  Ex(EBase.deadlift, "deadlift", [Equipment.barbell]),
  Ex(EBase.deadliftRDL, "romanian deadlift", [Equipment.barbell]),
  Ex(EBase.backExtension, "45 degree back extension", [Equipment.machine]),
  Ex(EBase.hipExtension, "45 degree hip extension", [Equipment.machine]),
  Ex(EBase.hipExtension, "90 degree hip extension", [Equipment.machine]),
  Ex(EBase.hipExtension, "reverse hyperextension", [Equipment.machine]),
  Ex(EBase.pullThrough, "cable pull-through", [Equipment.cable]),
  Ex(EBase.legCurl, "seated leg curl machine", [Equipment.machine]),
  Ex(EBase.legCurl, "standing unilateral leg curl machine",
      [Equipment.machine]),
  Ex(EBase.legCurl, "laying leg curl", [Equipment.machine]),
  Ex(EBase.squatBB, "high bar back squat", [Equipment.squatRack]),
  Ex(EBase.squatBB, "low bar back squat", [Equipment.squatRack]),
  Ex(EBase.squatBB, "front squat", [Equipment.squatRack]),
  Ex(EBase.squatGoblet, "goblet squat", []),
  Ex(EBase.squatHack, "machine hack squat", [Equipment.machine]),
  Ex(EBase.squatBelt, "belt squat", [Equipment.machine]),
  Ex(EBase.squatBSQ, "dumbbell bulgarian split squat", [Equipment.dumbbell]),
  Ex(EBase.squatBSQ, "barbell bulgarian split squat", [Equipment.barbell]),
  Ex(EBase.squatBSQ, "smith machine bulgarian split squat",
      [Equipment.smithMachine]),
  Ex(EBase.squatBSQ, "dumbbell bulgarian split squat from deficit",
      [Equipment.dumbbell]),
  Ex(EBase.squatBSQ, "barbell bulgarian split squat from deficit",
      [Equipment.barbell]),
  Ex(EBase.squatBSQ, "smith machine bulgarian split squat from deficit",
      [Equipment.smithMachine]),
  Ex(EBase.legPress, "machine leg press", [Equipment.machine]),
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
  Ex(EBase.legExtension, "seated leg extension machine", [Equipment.machine]),
  Ex(EBase.reverseNordicHamCurl, "reverse nordic ham curl",
      [Equipment.machine]),
  Ex(EBase.squatSissy, "sissy squat", []),
  Ex(EBase.hipThrust, "barbell hip thrust", [Equipment.barbell]),
  Ex(EBase.hipThrust, "smith machine hip thrust", [Equipment.smithMachine]),
  Ex(EBase.hipThrust, "machine hip thrust", [Equipment.machine]),
  Ex(EBase.gluteKickback, "glute kickback machine", [Equipment.machine]),
  Ex(EBase.gluteKickback, "pendulum glute kickback", [Equipment.machine]),
  Ex(EBase.hipAbductionHipFlexed, "seated hip abduction machine",
      [Equipment.machine]),
  Ex(EBase.hipAbductionHipExtended, "standing cable hip abduction",
      [Equipment.cable]),
  Ex(EBase.standingCalfRaise, "smith machine standing calf raise",
      [Equipment.smithMachine]),
  Ex(EBase.standingCalfRaise, "smith machine standing calf raise (unilateral)",
      [Equipment.smithMachine]),
  Ex(EBase.calfJump, "bodyweight calf jumps", []),
  Ex(EBase.calfJump, "dumbbell calf jumps", [Equipment.dumbbell]),
  Ex(EBase.seatedCalfRaise, "seated calf raise machine", [Equipment.machine]),
  Ex(EBase.pullup, "pullup", []),
  Ex(EBase.pullupNeutral, "pullup neutral grip", []),
  Ex(EBase.pullupSupinated, "pullup supinated grip", []),
  Ex(EBase.pullupWidePronated, "pullup wide pronated grip", []),
  Ex(EBase.pulldown, "lat pulldown", [Equipment.machine]),
  Ex(EBase.pulldownNeutral, "lat pulldown neutral grip", [Equipment.machine]),
  Ex(EBase.pulldownSupinated, "lat pulldown supinated grip",
      [Equipment.machine]),
  Ex(EBase.pulldownWidePronated, "lat pulldown wide pronated grip",
      [Equipment.machine]),
  Ex(EBase.diagonalRow, "kneeling diagonal cable row", [Equipment.cable]),
  Ex(EBase.cableRowWithForwardLean, "seated cable row with forward lean",
      [Equipment.machine]),
  Ex(EBase.bentOverRow, "standing bent over barbell row", [Equipment.barbell]),
  Ex(EBase.pullOver, "pull over", [Equipment.cable]),
  Ex(EBase.latPrayer, "lat prayer", [Equipment.cable]),
  Ex(EBase.highRow, "seated cable high row", [Equipment.machine]),
  Ex(EBase.rearDeltFly, "rear delt fly machine", [Equipment.machine]),
  Ex(EBase.rearDeltRaise, "side lying rear delt dumbbell raise",
      [Equipment.dumbbell]),
  Ex(EBase.shoulderPull, "standing cable shoulder pull", [Equipment.cable]),
  Ex(EBase.shoulderPull, "seated cable shoulder pull", [Equipment.cable]),
  Ex(EBase.facePull, "standing cable face pull", [Equipment.cable]),
  Ex(EBase.facePull, "seated cable face pull", [Equipment.cable]),
  Ex(EBase.facePull, "TRX face pull", [Equipment.trx]),
  Ex(EBase.benchPressBB, "flat barbell bench press", [Equipment.barbell]),
  Ex(EBase.benchPressBB, "15 degree barbell bench press", [Equipment.barbell]),
  // TODO add smitch machine bench press
  Ex(EBase.chestPressMachine, "chest press machine", [Equipment.machine]),
  Ex(EBase.pushUp, "push-up", []),
  Ex(EBase.benchPressDB, "flat dumbbell bench press", [Equipment.dumbbell]),
  Ex(EBase.benchPressDB, "15 degree dumbbell bench press",
      [Equipment.dumbbell]),
  Ex(EBase.chestPressCable, "cable chest press", [Equipment.cable]),
  Ex(EBase.fly, "laying dumbbell fly", [Equipment.dumbbell]),
  Ex(EBase.fly, "chest fly machine", [Equipment.machine]),
  Ex(EBase.fly, "bayesian fly", [Equipment.cable]),
  Ex(EBase.pecDeckElbowPad, "pec deck (elbow pad)", [Equipment.machine]),
  Ex(EBase.pecDeckHandGrip, "pec deck (hand grip)", [Equipment.machine]),
  Ex(EBase.overheadPressDB, "dumbbell overhead press", [Equipment.dumbbell]),
  Ex(EBase.overheadPressBB, "barbell overhead press", [Equipment.barbell]),
  Ex(EBase.lateralRaise, "standing dumbbell lateral raise",
      [Equipment.dumbbell]),
  Ex(EBase.lateralRaise, "standing cable lateral raise", [Equipment.cable]),
  Ex(EBase.tricepExtension, "cable overhead tricep extension",
      [Equipment.cable]),
  Ex(EBase.tricepExtension, "dumbbell overhead tricep extension",
      [Equipment.dumbbell]),
  Ex(EBase.tricepExtension, "dumbbell skull-over", [Equipment.dumbbell]),
  Ex(EBase.tricepExtension, "barbell skull-over", [Equipment.barbell]),
  Ex(EBase.tricepExtension, "elastic skull-over", [Equipment.elastic]),
  Ex(EBase.tricepExtension, "tricep kickback", [Equipment.dumbbell]),
  Ex(EBase.tricepExtension, "tricep cable pushdown", [Equipment.cable]),
  Ex(EBase.shrug, "barbell shrug", [Equipment.barbell]),
  Ex(EBase.shrug, "dumbbell shrug", [Equipment.dumbbell]),
  Ex(EBase.shrug, "wide grip barbell shrug", [Equipment.barbell]),
  Ex(EBase.bicepCurl, "barbell bicep curl", [Equipment.barbell]),
  Ex(EBase.bicepCurl, "cable bicep curl", [Equipment.cable]),
  Ex(EBase.bicepCurl, "dumbbell bicep curl", [Equipment.dumbbell]),
  Ex(EBase.bicepCurl, "dumbbell hammer bicep curl", [Equipment.dumbbell]),
  Ex(EBase.bicepCurl, "kettlebell bicep curl", [Equipment.kettlebell]),
  Ex(EBase.bicepCurl, "preacher bicep curl", [Equipment.barbell]),
  Ex(EBase.bicepCurl, "bayesian curl", [Equipment.cable]),
  Ex(EBase.bicepCurl, "concentration curl", [Equipment.dumbbell]),
  Ex(EBase.abCrunch, "ab crunch machine", [Equipment.machine]),
  Ex(EBase.abCrunch, "cable ab crunch", [Equipment.cable]),
  Ex(EBase.abCrunch, "laying ab crunch", []),
  Ex(EBase.abIsometric, "plank", []),
  Ex(EBase.wristFlexion, "dumbbell wrist curls", [Equipment.dumbbell]),
  Ex(EBase.wristExtension, "dumbbell wrist extensions", [Equipment.cable]),
];

/// Returns a filtered list of exercises, excluding any exercises specified in [excludedExercises].
/// If [excludedExercises] is null or empty, returns all exercises.
List<Ex> getAvailableExercises({
  List<Ex>? excludedExercises,
  List<EBase>? excludedBases,
}) {
  var available = exes.toList();

  // Filter out individually excluded exercises
  if (excludedExercises != null && excludedExercises.isNotEmpty) {
    available = available.where((e) => !excludedExercises.contains(e)).toList();
  }

  // Filter out exercises with excluded base types
  if (excludedBases != null && excludedBases.isNotEmpty) {
    available =
        available.where((e) => !excludedBases.contains(e.base)).toList();
  }

  return available;
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