import 'package:bodybuild/data/programmer/equipment.dart';
import 'package:bodybuild/data/programmer/groups.dart';
import 'package:bodybuild/data/programmer/tweak.dart';
import 'package:bodybuild/data/programmer/rating_jn.dart';
import 'package:bodybuild/data/programmer/rating_mh.dart';
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
  final List<Tweak> tweaks;
  final List<Rating> ratings;
  final String id; // identifier to match to kaos exercise. does not need to be human friendly

  const Ex(
    this.volumeAssignment,
    this.id,
    this.equipment, [
    this.tweaks = const [],
    this.ratings = const [],
  ]);

  // calculate recruitment for a given PG & tweak options.
  // tweakOptions is a subset of the exercise' tweak options; if not specified, we use the default
  Assign recruitment(ProgramGroup pg, Map<String, String?> tweakOptions) {
    // establish base recruitment:
    var r = volumeAssignment[pg] ?? const Assign(0);

    // Apply any tweaks that apply
    for (final tweak in tweaks) {
      final selectedOption = tweakOptions[tweak.name] ?? tweak.defaultVal;
      if (!tweak.opts.containsKey(selectedOption)) {
        // This should never happen. this would be a bug in the tweaks definition
        print('tweak ${tweak.name} has no option $selectedOption');
      }
      final optEffects = tweak.opts[selectedOption]!.$1;
      if (optEffects.containsKey(pg)) {
        r = r.merge(optEffects[pg]!);
      }
    }

    return r;
  }

  Assign recruitmentFiltered(ProgramGroup pg, Map<String, String?> tweakOptions, double cutoff) {
    final raw = recruitment(pg, tweakOptions);
    return raw.volume >= cutoff ? raw : const Assign(0);
  }

  // calculate total recruitment for all PG's combined, for the given tweakOptions
  double totalRecruitment(Map<String, String> tweakOptions) =>
      ProgramGroup.values.fold(0.0, (sum, group) => sum + recruitment(group, tweakOptions).volume);

  double totalRecruitmentFiltered(double cutoff, Map<String, String> tweakOptions) => ProgramGroup
      .values
      .fold(0.0, (sum, group) => sum + recruitmentFiltered(group, tweakOptions, cutoff).volume);

  /// Returns tweaks that may affect recruitment or ratings for the target muscle group
  /// For each tweak, include all its options. Only some may actually affect recruitment/rating
  Map<String, List<String>> getRelevantTweaks(ProgramGroup g) {
    return Map.fromEntries(
      tweaks
          .where((tweak) {
            final affectsRecruitment = tweak.opts.entries.any((opt) => opt.value.$1.containsKey(g));
            final affectsRating = ratings.any(
              (rating) => rating.pg.contains(g) && rating.tweaks.containsKey(tweak.name),
            );
            return affectsRecruitment || affectsRating;
          })
          .map((tweak) => MapEntry(tweak.name, tweak.opts.keys.toList())),
    );
  }
}

