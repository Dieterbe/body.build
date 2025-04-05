import 'package:bodybuild/data/programmer/cues.dart';
import 'package:bodybuild/data/programmer/equipment.dart';
import 'package:bodybuild/data/programmer/groups.dart';
import 'package:bodybuild/data/programmer/modifier.dart';
import 'package:bodybuild/data/programmer/rating_jn.dart';
import 'package:bodybuild/data/programmer/volume_assignment.dart';

import 'rating.dart';

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
  final List<Rating> ratings;
  final String
      id; // identifier to match to kaos exercise. does not need to be human friendly

  const Ex(this.volumeAssignment, this.id, this.equipment,
      [this.modifiers = const [],
      this.cues = defaultCues,
      this.ratings = const []]);

  Assign recruitment(ProgramGroup pg, Map<String, String?> modifierOptions) {
    // establish base recruitment:
    var r = volumeAssignment[pg] ?? const Assign(0);

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

/*
The exercises are grouped by their "category". this isn't an exact science, since several exercises work multiple muscle (groups), in these cases
we try to add the exercise to the group which represent the larger muscles (e.g. pull-ups go in back exercises, not biceps)
This categorization is only meant to make code navigation easier here and elsewhere (e.g. ratings files), it's not a concept within the app.
*/
final List<Ex> exes = [
  const Ex(vaGoodMorning, "standing barbell good morning", [Equipment.barbell],
      [], handSqueeze),
  const Ex(vaGoodMorning, "standing dumbbell good morning",
      [Equipment.dumbbell], [], handSqueeze),
  const Ex(vaGoodMorning, "seated barbell good morning", [Equipment.barbell],
      [], handSqueeze),
  const Ex(vaGoodMorning, "seated dumbbell good morning", [Equipment.dumbbell],
      [], handSqueeze),

  Ex(vaDeadlift, "deadlift (powerlift)", [Equipment.barbell], [], handSqueeze),
  Ex(vaDeadlift, "deadlift", [Equipment.barbell], [], handSqueeze),
  Ex(vaDeadlift, "dumbbell deadlift", [Equipment.dumbbell], [], handSqueeze),
  Ex(vaDeadliftRDL, "romanian deadlift", [Equipment.barbell], [], handSqueeze),
  Ex(vaDeadliftRDL, "dummbbell romanian deadlift", [Equipment.dumbbell], [],
      handSqueeze),

  const Ex(vaBackExtension, "45° back extension", [Equipment.hyper45], [],
      handSqueeze),
  const Ex(vaHipExtension, "45° hip extension", [Equipment.hyper45], [],
      handSqueeze),
  const Ex(vaHipExtension, "90° hip extension", [Equipment.hyper90], [],
      handSqueeze),
  const Ex(vaHipExtension, "reverse hyperextension", [Equipment.hyperReverse],
      [], handSqueeze),
  const Ex(vaPullThrough, "cable pull-through", [Equipment.cableTower], [],
      handSqueeze),

  Ex(vaLegCurlHipFlexed, "seated leg curl machine",
      [Equipment.hamCurlMachineSeated], [legCurlAnkleDorsiflexed]),
  Ex(vaLegCurlHipExtended, "standing unilateral leg curl machine",
      [Equipment.hamCurlMachineStanding], [legCurlAnkleDorsiflexed]),
  Ex(vaLegCurlHipExtended, "lying leg curl machine",
      [Equipment.hamCurlMachineLying], [legCurlAnkleDorsiflexed]),
  Ex({}, "bodyweight leg curl with trx", [Equipment.trx],
      [legCurlAnkleDorsiflexed, legCurlHipFlexion]),
  Ex({}, "bodyweight leg curl with rings", [Equipment.gymnasticRings],
      [legCurlAnkleDorsiflexed, legCurlHipFlexion]),
  Ex({}, "nordic curl", [], [legCurlAnkleDorsiflexed, legCurlHipFlexion]),

  Ex(vaSquatBBAndGoblet, "barbell squat", [Equipment.squatRack],
      [squatBarPlacement, squatLowerLegMovement], handSqueeze),
  Ex(vaSquatBBAndGoblet, "goblet squat", [], [squatLowerLegMovement],
      handSqueeze), // for this one, the lower leg probably *always* moves
  Ex(vaLegPressSquatHackSquatBelt, "machine hack squat",
      [Equipment.hackSquatMachine], [squatLowerLegMovement]),
  Ex(vaLegPressSquatHackSquatBelt, "smith machine hack squat",
      [Equipment.smithMachineVertical], [squatLowerLegMovement]),
  Ex(vaLegPressSquatHackSquatBelt, "belt squat", [Equipment.beltSquatMachine],
      [squatLowerLegMovement]),
  Ex(
      {...vaSquatBSQ, ...wrist03},
      "dumbbell bulgarian split squat",
      [Equipment.dumbbell],
      [bsqRearLeg, squatLowerLegMovement, deficit],
      handSqueeze),
  Ex(
      {...vaSquatBSQ, ...wrist025},
      "barbell bulgarian split squat",
      [Equipment.barbell],
      [bsqRearLeg, squatLowerLegMovement, deficit],
      handSqueeze),
  Ex(
      {...vaSquatBSQ, ...wrist025},
      "smith machine (vertical) bulgarian split squat",
      [Equipment.smithMachineVertical],
      [bsqRearLeg, squatLowerLegMovement, deficit],
      handSqueeze),
  Ex(
      {...vaSquatBSQ, ...wrist025},
      "smith machine (angled) bulgarian split squat",
      [Equipment.smithMachineAngled],
      [bsqRearLeg, squatLowerLegMovement, deficit],
      handSqueeze),

  Ex(vaLegPressSquatHackSquatBelt, "machine leg press",
      [Equipment.legPressMachine], [squatLowerLegMovement]),
  Ex(vaLungeStepUp, "forward lunge", [], [squatLowerLegMovement, deficit]),
  Ex(vaLungeStepUp, "backward lunge", [], [squatLowerLegMovement, deficit]),
  Ex(vaLungeStepUp, "walking lunge", [], [squatLowerLegMovement]),
  Ex({...vaLungeStepUp, ...wrist03}, "dumbbell forward lunge",
      [Equipment.dumbbell], [squatLowerLegMovement, deficit], handSqueeze),
  Ex({...vaLungeStepUp, ...wrist03}, "dumbbell backward lunge",
      [Equipment.dumbbell], [squatLowerLegMovement, deficit], handSqueeze),
  Ex({...vaLungeStepUp, ...wrist03}, "dumbbell walking lunge",
      [Equipment.dumbbell], [squatLowerLegMovement], handSqueeze),
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

  Ex({...vaHipThrustGluteKickback, ...wrist03}, "barbell hip thrust",
      [Equipment.barbell], [hipExtensionKneeFlexion], handSqueeze),
  Ex(vaHipThrustGluteKickback, "smith machine hip thrust",
      [Equipment.smithMachineVertical], [hipExtensionKneeFlexion], handSqueeze),
  Ex(vaHipThrustGluteKickback, "machine hip thrust",
      [Equipment.hipThrustMachine], [hipExtensionKneeFlexion]),

  Ex(vaHipThrustGluteKickback, "glute kickback machine",
      [Equipment.gluteKickbackMachine], [hipExtensionKneeFlexion]),
  Ex(vaHipThrustGluteKickback, "pendulum glute kickback",
      [Equipment.pendulumGluteKickback], [hipExtensionKneeFlexion]),

  Ex({}, "hip abduction machine", [Equipment.hipAdductionAbductionMachine],
      [hipAbductionHipFlexion('90°')]),
  Ex({}, "standing cable hip abduction", [Equipment.cableTower],
      [hipAbductionHipFlexion('0°')]),
  Ex(
    vaHipAbductionStraightHip,
    "lying cable hip abduction",
    [Equipment.cableTower],
  ),
// TODO: unilateral modifiers and other forms
  const Ex(vaStandingCalfRaiseCalfJump, "standing calf raise machine",
      [Equipment.calfRaiseMachineStanding], [], standingCalfRaiseCues),
  Ex(
      {...vaStandingCalfRaiseCalfJump, ...wrist025},
      "barbell standing calf raise",
      [Equipment.barbell],
      [],
      {...handSqueeze, ...standingCalfRaiseCues}),
  Ex(
      {...vaStandingCalfRaiseCalfJump, ...wrist05},
      "dumbbell standing calf raise",
      [Equipment.dumbbell],
      [],
      {...handSqueeze, ...standingCalfRaiseCues}),
  const Ex(vaStandingCalfRaiseCalfJump, "smith machine standing calf raise",
      [Equipment.smithMachineVertical], [], standingCalfRaiseCues),
  const Ex(vaStandingCalfRaiseCalfJump, "leg press straight leg calf raise",
      [Equipment.legPressMachine], [], standingCalfRaiseCues),
  const Ex(vaSeatedCalfRaise, "seated calf raise machine",
      [Equipment.calfRaiseMachineSeated]),

  const Ex(vaStandingCalfRaiseCalfJump, "bodyweight calf jumps", []),
  const Ex({...vaStandingCalfRaiseCalfJump, ...wrist05}, "dumbbell calf jumps",
      [Equipment.dumbbell], [], handSqueeze),
  const Ex(vaStandingCalfRaiseCalfJump, "leg press calf jumps",
      [Equipment.legPressMachine]),

/*
 *    888888b.          d8888  .d8888b.  888    d8P                     
 *    888  "88b        d88888 d88P  Y88b 888   d8P                      
 *    888  .88P       d88P888 888    888 888  d8P                       
 *    8888888K.      d88P 888 888        888d88K                        
 *    888  "Y88b    d88P  888 888        8888888b                       
 *    888    888   d88P   888 888    888 888  Y88b                      
 *    888   d88P  d8888888888 Y88b  d88P 888   Y88b                     
 *    8888888P"  d88P     888  "Y8888P"  888    Y88b     
 */

  const Ex(vaPullupPulldownWidePronatedPullupWidePronated, "pullup", [], [],
      handSqueeze), // just outside shoulder width
  // Ex(EBase.?, "pullup close grip pronated", []),

  const Ex(
      vaPullupSupinatedPulldownSupinatedPullDownPulldownNeutralPullupNeutralDiagonalRow,
      "pullup gymnastic rings",
      [Equipment.gymnasticRings],
      [],
      handSqueeze), // TODO see if recruitment should be adjusted
  const Ex(
      vaPullupSupinatedPulldownSupinatedPullDownPulldownNeutralPullupNeutralDiagonalRow,
      "pullup neutral grip",
      [],
      [],
      handSqueeze),
  const Ex(
      vaPullupSupinatedPulldownSupinatedPullDownPulldownNeutralPullupNeutralDiagonalRow,
      "pullup supinated grip",
      [],
      [],
      handSqueeze), // chin-up
  const Ex(vaPullupPulldownWidePronatedPullupWidePronated,
      "pullup wide pronated grip", [], [], handSqueeze),

  const Ex(vaPullupPulldownWidePronatedPullupWidePronated, "lat pulldown",
      [Equipment.latPullDownMachine], [], handSqueeze),
  const Ex(
      vaPullupSupinatedPulldownSupinatedPullDownPulldownNeutralPullupNeutralDiagonalRow,
      "lat pulldown neutral grip",
      [Equipment.latPullDownMachine],
      [],
      handSqueeze),
  const Ex(
      vaPullupSupinatedPulldownSupinatedPullDownPulldownNeutralPullupNeutralDiagonalRow,
      "lat pulldown supinated grip",
      [Equipment.latPullDownMachine],
      [],
      handSqueeze),
  const Ex(
      vaPullupPulldownWidePronatedPullupWidePronated,
      "lat pulldown wide pronated grip",
      [Equipment.latPullDownMachine],
      [],
      handSqueeze),

  const Ex(
      vaPullupSupinatedPulldownSupinatedPullDownPulldownNeutralPullupNeutralDiagonalRow,
      "kneeling diagonal cable row",
      [Equipment.cableTower],
      [],
      handSqueeze),
  Ex(
      vaRow,
      "seated cable row",
      [Equipment.cableRowMachine],
      [
        Modifier('spine', 'still', {
          'still': (
            {
              ProgramGroup.lats: const Assign(1, 'not full stretch'),
              ProgramGroup.spinalErectors: const Assign(0.25, 'isometric'),
            },
            'keep the spine upright'
          ),
          'dynamic': (
            // aka cable flexion row
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
      ],
      handSqueeze,
      [ratingJNRowCable]),

  // TODO many different grips. those should affect recruitment similar to pullup types
  const Ex(vaRowWithSpineIso, "standing bent over barbell row",
      [Equipment.barbell], [], handSqueeze),

  const Ex(
      vaRowWithoutSpine,
      "standing bench supported single arm dumbbell rows",
      [Equipment.dumbbell],
      [],
      handSqueeze),
  const Ex(
      vaRowWithoutSpine,
      "helms row", // https://www.youtube.com/shorts/XdZSJD41l68
      [Equipment.dumbbell],
      [],
      handSqueeze,
      [ratingJNRowChestSupported]),
  const Ex(vaRowWithoutSpine, "chest supported incline bench row",
      [Equipment.rowMachine], [], handSqueeze, [ratingJNRowChestSupported]),
  const Ex(vaRowWithoutSpine, "chest supported machine rows",
      [Equipment.rowMachine], [], handSqueeze, [ratingJNRowChestSupported]),
  const Ex(vaPullOverLatPrayer, "pull over", [Equipment.cableTower], [],
      handSqueeze),
  const Ex(vaPullOverLatPrayer, "lat prayer", [Equipment.cableTower], [],
      handSqueeze),
  const Ex(vaHighRowRearDeltFlyRearDeltRaiseShoulderPullFacePull,
      "seated cable high row", [Equipment.cableRowMachine], [], handSqueeze),

  const Ex(
      vaHighRowRearDeltFlyRearDeltRaiseShoulderPullFacePull,
      "rear delt fly machine",
      [Equipment.rearDeltFlyMachine],
      [],
      handSqueeze), // TODO unilateral has more ROM
  const Ex(
      vaHighRowRearDeltFlyRearDeltRaiseShoulderPullFacePull,
      "standing unilateral cable rear delt fly",
      [Equipment.cableTower],
      [],
      handSqueeze),

  const Ex(
      vaHighRowRearDeltFlyRearDeltRaiseShoulderPullFacePull,
      "side lying rear delt dumbbell raise",
      [Equipment.dumbbell],
      [],
      handSqueeze),

// TODO: what's the diff again with face pulls? can we do this on trx?
  const Ex(vaHighRowRearDeltFlyRearDeltRaiseShoulderPullFacePull,
      "standing cable shoulder pull", [Equipment.cableTower], [], handSqueeze),
  const Ex(
      vaHighRowRearDeltFlyRearDeltRaiseShoulderPullFacePull,
      "seated cable shoulder pull",
      [Equipment.cableRowMachine],
      [],
      handSqueeze),

  const Ex(vaHighRowRearDeltFlyRearDeltRaiseShoulderPullFacePull,
      "standing cable face pull", [Equipment.cableTower], [], handSqueeze),
  const Ex(vaHighRowRearDeltFlyRearDeltRaiseShoulderPullFacePull,
      "seated cable face pull", [Equipment.cableRowMachine], [], handSqueeze),
  const Ex(vaHighRowRearDeltFlyRearDeltRaiseShoulderPullFacePull,
      "TRX face pull", [Equipment.trx], [], handSqueeze),

/*
 *     .d8888b.  888    888 8888888888  .d8888b. 88888888888            
 *    d88P  Y88b 888    888 888        d88P  Y88b    888                
 *    888    888 888    888 888        Y88b.         888                
 *    888        8888888888 8888888     "Y888b.      888                
 *    888        888    888 888            "Y88b.    888                
 *    888    888 888    888 888              "888    888                
 *    Y88b  d88P 888    888 888        Y88b  d88P    888                
 *     "Y8888P"  888    888 8888888888  "Y8888P"     888    
*/

  const Ex(
      vaBenchPressBBChestPressMachineDip,
      "flat barbell bench press (powerlift)",
      [Equipment.barbell],
      [],
      handSqueeze),
  Ex(
      vaBenchPressBBChestPressMachineDip,
      "barbell bench press",
      [Equipment.barbell],
      [benchPressBenchAngle],
      handSqueeze,
      ratingJNBBBenchPress.toList()),
  Ex(
      vaBenchPressDBChestPressCable,
      "dumbbell bench press",
      [Equipment.dumbbell],
      [benchPressBenchAngle],
      handSqueeze,
      ratingJNDBBenchPress.toList()),
  Ex(vaBenchPressBBChestPressMachineDip, "bench press smith machine",
      [Equipment.smithMachineAngled], [benchPressBenchAngle], handSqueeze),

  const Ex(
      vaBenchPressBBChestPressMachineDip,
      "chest press machine",
      [Equipment.chestPressMachine],
      [],
      handSqueeze,
      [ratingJNMachineChestPress]),

  Ex(vaPushUp, "push-up", [], [deficit], defaultCues,
      [ratingJNPushUp, ratingJNPushUpDeficit]),

  Ex(vaBenchPressDBChestPressCable, "cable chest press",
      [Equipment.cableTowerDual], [benchPressBenchAngle], handSqueeze),

  const Ex(vaBenchPressBBChestPressMachineDip, "dip", [], [], handSqueeze,
      [ratingJNDips]),
  const Ex(vaBenchPressBBChestPressMachineDip, "assisted dip machine",
      [Equipment.assistedDipMachine], [], handSqueeze),
  Ex(vaFlyPecDeckHandGrip, "dumbbell fly", [Equipment.dumbbell], [flyThumbs],
      handSqueeze, [ratingJNDumbbellFly]),
  Ex(vaFlyPecDeckHandGrip, "chest fly machine", [Equipment.chestFlyMachine],
      [flyThumbs], handSqueeze),

  Ex(vaFlyPecDeckHandGrip, "bayesian fly", [Equipment.cableTower], [flyThumbs],
      handSqueeze), // TODO: what makes it bayesian? machine vs single vs dual cables? seated or standing? ROM?
  const Ex(
      vaPecDeckElbowPad, "pec deck (elbow pad)", [Equipment.pecDeckMachine]),
  Ex(
      vaFlyPecDeckHandGrip,
      "chest machine fly (pec deck with hand grip)",
      [Equipment.chestFlyMachine],
      [flyThumbs],
      handSqueeze,
      [ratingJNPecDeckHandGrip]),

  const Ex(vaOverheadPressDB, "dumbbell overhead press", [Equipment.dumbbell],
      [], handSqueeze),
  const Ex(vaOverheadPressBB, "barbell overhead press", [Equipment.barbell], [],
      handSqueeze),
  const Ex(vaOverheadPressBB, "shoulder press machine",
      [Equipment.shoulderPressMachine], [], handSqueeze),

  Ex(vaLateralRaise, "standing dumbbell lateral raise", [Equipment.dumbbell],
      [lateralRaiseShoulderRotation], handSqueeze),
  Ex(vaLateralRaise, "standing cable lateral raise", [Equipment.cableTower],
      [lateralRaiseShoulderRotation, lateralRaiseCablePath], handSqueeze),
  const Ex(vaShrug, "barbell shrug", [Equipment.barbell], [], handSqueeze),
  const Ex(
      vaShrug, "wide grip barbell shrug", [Equipment.barbell], [], handSqueeze),
  const Ex(vaShrug, "dumbbell shrug", [Equipment.dumbbell], [], handSqueeze),

  const Ex(vaTricepExtensionOverhead, "cable overhead tricep extension", [
    Equipment.cableTower
  ], [], {
    ...handSqueeze,
    "RP style": (
      false,
      "use small bar. elbows in - up & back to down & forward. see [this instagram reel](https://www.instagram.com/reel/DEUw9COM-K8)"
    )
  }),
  const Ex(vaTricepExtensionOverhead, "dumbbell overhead tricep extension",
      [Equipment.dumbbell], [], handSqueeze),
  const Ex(vaTricepExtension, "dumbbell skull-over", [Equipment.dumbbell], [],
      handSqueeze),
  const Ex(vaTricepExtension, "barbell skull-over", [Equipment.barbell], [],
      handSqueeze),
  const Ex(vaTricepExtension, "elastic skull-over", [Equipment.elastic], [],
      handSqueeze),
  // these should probably get a hole number for progression, not a weight
  const Ex(
      vaTricepExtension,
      "smitch machine inverted skull crusher",
      [Equipment.smithMachineVertical],
      [],
      handSqueeze), // see https://www.youtube.com/watch?v=1lrjpLuXH4w , https://www.instagram.com/drmikeisraetel/reel/CmosT4EBmDi/?igshid=ZmMyNmFmZTc%3D
  const Ex(vaTricepExtension, "tricep kickback", [Equipment.dumbbell], [],
      handSqueeze),
  const Ex(vaTricepExtension, "tricep cable pushdown", [Equipment.cableTower],
      [], handSqueeze),
/***
 *    888888b.  8888888  .d8888b.  8888888888 8888888b.   .d8888b.  
 *    888  "88b   888   d88P  Y88b 888        888   Y88b d88P  Y88b 
 *    888  .88P   888   888    888 888        888    888 Y88b.      
 *    8888888K.   888   888        8888888    888   d88P  "Y888b.   
 *    888  "Y88b  888   888        888        8888888P"      "Y88b. 
 *    888    888  888   888    888 888        888              "888 
 *    888   d88P  888   Y88b  d88P 888        888        Y88b  d88P 
 *    8888888P" 8888888  "Y8888P"  8888888888 888         "Y8888P" 
 */
  const Ex(vaBicepCurlAnatomic, "barbell bicep curl", [Equipment.barbell], [],
      handSqueeze, [ratingJNBBCurl]),
  const Ex(vaBicepCurlAnatomic, "ez bar bicep curl", [Equipment.ezbar], [],
      handSqueeze, [ratingJNEZBarCurl]),
  const Ex(vaBicepCurlAnatomic, "cable bicep curl", [Equipment.cableTower], [],
      handSqueeze, []),
  const Ex(vaBicepCurlAnatomic, "dumbbell bicep curl", [Equipment.dumbbell], [],
      handSqueeze, [ratingJNDBCurl]),
  const Ex(vaBicepCurlAnatomic, "dumbbell hammer bicep curl",
      [Equipment.dumbbell], [], handSqueeze, [ratingJNDBHammerCurl]),
  const Ex(vaBicepCurlAnatomic, "kettlebell bicep curl", [Equipment.kettlebell],
      [], handSqueeze),
  const Ex(vaBicepCurlPreacher, "preacher bicep curl machine",
      [Equipment.preacherCurlMachine], [], handSqueeze),
  const Ex(vaBicepCurlPreacher, "preacher bicep curl bench/barbell",
      [Equipment.preacherCurlBench], [], handSqueeze),
  const Ex(vaBicepCurlAnatomic, "bicep curl machine",
      [Equipment.bicepCurlMachine], [], handSqueeze),
  const Ex(vaBicepCurlBayesian, "bayesian curl", [Equipment.cableTower], [],
      handSqueeze),
  const Ex(vaBicepCurlConcentration, "concentration curl", [Equipment.dumbbell],
      [], handSqueeze), // unilateral
  const Ex(vaBicepCurlLying, "lying bicep curl", [Equipment.dumbbell], [],
      handSqueeze), // see https://www.youtube.com/watch?v=okwUqL1kbEA , https://www.youtube.com/watch?v=zlkq4hDSKZo
  const Ex(vaAbCrunch, "ab crunch machine", [Equipment.abCrunchMachine]),
  const Ex(
      vaAbCrunch, "cable ab crunch", [Equipment.cableTower], [], handSqueeze),
  const Ex(vaAbCrunch, "laying ab crunch", []),
  const Ex(vaAbIsometric, "plank", []),
  const Ex(vaWristFlexion, "dumbbell wrist curls", [Equipment.dumbbell], [],
      handSqueeze),
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
