import 'package:flutter/material.dart';
import 'package:kaos/model/exercise.dart';
import "package:flutter/services.dart" as s;
import 'dart:convert';
import 'package:kaos/model/category.dart';
import 'package:kaos/model/exercise_list.dart';

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
  pullupWidePronated, // TODO unused in vol assignment
  pulldown,
  pulldownNeutral,
  pulldownSupinated, // TODO unused in vol assignment
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
  pecDeck,
  overheadPressBB,
  overheadPressDB,
  lateralRaise,
  shrug,
  tricepExtension,
  bicepCurl,
  abCrunch,
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
  String
      id; // identifier to match to kaos exercise. does not need to be human friendly
  // TODO: in fact, should be super specific here? to account for future additions of other
  // variations? e.g. add "barbell" even when that is obvious
  Exercise? exercise;

  Ex(this.base, this.id, {this.exercise});
}

final List<Ex> exes = [
  Ex(EBase.goodMorning, "standing good morning"),
  Ex(EBase.goodMorning, "seated good morning"),
  Ex(EBase.deadlift, "deadlift (powerlift)"),
  Ex(EBase.deadlift, "deadlift"),
  Ex(EBase.deadliftRDL, "romanian deadlift"),
  Ex(EBase.backExtension, "45 degree back extension"),
  Ex(EBase.hipExtension, "45 degree hip extension"),
  Ex(EBase.hipExtension, "90 degree hip extension"),
  Ex(EBase.hipExtension, "reverse hyperextension"),
  Ex(EBase.pullThrough, "cable pull-through"),
  Ex(EBase.legCurl, "seated leg curl machine"),
  Ex(EBase.legCurl, "standing unilateral leg curl machine"),
  Ex(EBase.legCurl, "laying leg curl"),
  Ex(EBase.squatBB, "high bar back squat"),
  Ex(EBase.squatBB, "low bar back squat"),
  Ex(EBase.squatBB, "front squat"),
  Ex(EBase.squatGoblet, "goblet squat"),
  Ex(EBase.squatHack, "machine hack squat"),
  Ex(EBase.squatBelt, "belt squat"),
  Ex(EBase.squatBSQ, "dumbbell bulgarian split squat"),
  Ex(EBase.squatBSQ, "smith machine bulgarian split squat"),
  Ex(EBase.legPress, "machine leg press"),
  Ex(EBase.lunge,
      "forward lunge"), // could add "dumbell", but then which hand(s)? etc
  Ex(EBase.lunge, "backward lunge"),
  Ex(EBase.lunge, "backward deficit lunge"),
  Ex(EBase.lunge, "forward deficit lunge"),
  Ex(EBase.lunge, "walking lunge"),
  Ex(EBase.stepUp, "step up"),
  Ex(EBase.squatPistol, "pistol squat"),
  Ex(EBase.squatSissyAssisted, "assisted sissy squat"),
  Ex(EBase.squatSpanish, "spanish squat"),
  Ex(EBase.legExtension, "seated leg extension machine"),
  Ex(EBase.reverseNordicHamCurl, "reverse nordic ham curl"),
  Ex(EBase.squatSissy, "sissy squat"),
  Ex(EBase.hipThrust, "barbell hip thrust"),
  Ex(EBase.hipThrust, "smith machine hip thrust"),
  Ex(EBase.hipThrust, "machine hip thrust"),
  Ex(EBase.gluteKickback, "glute kickback machine"),
  Ex(EBase.gluteKickback, "pendulum glute kickback"),
  Ex(EBase.hipAbductionHipFlexed, "seated hip abduction machine"),
  Ex(EBase.hipAbductionHipExtended, "standing cable hip abduction"),
  Ex(EBase.standingCalfRaise, "smith machine standing calf raise"),
  Ex(EBase.standingCalfRaise, "smith machine standing calf raise (unilateral)"),
  Ex(EBase.calfJump, "calf jumps"),
  Ex(EBase.seatedCalfRaise, "seated calf raise machine"),
  Ex(EBase.pullup, "pullup"),
  Ex(EBase.pullupNeutral, "pullup neutral grip"),
  Ex(EBase.pullupSupinated, "pullup supinated grip"),
  Ex(EBase.pullupWidePronated, "pullup wide pronated grip"),
  Ex(EBase.pulldown, "lat pulldown"),
  Ex(EBase.pulldownNeutral, "lat pulldown neutral grip"),
  Ex(EBase.pulldownSupinated, "lat pulldown supinated grip"),
  Ex(EBase.pulldownWidePronated, "lat pulldown wide pronated grip"),
  Ex(EBase.diagonalRow, "kneeling diagonal cable row"),
  Ex(EBase.cableRowWithForwardLean, "seated cable row with forward lean"),
  Ex(EBase.bentOverRow, "standing bent over barbell row"),
  Ex(EBase.pullOver, "pull over"),
  Ex(EBase.latPrayer, "lat prayer"),
  Ex(EBase.highRow, "seated cable high row"),
  Ex(EBase.rearDeltFly, "rear delt fly machine"),
  Ex(EBase.rearDeltRaise, "side lying rear delt dumbbell raise"),
  Ex(EBase.shoulderPull, "standing cable shoulder pull"),
  Ex(EBase.shoulderPull, "seated cable shoulder pull"),
  Ex(EBase.facePull, "standing face pull"),
  Ex(EBase.facePull, "seated face pull"),
  Ex(EBase.benchPressBB, "flat barbell bench press"),
  Ex(EBase.benchPressBB, "15 degree barbell bench press"),
  Ex(EBase.chestPressMachine, "chest press machine"),
  Ex(EBase.pushUp, "push-up"),
  Ex(EBase.benchPressDB, "flat dumbbell bench press"),
  Ex(EBase.benchPressDB, "15 degree dumbbell bench press"),
  Ex(EBase.chestPressCable, "cable chest press"),
  Ex(EBase.fly, "laying dumbbell fly"),
  Ex(EBase.fly, "chest fly machine"),
  Ex(EBase.fly, "bayesian fly"),
  Ex(EBase.pecDeck, "pec deck"),
  Ex(EBase.overheadPressDB, "dumbbell overhead press"),
  Ex(EBase.overheadPressBB, "barbell overhead press"),
  Ex(EBase.lateralRaise, "standing dumbbell lateral raise"),
  Ex(EBase.lateralRaise, "standing cable lateral raise"),
  Ex(EBase.tricepExtension, "overhead tricep extension"),
  Ex(EBase.tricepExtension, "skull-over"),
  Ex(EBase.tricepExtension, "tricep kickback"),
  Ex(EBase.tricepExtension, "tricep cable pushdown"),
  Ex(EBase.shrug, "barbell shrug"),
  Ex(EBase.shrug, "dumbbell shrug"),
  Ex(EBase.shrug, "wide grip barbell shrug"),
  Ex(EBase.bicepCurl, "barbell bicep curl"),
  Ex(EBase.bicepCurl, "cable bicep curl"),
  Ex(EBase.bicepCurl, "dumbbell bicep curl"),
  Ex(EBase.bicepCurl, "dumbbell hammer bicep curl"),
  Ex(EBase.bicepCurl, "kettlebell bicep curl"),
  Ex(EBase.bicepCurl, "preacher bicep curl"),
  Ex(EBase.bicepCurl, "bayesian curl"),
  Ex(EBase.bicepCurl, "concentration curl"),
  Ex(EBase.abCrunch, "ab crunch machine"),
  Ex(EBase.abCrunch, "cable ab crunch"),
  Ex(EBase.abCrunch, "ab crunch machine"),
  Ex(EBase.abCrunch, "laying ab crunch"),
];

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