// TODO add pullup negatives. this is not eccentric overloads (those still have concentric)
// form tweaks like unilateral concentrics, unilateral, e.g. for leg ext, leg curls, calf raises
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
/*
exercise id and tweak names/values allowed chars: a-z, 0-9, °, -, space, (), >
no '&' cause that would look ugly in URL encoding
no '_' because it shouldn't be needed, and allows us to url encode space to '_' instead of %20 in the URL and instead of '+' in path parameters
*/
final List<Ex> exes = [
  const Ex(vaGoodMorning, "standing barbell good morning", [Equipment.barbell], [rom, gripSqueeze]),
  const Ex(
    vaGoodMorning,
    "standing dumbbell good morning",
    [Equipment.dumbbell],
    [rom, gripSqueeze],
  ),
  const Ex(vaGoodMorning, "seated barbell good morning", [Equipment.barbell], [rom, gripSqueeze]),
  const Ex(vaGoodMorning, "seated dumbbell good morning", [Equipment.dumbbell], [rom, gripSqueeze]),

  Ex(vaDeadlift, "deadlift (powerlift)", [Equipment.barbell], [rom, gripSqueeze]),
  Ex(vaDeadlift, "deadlift", [Equipment.barbell], [rom, gripSqueeze]),
  Ex(vaDeadlift, "dumbbell deadlift", [Equipment.dumbbell], [rom, gripSqueeze]),
  Ex(vaDeadliftRDL, "romanian deadlift", [Equipment.barbell], [rom, gripSqueeze]),
  Ex(vaDeadliftRDL, "dummbbell romanian deadlift", [Equipment.dumbbell], [rom, gripSqueeze]),

  const Ex(vaBackExtension, "45° back extension", [Equipment.hyper45], [rom, gripSqueeze]),
  const Ex(vaHipExtension, "45° hip extension", [Equipment.hyper45], [rom, gripSqueeze]),
  const Ex(vaHipExtension, "90° hip extension", [Equipment.hyper90], [rom, gripSqueeze]),
  const Ex(vaHipExtension, "reverse hyperextension", [Equipment.hyperReverse], [rom, gripSqueeze]),
  const Ex(vaPullThrough, "cable pull-through", [Equipment.cableTower], [rom, gripSqueeze]),

  const Ex(
    vaLegCurlHipFlexed,
    "seated leg curl machine",
    [Equipment.hamCurlMachineSeated],
    [rom, legCurlAnkleDorsiflexed],
  ),
  const Ex(
    vaLegCurlHipExtended,
    "standing unilateral leg curl machine",
    [Equipment.hamCurlMachineStanding],
    [rom, legCurlAnkleDorsiflexed],
  ),
  const Ex(
    vaLegCurlHipExtended,
    "lying leg curl machine",
    [Equipment.hamCurlMachineLying],
    [rom, legCurlAnkleDorsiflexed],
  ),
  const Ex(
    {},
    "bodyweight leg curl with trx",
    [Equipment.trx],
    [rom, legCurlAnkleDorsiflexed, legCurlHipFlexion],
  ),
  const Ex(
    {},
    "bodyweight leg curl with rings",
    [Equipment.gymnasticRings],
    [rom, legCurlAnkleDorsiflexed, legCurlHipFlexion],
  ),
  const Ex({}, "nordic curl", [], [rom, legCurlAnkleDorsiflexed, legCurlHipFlexion]),

  const Ex(
    vaSquatBBAndGoblet,
    "barbell squat",
    [Equipment.squatRack],
    [rom, gripSqueeze, squatBarPlacement, squatLowerLegMovement],
  ),
  const Ex(vaSquatBBAndGoblet, "goblet squat", [], [
    rom,
    squatLowerLegMovement,
  ]), // for this one, the lower leg probably *always* moves
  const Ex(
    vaLegPressSquatHackSquatBelt,
    "machine hack squat",
    [Equipment.hackSquatMachine],
    [rom, squatLowerLegMovement],
  ),
  const Ex(
    vaLegPressSquatHackSquatBelt,
    "smith machine hack squat",
    [Equipment.smithMachineVertical],
    [rom, squatLowerLegMovement],
  ),
  const Ex(
    vaLegPressSquatHackSquatBelt,
    "belt squat",
    [Equipment.beltSquatMachine],
    [rom, squatLowerLegMovement],
  ),
  const Ex({...vaSquatBSQ, ...wrist03}, "dumbbell bulgarian split squat", [Equipment.dumbbell], [
    rom,
    gripSqueeze,
    bsqRearLeg,
    squatLowerLegMovement,
    deficit,
  ]),
  const Ex({...vaSquatBSQ, ...wrist025}, "barbell bulgarian split squat", [Equipment.barbell], [
    rom,
    gripSqueeze,
    bsqRearLeg,
    squatLowerLegMovement,
    deficit,
  ]),
  const Ex(
    {...vaSquatBSQ, ...wrist025},
    "smith machine (vertical) bulgarian split squat",
    [Equipment.smithMachineVertical],
    [rom, gripSqueeze, bsqRearLeg, squatLowerLegMovement, deficit],
  ),
  const Ex(
    {...vaSquatBSQ, ...wrist025},
    "smith machine (angled) bulgarian split squat",
    [Equipment.smithMachineAngled],
    [rom, gripSqueeze, bsqRearLeg, squatLowerLegMovement, deficit],
  ),

  const Ex(
    vaLegPressSquatHackSquatBelt,
    "machine leg press",
    [Equipment.legPressMachine],
    [rom, squatLowerLegMovement],
  ),
  const Ex(vaLungeStepUp, "forward lunge", [], [rom, squatLowerLegMovement, deficit]),
  const Ex(vaLungeStepUp, "backward lunge", [], [rom, squatLowerLegMovement, deficit]),
  const Ex(vaLungeStepUp, "walking lunge", [], [rom, squatLowerLegMovement]),
  const Ex({...vaLungeStepUp, ...wrist03}, "dumbbell forward lunge", [Equipment.dumbbell], [
    rom,
    gripSqueeze,
    squatLowerLegMovement,
    deficit,
  ]),
  const Ex({...vaLungeStepUp, ...wrist03}, "dumbbell backward lunge", [Equipment.dumbbell], [
    rom,
    gripSqueeze,
    squatLowerLegMovement,
    deficit,
  ]),
  const Ex({...vaLungeStepUp, ...wrist03}, "dumbbell walking lunge", [Equipment.dumbbell], [
    rom,
    gripSqueeze,
    squatLowerLegMovement,
  ]),
  const Ex(vaLungeStepUp, "step up", [], [rom, squatLowerLegMovement]),

  const Ex(vaSquatPistolSissyAssistedSpanish, "pistol squat", [], [rom, squatLowerLegMovement]),
  const Ex(vaLegExtensionReverseNordicHamCurlSquatSissy, "sissy squat", [], [
    rom,
    legExtensionLean,
  ]),
  const Ex(vaSquatPistolSissyAssistedSpanish, "assisted sissy squat", [], [rom, legExtensionLean]),
  const Ex(
    vaSquatPistolSissyAssistedSpanish,
    "spanish squat",
    [Equipment.elastic],
    [rom, squatLowerLegMovement],
  ),

  const Ex(
    vaLegExtensionReverseNordicHamCurlSquatSissy,
    "seated leg extension machine",
    [Equipment.legExtensionMachine],
    [rom, legExtensionPullOnHandles, legExtensionLean],
  ),

  const Ex(vaLegExtensionReverseNordicHamCurlSquatSissy, "reverse nordic ham curl", [], [
    rom,
    legExtensionLean,
  ]),

  const Ex({...vaHipThrustGluteKickback, ...wrist03}, "barbell hip thrust", [Equipment.barbell], [
    rom,
    hipExtensionKneeFlexion,
  ]),
  const Ex(
    vaHipThrustGluteKickback,
    "smith machine hip thrust",
    [Equipment.smithMachineVertical],
    [rom, hipExtensionKneeFlexion],
  ),
  const Ex(
    vaHipThrustGluteKickback,
    "machine hip thrust",
    [Equipment.hipThrustMachine],
    [rom, hipExtensionKneeFlexion],
  ),

  const Ex(
    vaHipThrustGluteKickback,
    "glute kickback machine",
    [Equipment.gluteKickbackMachine],
    [rom, hipExtensionKneeFlexion],
  ),
  const Ex(
    vaHipThrustGluteKickback,
    "pendulum glute kickback",
    [Equipment.pendulumGluteKickback],
    [rom, hipExtensionKneeFlexion],
  ),

  Ex(
    {},
    "hip abduction machine",
    [Equipment.hipAdductionAbductionMachine],
    [rom, hipAbductionHipFlexion('90')],
  ),
  Ex(
    {},
    "standing cable hip abduction",
    [Equipment.cableTower],
    [rom, hipAbductionHipFlexion('0')],
  ),
  Ex(vaHipAbductionStraightHip, "lying cable hip abduction", [Equipment.cableTower], [rom]),
  // TODO: unilateral tweaks and other forms
  Ex(
    vaStandingCalfRaiseCalfJump,
    "standing calf raise machine",
    [Equipment.calfRaiseMachineStanding],
    [romCalfRaise, calfRaiseToes],
  ),
  // ignore: prefer_const_constructors
  Ex(
    {...vaStandingCalfRaiseCalfJump, ...wrist025},
    "barbell standing calf raise",
    [Equipment.barbell],
    [romCalfRaise, calfRaiseToes, gripSqueeze],
  ),
  // ignore: prefer_const_constructors
  Ex(
    {...vaStandingCalfRaiseCalfJump, ...wrist05},
    "dumbbell standing calf raise",
    [Equipment.dumbbell],
    [romCalfRaise, calfRaiseToes, gripSqueeze],
  ),
  Ex(
    vaStandingCalfRaiseCalfJump,
    "smith machine standing calf raise",
    [Equipment.smithMachineVertical],
    [romCalfRaise, calfRaiseToes],
  ),
  Ex(
    vaStandingCalfRaiseCalfJump,
    "leg press straight leg calf raise",
    [Equipment.legPressMachine],
    [romCalfRaise, calfRaiseToes],
  ),
  Ex(
    vaSeatedCalfRaise,
    "seated calf raise machine",
    [Equipment.calfRaiseMachineSeated],
    [romCalfRaise, calfRaiseToes],
  ),

  Ex(vaStandingCalfRaiseCalfJump, "bodyweight calf jumps", [], [romCalfRaise, calfRaiseToes]),
  Ex({...vaStandingCalfRaiseCalfJump, ...wrist05}, "dumbbell calf jumps", [Equipment.dumbbell], [
    romCalfRaise,
    calfRaiseToes,
    gripSqueeze,
  ]),
  Ex(
    vaStandingCalfRaiseCalfJump,
    "leg press calf jumps",
    [Equipment.legPressMachine],
    [romCalfRaise, calfRaiseToes],
  ),

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
  const Ex(vaPullupPulldownWidePronatedPullupWidePronated, "pullup", [], [
    rom,
    gripSqueeze,
  ]), // just outside shoulder width
  // Ex(EBase.?, "pullup close grip pronated", []),
  const Ex(
    vaPullupSupinatedPulldownSupinatedPullDownPulldownNeutralPullupNeutralDiagonalRow,
    "pullup gymnastic rings",
    [Equipment.gymnasticRings],
    [rom, gripSqueeze],
  ), // TODO see if recruitment should be adjusted
  const Ex(
    vaPullupSupinatedPulldownSupinatedPullDownPulldownNeutralPullupNeutralDiagonalRow,
    "pullup neutral grip",
    [],
    [rom, gripSqueeze],
  ),
  const Ex(
    vaPullupSupinatedPulldownSupinatedPullDownPulldownNeutralPullupNeutralDiagonalRow,
    "pullup supinated grip",
    [],
    [rom, gripSqueeze],
  ), // chin-up
  const Ex(vaPullupPulldownWidePronatedPullupWidePronated, "pullup wide pronated grip", [], [
    rom,
    gripSqueeze,
  ]),

  const Ex(
    vaPullupPulldownWidePronatedPullupWidePronated,
    "lat pulldown",
    [Equipment.latPullDownMachine],
    [rom, gripSqueeze],
  ),
  const Ex(
    vaPullupSupinatedPulldownSupinatedPullDownPulldownNeutralPullupNeutralDiagonalRow,
    "lat pulldown neutral grip",
    [Equipment.latPullDownMachine],
    [rom, gripSqueeze],
  ),
  const Ex(
    vaPullupSupinatedPulldownSupinatedPullDownPulldownNeutralPullupNeutralDiagonalRow,
    "lat pulldown supinated grip",
    [Equipment.latPullDownMachine],
    [rom, gripSqueeze],
  ),
  const Ex(
    vaPullupPulldownWidePronatedPullupWidePronated,
    "lat pulldown wide pronated grip",
    [Equipment.latPullDownMachine],
    [rom, gripSqueeze],
  ),

  const Ex(
    vaPullupSupinatedPulldownSupinatedPullDownPulldownNeutralPullupNeutralDiagonalRow,
    "kneeling diagonal cable row",
    [Equipment.cableTower],
    [rom, gripSqueeze],
  ),
  const Ex(
    vaRow,
    "seated cable row",
    [Equipment.cableRowMachine],
    [
      rom,
      gripSqueeze,
      Tweak('spine', 'still', {
        'still': (
          {
            ProgramGroup.lats: Assign(1, 'not full stretch'),
            ProgramGroup.spinalErectors: Assign(0.25, 'isometric'),
          },
          'keep the spine upright',
        ),
        'dynamic': (
          // aka cable flexion row
          {
            ProgramGroup.lats: Assign(1, 'near full stretch'),
            ProgramGroup.spinalErectors: Assign(0.5, 'flexion & extension cycles'),
          },
          """flex/extend the spine to go beyond the normal rowing motion, to achieve greater lat stretch and erector spinae workout.  
            Also called 'flexion row'""",
        ),
      }),
      Tweak('grip width', 'shoulder', {
        'shoulder': ({}, ''),
        'wide': (
          {
            ProgramGroup.rearDelts: Assign(1, 'shoulder horizontal extension + shoulder extension'),
            ProgramGroup.lowerTraps: Assign(1, 'scapular retraction + depression'),
            ProgramGroup.lats: Assign(1, 'shoulder extension + shoulder adduction'),
          },
          '',
        ),
      }),
    ],
    [ratingJNRowCable],
  ),

  // TODO many different grips. those should affect recruitment similar to pullup types
  const Ex(
    vaRowWithSpineIso,
    "standing bent over barbell row",
    [Equipment.barbell],
    [rom, gripSqueeze],
  ),

  const Ex(
    vaRowWithoutSpine,
    "standing bench supported single arm dumbbell rows",
    [Equipment.dumbbell],
    [rom, gripSqueeze],
  ),
  const Ex(
    vaRowWithoutSpine,
    "helms row", // https://www.youtube.com/shorts/XdZSJD41l68
    [Equipment.dumbbell],
    [rom, gripSqueeze],
    [ratingJNRowChestSupported],
  ),
  const Ex(
    vaRowWithoutSpine,
    "chest supported incline bench row",
    [Equipment.rowMachine],
    [rom, gripSqueeze],
    [ratingJNRowChestSupported],
  ),
  const Ex(
    vaRowWithoutSpine,
    "chest supported machine row",
    [Equipment.rowMachine],
    [rom, gripSqueeze],
    [ratingJNRowChestSupported],
  ),
  const Ex(vaPullOverLatPrayer, "pull over", [Equipment.cableTower], [rom, gripSqueeze]),
  const Ex(vaPullOverLatPrayer, "lat prayer", [Equipment.cableTower], [rom, gripSqueeze]),
  const Ex(
    vaHighRowRearDeltFlyRearDeltRaiseShoulderPullFacePull,
    "seated cable high row",
    [Equipment.cableRowMachine],
    [rom, gripSqueeze],
  ),

  const Ex(
    vaHighRowRearDeltFlyRearDeltRaiseShoulderPullFacePull,
    "rear delt fly machine",
    [Equipment.rearDeltFlyMachine],
    [rom, gripSqueeze],
  ), // TODO unilateral has more ROM
  const Ex(
    vaHighRowRearDeltFlyRearDeltRaiseShoulderPullFacePull,
    "standing unilateral cable rear delt fly",
    [Equipment.cableTower],
    [rom, gripSqueeze],
  ),

  const Ex(
    vaHighRowRearDeltFlyRearDeltRaiseShoulderPullFacePull,
    "side lying rear delt dumbbell raise",
    [Equipment.dumbbell],
    [rom, gripSqueeze],
  ),

  // TODO: what's the diff again with face pulls? can we do this on trx?
  const Ex(
    vaHighRowRearDeltFlyRearDeltRaiseShoulderPullFacePull,
    "standing cable shoulder pull",
    [Equipment.cableTower],
    [rom, gripSqueeze],
  ),
  const Ex(
    vaHighRowRearDeltFlyRearDeltRaiseShoulderPullFacePull,
    "seated cable shoulder pull",
    [Equipment.cableRowMachine],
    [rom, gripSqueeze],
  ),

  const Ex(
    vaHighRowRearDeltFlyRearDeltRaiseShoulderPullFacePull,
    "standing cable face pull",
    [Equipment.cableTower],
    [rom, gripSqueeze],
  ),
  const Ex(
    vaHighRowRearDeltFlyRearDeltRaiseShoulderPullFacePull,
    "seated cable face pull",
    [Equipment.cableRowMachine],
    [rom, gripSqueeze],
  ),
  const Ex(
    vaHighRowRearDeltFlyRearDeltRaiseShoulderPullFacePull,
    "TRX face pull",
    [Equipment.trx],
    [rom, gripSqueeze],
  ),

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
    [rom, gripSqueeze],
  ),
  Ex(
    vaBenchPressBBChestPressMachineDip,
    "barbell bench press",
    [Equipment.barbell],
    [rom, gripSqueeze, benchPressBenchAngle],
    ratingJNBBBenchPress.toList(),
  ),
  Ex(
    vaBenchPressDBChestPressCable,
    "dumbbell bench press",
    [Equipment.dumbbell],
    [rom, gripSqueeze, benchPressBenchAngle],
    ratingJNDBBenchPress.toList(),
  ),
  const Ex(
    vaBenchPressBBChestPressMachineDip,
    "bench press smith machine",
    [Equipment.smithMachineAngled],
    [rom, gripSqueeze, benchPressBenchAngle],
  ),

  const Ex(
    vaBenchPressBBChestPressMachineDip,
    "chest press machine",
    [Equipment.chestPressMachine],
    [rom, gripSqueeze],
    [ratingJNMachineChestPress],
  ),

  const Ex(vaPushUp, "push-up", [], [rom, deficit], [ratingJNPushUp, ratingJNPushUpDeficit]),

  const Ex(
    vaBenchPressDBChestPressCable,
    "cable chest press",
    [Equipment.cableTowerDual],
    [rom, gripSqueeze, benchPressBenchAngle],
  ),

  const Ex(vaBenchPressBBChestPressMachineDip, "dip", [], [rom, gripSqueeze], [ratingJNDips]),
  const Ex(
    vaBenchPressBBChestPressMachineDip,
    "assisted dip machine",
    [Equipment.assistedDipMachine],
    [rom, gripSqueeze],
  ),
  const Ex(
    vaFlyPecDeckHandGrip,
    "dumbbell fly",
    [Equipment.dumbbell],
    [rom, flyThumbs, gripSqueeze],
    [ratingJNDumbbellFly],
  ),
  const Ex(
    vaFlyPecDeckHandGrip,
    "chest fly machine",
    [Equipment.chestFlyMachine],
    [rom, gripSqueeze, flyThumbs],
  ),

  const Ex(
    vaFlyPecDeckHandGrip,
    "bayesian fly",
    [Equipment.cableTower],
    [rom, gripSqueeze, flyThumbs],
  ), // TODO: what makes it bayesian? machine vs single vs dual cables? seated or standing? ROM?
  const Ex(vaPecDeckElbowPad, "pec deck (elbow pad)", [Equipment.pecDeckMachine], [rom]),
  const Ex(
    vaFlyPecDeckHandGrip,
    "chest machine fly (pec deck with hand grip)",
    [Equipment.chestFlyMachine],
    [rom, gripSqueeze, flyThumbs],
    [ratingJNPecDeckHandGrip],
  ),

  const Ex(vaOverheadPressDB, "dumbbell overhead press", [Equipment.dumbbell], [rom, gripSqueeze]),
  const Ex(vaOverheadPressBB, "barbell overhead press", [Equipment.barbell], [rom, gripSqueeze]),
  const Ex(
    vaOverheadPressBB,
    "shoulder press machine",
    [Equipment.shoulderPressMachine],
    [rom, gripSqueeze],
  ),

  Ex(
    vaLateralRaise,
    "standing dumbbell lateral raise",
    [Equipment.dumbbell],
    [rom, gripSqueeze, lateralRaiseShoulderRotation],
  ),
  Ex(
    vaLateralRaise,
    "standing cable lateral raise",
    [Equipment.cableTower],
    [rom, gripSqueeze, lateralRaiseShoulderRotation, lateralRaiseCablePath],
  ),
  const Ex(vaShrug, "barbell shrug", [Equipment.barbell], [rom, gripSqueeze]),
  const Ex(vaShrug, "wide grip barbell shrug", [Equipment.barbell], [rom, gripSqueeze]),
  const Ex(vaShrug, "dumbbell shrug", [Equipment.dumbbell], [rom, gripSqueeze]),

  const Ex(
    vaTricepExtensionOverhead,
    "cable overhead tricep extension",
    [Equipment.cableTower],
    [
      rom,
      gripSqueeze,
      Tweak('RP style', 'no', {
        'no': ({}, ''),
        'yes': (
          {},
          'use small bar. elbows in - up & back to down & forward. see [this instagram reel](https://www.instagram.com/reel/DEUw9COM-K8)',
        ),
      }),
    ],
  ),
  const Ex(
    vaTricepExtensionOverhead,
    "dumbbell overhead tricep extension",
    [Equipment.dumbbell],
    [rom],
  ),
  const Ex(vaTricepExtension, "dumbbell skull-over", [Equipment.dumbbell], [rom, gripSqueeze]),
  const Ex(vaTricepExtension, "barbell skull-over", [Equipment.barbell], [rom, gripSqueeze]),
  const Ex(vaTricepExtension, "elastic skull-over", [Equipment.elastic], [rom, gripSqueeze]),
  // these should probably get a hole number for progression, not a weight
  const Ex(
    vaTricepExtension,
    "smitch machine inverted skull crusher",
    [Equipment.smithMachineVertical],
    [rom, gripSqueeze],
  ), // see https://www.youtube.com/watch?v=1lrjpLuXH4w , https://www.instagram.com/drmikeisraetel/reel/CmosT4EBmDi/?igshid=ZmMyNmFmZTc%3D
  const Ex(vaTricepExtension, "tricep kickback", [Equipment.dumbbell], [rom, gripSqueeze]),
  const Ex(vaTricepExtension, "tricep cable pushdown", [Equipment.cableTower], [rom, gripSqueeze]),
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
  const Ex(
    vaBicepCurlAnatomic,
    "standing barbell bicep curl",
    [Equipment.barbell],
    [rom, gripSqueeze],
    [ratingJNBBCurl],
  ),
  const Ex(
    vaBicepCurlAnatomic,
    "standing ez bar bicep curl",
    [Equipment.ezbar],
    [rom, gripSqueeze],
    [ratingJNEZBarCurl],
  ),
  const Ex(
    vaBicepCurlAnatomic,
    "standing cable bicep curl",
    [Equipment.cableTower],
    [rom, gripSqueeze, cableCurlStyle],
    [...ratingJNCableCurl, ratingMhCableCurl],
  ),
  const Ex(
    vaBicepCurlAnatomic,
    "standing dumbbell bicep curl",
    [Equipment.dumbbell],
    [rom, gripSqueeze, dbCurlGrip],
    ratingJNDBCurl,
  ),
  const Ex(
    vaBicepCurlLying,
    "lying dumbbell bicep curl",
    [Equipment.dumbbell],
    [rom, gripSqueeze],
  ), // see https://www.youtube.com/watch?v=okwUqL1kbEA , https://www.youtube.com/watch?v=zlkq4hDSKZo
  const Ex(
    vaBicepCurlAnatomic,
    "standing kettlebell bicep curl",
    [Equipment.kettlebell],
    [rom, gripSqueeze],
  ),
  const Ex(
    vaBicepCurlPreacher,
    "preacher bicep curl machine",
    [Equipment.preacherCurlMachine],
    [rom, gripSqueeze],
  ),
  const Ex(
    vaBicepCurlPreacher,
    "preacher bicep curl bench/barbell",
    [Equipment.preacherCurlBench],
    [rom, gripSqueeze],
  ),
  const Ex(
    vaBicepCurlAnatomic,
    "bicep curl machine",
    [Equipment.bicepCurlMachine],
    [rom, gripSqueeze],
  ),
  const Ex(
    vaBicepCurlConcentration,
    "concentration curl",
    [Equipment.dumbbell],
    [rom, gripSqueeze],
  ), // unilateral

  const Ex(vaAbCrunch, "ab crunch machine", [Equipment.abCrunchMachine], [rom]),
  const Ex(vaAbCrunch, "cable ab crunch", [Equipment.cableTower], [rom, gripSqueeze]),
  const Ex(vaAbCrunch, "laying ab crunch", [], [rom]),
  const Ex(vaAbIsometric, "plank", []),
  const Ex(vaWristFlexion, "dumbbell wrist curl", [Equipment.dumbbell], [rom, gripSqueeze]),
  const Ex(vaWristExtension, "dumbbell wrist extension", [Equipment.dumbbell], [rom]),
];

/// Returns a filtered list of exercises based on various criteria and sorts by ID
List<Ex> getFilteredExercises({
  Set<Ex>? excludedExercises,
  Set<Equipment>? availEquipment,
  Set<EquipmentCategory>? availEquipmentCategories,
  String? query,
  ProgramGroup? muscleGroup,
}) {
  var exercises = exes.where((e) {
    if (excludedExercises?.contains(e) ?? false) return false;

    if (availEquipment != null || availEquipmentCategories != null) {
      bool check(Equipment equip) =>
          (availEquipment != null && availEquipment.contains(equip)) ||
          (availEquipmentCategories != null && availEquipmentCategories.contains(equip.category));

      if (!e.equipment.every(check)) {
        return false;
      }
    }

    if (query != null && query.isNotEmpty) {
      if (!e.id.toLowerCase().contains(query.toLowerCase())) {
        return false;
      }
    }

    if (muscleGroup != null) {
      final recruitment = e.recruitmentFiltered(muscleGroup, {}, 0.5);
      if (recruitment.volume <= 0.5) {
        return false;
      }
    }

    return true;
  }).toList();

  // Sort exercises alphabetically
  exercises.sort((a, b) => a.id.compareTo(b.id));
  return exercises;
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
