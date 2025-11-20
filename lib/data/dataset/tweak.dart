import 'package:bodybuild/data/dataset/assign.dart';
import 'package:bodybuild/data/dataset/program_group.dart';
import 'package:bodybuild/data/dataset/volume_assignment.dart';
import 'package:bodybuild/data/dataset/equipment.dart';

class Tweak {
  final String name;
  final String defaultVal;
  final Map<String, Option> opts;
  final String? desc;

  const Tweak(this.name, this.defaultVal, this.opts, {this.desc});

  /// Generates cartesian product of tweak options
  /// Example: {ROM: [full, partial], grip: [normal, extra]}
  ///       → [{ROM: full, grip: normal}, {ROM: full, grip: extra}, ...]
  static List<Map<String, String>> generateCombinations(Map<String, List<String>> tweakOptions) {
    return tweakOptions.entries.fold<List<Map<String, String>>>(
      [{}],
      (combinations, tweakOpts) => [
        for (final combo in combinations)
          for (final val in tweakOpts.value) {...combo, tweakOpts.key: val},
      ],
    );
  }
}

class Option {
  final VolumeAssignment va;
  final String desc;
  final Equipment? equipment;

  const Option(this.va, this.desc, {this.equipment});
}

/// Represents a bidirectional incompatibility constraint between two sets of tweak options.
/// Used at the Exercise level to declare that certain option combinations are invalid.
/// Format: TweakConstraint(('tweakName1', {'opt1', 'opt2'}), ('tweakName2', {'optA', 'optB'}))
/// Meaning: If tweak1 is set to opt1 or opt2, then tweak2 cannot be optA or optB (and vice versa)
class TweakConstraint {
  /// First tweak name and its incompatible option keys
  final (String, Set<String>) side1;

  /// Second tweak name and its incompatible option keys
  final (String, Set<String>) side2;

  const TweakConstraint(this.side1, this.side2);

  /// Checks if a specific option of a tweak is available given current selections
  bool isOptionAvailable(
    String tweakName,
    String optionKey,
    Map<String, String> currentSelections,
  ) {
    // Check if this constraint involves the tweak we're checking
    (String, Set<String>)? other;
    if (side1.$1 == tweakName && side1.$2.contains(optionKey)) {
      other = side2;
    } else if (side2.$1 == tweakName && side2.$2.contains(optionKey)) {
      other = side1;
    } else {
      return true;
    }
    // Check if the other side is currently selected
    final otherValue = currentSelections[other.$1];
    return (otherValue == null || !other.$2.contains(otherValue));
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TweakConstraint &&
          runtimeType == other.runtimeType &&
          side1 == other.side1 &&
          side2 == other.side2;

  @override
  int get hashCode => side1.hashCode ^ side2.hashCode;
}

// BEWARE: tweak names and option names go into URL's, so don't use special chars
const rom = Tweak("ROM", "full", {
  "full": Option({}, 'full range of motion'),
  "full with extra time at stretch": Option({}, 'full range of motion with extra time at stretch'),
  "full with extra time at contraction": Option(
    {},
    'full range of motion with extra time at contraction',
  ),
  "lengthened partials": Option(
    {},
    'only the long muscle length ("bottom") half of the ROM',
  ), // TODO: this only make sense for exercises that load under stretch
  "shortened partials": Option(
    {},
    'only the short muscle length ("top") half of the ROM',
  ), // TODO: this only make sense for exercises that load at the shortest
  "mid-range partials": Option(
    {},
    'only the mid-range of the ROM',
  ), // TODO: this only make sense for exercises that load at the mid-range
});

final romCalfRaise = Tweak("ROM", "full", {
  ...rom.opts,
  'full with lengthened partials beyond failure': const Option(
    {},
    "go until you can't move the weight. (don't count the partials) should stimulate more gastrocnemius growth. [jeff nippard video](https://www.youtube.com/shorts/baEXLy09Ncc)",
  ),
});

const calfRaiseToes = Tweak("toes", "neutral", {
  "neutral": Option({}, 'point toes forward. The standard'),
  "in": Option({}, 'point toes in, stimulates more outer calf growth'),
  "out": Option({}, 'point toes out, stimulates more inner calf growth'),
  "alternating": Option(
    {},
    'alternate between in and out between sets. might stimulate more growth [jeff nippard video](https://www.youtube.com/shorts/baEXLy09Ncc)',
  ),
}, desc: "  [Research paper](https://pubmed.ncbi.nlm.nih.gov/32735428/)");

const gripSqueeze = Tweak('grip squeeze', 'normal', {
  'normal': Option({}, 'only as hard as needed to maintain grip'),
  'extra': Option({}, 'squeezing hands tighter might stimulate more (fore)arm growth'),
  'max': Option({}, 'squeeze as hard as possible to maximally emphasize (fore)arms'),
});

const legExtensionPullOnHandles = Tweak('pull on handles', 'no', {
  'yes': Option(
    {},
    "pull on the handles to maybe get more tension on the quads.  [It's also Jeff Nippard's number 1 leg extension tip](https://www.instagram.com/jeffnippard/reel/CvUz7JyIMtQ/i-meant-to-say-pull-yourself-down-by-pulling-up-on-the-handles-my-badmy-number-1/)",
  ),
  'no': Option({}, ''),
});

const benchPressBenchAngle = Tweak(
  'bench angle',
  '0',
  {
    '-30': Option({}, 'aka 30° decline.'),
    '-15': Option({}, 'aka 15° decline.'),
    '0': Option({}, 'aka flat bench'),
    '15': Option({}, 'aka 15° incline.'),
    '30': Option({}, 'aka 30° incline.'),
    '45': Option({}, 'aka 45° incline.'),
  },
  desc: '''
* Flat bench should stimulate lower & mid pecs well, and upper pecs relatively well.
* Incline angles may recruit a bit more upper pecs without affecting lower/mid pec recruitment.
* Decline angles are unlikely to be beneficial.

Therefore, an incline is usually the best option for stimulating all pecs well, but the exact angle is up
to personal anatomy and preference.

For machine presses with a seat, estimate the incline/decline.
''',
);
const bpGrip = Tweak('grip', 'normal', {
  'narrow': Option({}, 'aka close grip'),
  'normal': Option({}, 'standard grip'),
  'wide': Option({
    ProgramGroup.lowerPecs: Assign(0.5, "lower reliance on horizontal shoulder flexion"),
    ProgramGroup.tricepsMedLatH: Assign(0.5), // when hands outside elbows, reduce tricepsMedLatH
  }, 'wide grip'),
});
const flyThumbs = Tweak('thumbs', 'up', {
  'up': Option({
    ProgramGroup.lowerPecs: Assign(1, 'full ROM horizontal shoulder adduction'),
    ProgramGroup.upperPecs: Assign(1, 'full ROM horizontal shoulder adduction'),
    ProgramGroup.frontDelts: Assign(0.5, 'full ROM horizontal shoulder adduction (weak)'),
  }, 'shoulder externally rotated, recruits front delts less'),
  'forward': Option({
    ProgramGroup.lowerPecs: Assign(1, 'full ROM horizontal shoulder flexion'),
    ProgramGroup.upperPecs: Assign(1, 'full ROM horizontal shoulder flexion'),
    ProgramGroup.frontDelts: Assign(1, 'full ROM horizontal shoulder flexion'),
  }, 'shoulders internally rotated, recruits front delts more'),
});

const legCurlAnkleDorsiflexed = Tweak(
  'ankle dorsiflexed',
  'no',
  {
    'yes': Option({ProgramGroup.gastroc: Assign(1, 'medium to long length knee flexion')}, ''),
    'no': Option({}, ''),
  },
  desc: '''
* Study: [Different Knee and Ankle Positions Affect Force and Muscle Activation During Prone Leg Curl in Trained Subjects](https://pubmed.ncbi.nlm.nih.gov/31469769/)
* Study: [Differential effects of ankle position on isokinetic knee extensor and flexor strength gains during strength training](https://journals.sagepub.com/doi/10.3233/IES-160617)
* [Menno Henselmans breaks it down on instagram](https://www.instagram.com/menno.henselmans/p/DBWTmsmRyji/)''',
);

const legCurlHipFlexion = Tweak(
  'hip flexion',
  'yes',
  {
    'yes': Option({
      ProgramGroup.hamsShortHead: Assign(1, 'full length'),
      ProgramGroup.hams: Assign(1, 'medium to long length knee flexion'),
    }, ''),
    'no': Option({
      ProgramGroup.hamsShortHead: Assign(1, 'full length'),
      ProgramGroup.hams: Assign(1, 'knee flexion (short to medium length)'),
    }, ''),
  },
  desc: '''Flexing the hip stretches the hamstrings and results in higher growth stimulus.  
        Study: [Greater Hamstrings Muscle Hypertrophy but Similar Damage Protection after Training at Long versus Short Muscle Lengths](https://pubmed.ncbi.nlm.nih.gov/33009197/)
''',
);

/*
NOTE: for now, we don't have different programgroups for upper/lower back, that would be a good use case here
*/
const squatPowerLiftBarPlacement = Tweak(
  'bar placement',
  'high back',
  {
    'high back': Option({}, 'bar rests on upper traps, shoulders'),
    'mid back': Option({}, 'bar rests on middle traps'),
    'low back': Option({}, 'bar rests on rear deltoids below spine of scapula'),
  },
  desc: '''
Most people are stronger, the lower the bar placement. Therefore the low back bar placement is often used in powerlifting.
The higher the bar placement, the less weight you need and the more you can target the back, in particular the upper back.
''',
);

const squatBarPlacement = Tweak(
  'bar placement',
  'high back',
  {
    'front': Option({}, 'bar rests on front deltoids and clavicles'),
    'safety bar': Option(
      {},
      'special bar that shifts load up & forward. [see this insta](https://www.instagram.com/menno.henselmans/p/C8hUNGhuZ3C/?img_index=1)',
    ),
    'high back': Option({}, 'bar rests on upper traps, shoulders'),
    'mid back': Option({}, 'bar rests on middle traps'),
    'low back': Option({}, 'bar rests on rear deltoids below spine of scapula'),
  },
  desc: '''
Most people are stronger, the lower the bar placement. Therefore the low back bar placement is often used in powerlifting.
The higher the bar placement, the less weight you need and the more you can target the back, in particular the upper back.
''',
);

const bsqRearLeg = Tweak('rear leg', 'for balance', {
  'for balance': Option({}, 'for stability. no contraction. Most coaches recommend this'),
  'active': Option(
    {ProgramGroup.quadsRF: Assign(1, 'knee extension while stretched (rear leg)')},
    '''rear leg actively pushes and contributes to the movement.  
  Great way to train the Rectus Femoris quadricep. (which is typically neglected in squats).  
  this style is less common, but Menno Henselmans recommends it. I (Dieter) do too.''',
  ),
});

const hipExtensionKneeFlexion = Tweak('knee flexion', 'no', {
  'yes': Option({
    ProgramGroup.quadsVasti: Assign(0.5, 'knee extension during hip extension'),
  }, 'adds 0.5 quadriceps recruitment'),
  'no': Option({
    ProgramGroup.quadsVasti: Assign(0.15, 'knee extension during hip extension'),
  }, 'very minor quadriceps recruitment'),
}, desc: 'Whether the movement involves knee flexion (and extension)');

const legExtensionLean = Tweak(
  'lean',
  'upright',
  {
    'upright': Option({
      ProgramGroup.quadsRF: Assign(0.25, 'knee extension, short length to active insufficency'),
    }, ''),
    'back': Option({
      ProgramGroup.quadsRF: Assign(1.0, 'knee extension, medium to long length'),
    }, ''),
  },
  desc: '''leaning back stretches the Rectus Femoris and triggers more growth.  
See this RCT: [The effects of hip flexion angle on quadriceps femoris muscle hypertrophy in the leg extension exercise](https://pubmed.ncbi.nlm.nih.gov/39699974/)

Menno Henselmans clarifies this study:
* [in this instagram post](https://www.instagram.com/menno.henselmans/p/DF2zq9sTWdo/?img_index=1)
* [and in this one](https://www.instagram.com/menno.henselmans/p/C7O6ydlR7qV/?img_index=1)
''',
);

const squatLowerLegMovement = Tweak('lower leg movement', 'still', {
  'still': Option({
    // assume no soleus contribution
    // Note: in menno's sheet, he still counts soleus 0.25 - not sure why -
    // but such a low value is below threshold anyway
  }, 'soleus inactive'),
  'back and forth': Option({
    ProgramGroup.soleus: Assign(0.5, 'ankle plantarflexion in limited ROM'),
  }, 'soleus contributes to the movement (0.5 recruitment)'),
});

const deficit = Tweak(
  'deficit',
  'no',
  {'max': Option({}, ''), 'small': Option({}, ''), 'no': Option({}, '')},
  desc: '''Whether the exercise is performed without a deficit, with a small or large/max deficit.  
Does not affect recruitment, but increases ROM and probably gains''',
);

Tweak lateralRaiseShoulderRotation = const Tweak(
  'wrist position',
  'pinkie up',
  {
    'pinkie up': Option({
      ProgramGroup.frontDelts: Assign(
        0.25,
        'deactivation from shoulder abduction (due to internal rotation)',
      ),
    }, ''),
    'horizontal': Option({ProgramGroup.frontDelts: Assign(0.75, 'shoulder abduction')}, ''),
    'pinkie down': Option({
      ProgramGroup.frontDelts: Assign(1, 'shoulder abduction (externally rotated)'),
    }, ''),
  },
  desc:
      """The more you internally rotate the shoulder (raise the pinkie), the less you activate the front delts and focus on side delts.  
[Dr Mike recommends considering your shoulder comfort](https://www.youtube.com/watch?v=n5dsI9qQXwY&t=4m34s)
        """,
);

Tweak lateralRaiseCablePath = const Tweak(
  'cable path',
  'in front',
  {
    'in front': Option({
      ProgramGroup.rearDelts: Assign(1, 'transverse extension'),
      ProgramGroup.frontDelts: Assign(0.5, 'shoulder flexion'),
    }, 'biases more towards rear delts'),
    'behind': Option({
      ProgramGroup.frontDelts: Assign(1, 'shoulder flexion'),
      ProgramGroup.rearDelts: Assign(0.5, 'transverse extension'),
    }, 'biases more towards front delts'),
  },
  desc:
      'See [this youtube short by The Modern Meathead](https://www.youtube.com/shorts/jc900Wb-bCY)',
);
/*
TODO: Tweak lateralRaiseCableAttach = const Tweak(
  'cable attachment point',

  )
    
  https://www.instagram.com/reel/DJoPgCxxVtV/?igsh=dDBtdzh1aXQ1ZjVq
  cable position: Closer to shoulder makes it easier, closer to hand makes it harder
  */
/*
https://www.youtube.com/watch?v=n5dsI9qQXwY&t=2m13s

ROM:
to just below pararrel - if you have sensitive shoulders. no problem, can get stimulus
to paralel - probably a bit better
to above parrallel - shoulder pump , high contraction
way up - lose some tension at the top, but higher contraction. if shoulder can take it

3:25 include bottom 45 degrees or no - to keep tension

4:34 hand position

5:20 pauses at the top for increased MMC
*/

Tweak hipAbductionHipFlexion(String defaultValue) => Tweak(
  'hip flexion angle',
  defaultValue,
  {
    '0': const Option({
      ProgramGroup.gluteMax: Assign(0.25, 'hip abduction at 0° hip flexion (upper fibers)'),
      ProgramGroup.gluteMed: Assign(1.0, 'hip abduction at 0° hip flexion'),
    }, ''),
    '15': const Option({
      ProgramGroup.gluteMax: Assign(0.375, 'hip abduction at 15° hip flexion (upper fibers)'),
      ProgramGroup.gluteMed: Assign(0.917, 'hip abduction at 15° hip flexion'),
    }, ''),
    '30': const Option({
      ProgramGroup.gluteMax: Assign(0.5, 'hip abduction at 30° hip flexion (upper fibers)'),
      ProgramGroup.gluteMed: Assign(0.833, 'hip abduction at 30° hip flexion'),
    }, ''),
    '45': const Option({
      ProgramGroup.gluteMax: Assign(0.625, 'hip abduction at 45° hip flexion (upper fibers)'),
      ProgramGroup.gluteMed: Assign(0.75, 'hip abduction at 45° hip flexion (upper fibers)'),
    }, ''),
    '60': const Option({
      ProgramGroup.gluteMax: Assign(0.75, 'hip abduction at 60° hip flexion (upper fibers)'),
      ProgramGroup.gluteMed: Assign(0.667, 'hip abduction at 60° hip flexion'),
    }, ''),
    '75': const Option({
      ProgramGroup.gluteMax: Assign(0.875, 'hip abduction at 75° hip flexion (upper fibers)'),
      ProgramGroup.gluteMed: Assign(0.583, 'hip abduction at 75° hip flexion'),
    }, ''),
    '90': const Option({
      ProgramGroup.gluteMax: Assign(1.0, 'hip abduction at 90° hip flexion (upper fibers)'),
      ProgramGroup.gluteMed: Assign(0.5, 'hip abduction at 90° hip flexion'),
    }, ''),
  },
  desc: '''Relevant:
* 2014 study: [Hip Muscle Activity during Isometric Contraction of Hip Abduction](https://pmc.ncbi.nlm.nih.gov/articles/PMC3944285/)
* [Menno Henselmans breakdown of a 2024 study](https://www.instagram.com/menno.henselmans/p/DFxp8jezDfj/?img_index=1)
''',
);

const Tweak dbCurlGrip = Tweak('grip', 'hammer to supinated', {
  'supinated': Option({}, 'supinated grip throughout the entire movement, aka underhand'),
  'hammer': Option({}, 'aka neutral grip throughout the entire movement'),
  'hammer to supinated': Option(
    {},
    'the bicep is a supinator. this adds a slightly higher demand on the bicep and is therefore the most commonly recommended form. see [form instruction](https://www.youtube.com/watch?v=ykJmrZ5v0Oo), aka neutral to underhand',
  ),
  'hammer to supinated, inside heavier': Option(
    {},
    'grip the dumbbell on the outside, or use a custom dumbbell with more weight on the inside. The loaded supination exercises the bicep better (Arnold does this!), aka neutral to underhand with inside heavier',
  ),
});

const Tweak cableCurlStyle = Tweak('style', 'standard', {
  'standard': Option({}, 'bar grip, face the cable stack. arms to the side'),
  'bayesian': Option(
    {},
    'original "bayesian" cable curl. face away from the cable stack. arms to the side, move upper body such that cable always provides max tension throughout ROM. [in-depth article by menno henselmans](https://mennohenselmans.com/bayesian-curls/). As a unilateral movement, it takes more time',
  ),
  'bayesian with arms behind': Option(
    {},
    'unlike the original bayesian curl, keep arms behind and torso rigid. Jeff Nippard uses this form. claims it keeps even tension throughout ROM, but it doesn\'t, actually. But can be done with both arms at the same time',
  ),
  'bayesian with arms behind and up': Option(
    {},
    'more extreme version of bayesian with arms behind. extreme tension at the longest length. can also be done with both arms',
  ),
});

const treadAngle = Tweak(
  'treadmill angle',
  '0',
  {
    // TODO: express this as a simple range? and better UI
    '0': Option({}, 'aka horizontal'),
    '3': Option({}, 'aka 3° incline.'),
    '5': Option({}, 'aka 5° incline.'),
    '7': Option({}, 'aka 7° incline.'),
    '10': Option({}, 'aka 10° incline.'),
    '12': Option({}, 'aka 12° incline.'),
    '15': Option({}, 'aka 15° incline.'),
  },
  desc: '''
Steeper results in more muscle activation but requires better fitness
''',
);

const treadDirection = Tweak(
  'treadmill direction',
  'forward',
  {'forward': Option({}, 'forward'), 'backward': Option({}, 'backward')},
  desc: '''
According to "Knees over toes guys", backward walking has many benefits e.g. for knee and foot health.
See [his TikTok video](https://www.tiktok.com/@kneesovertoesguy/video/7297641158753258795?)
''',
);
const legRaiseProgression = Tweak('difficulty', 'legs straight', {
  'legs straight': Option({}, 'hardest'),
  'bent knee 90°': Option({}, 'easy. aka knee raise'),
  'bent knee 135°': Option({}, 'medium'),
});
const crunchBenchAngle = Tweak('bench angle', '0', {
  '-40': Option({}, 'aka 30° decline.'),
  '-30': Option({}, 'aka 30° decline.'),
  '-15': Option({}, 'aka 15° decline.'),
  '0': Option({}, 'aka flat bench'),
  '15': Option({}, 'aka 15° incline.'),
  '30': Option({}, 'aka 30° incline.'),
  '45': Option({}, 'aka 45° incline.'),
});

const dipBodyPosition = Tweak('body position', 'lean forward', {
  'lean forward': Option({}, 'more chest focus'),
  'lean forward with legs forward': Option({}, 'most chest focus'),
  'neutral': Option({}, 'more tricep focus. keep elbows tucked. aka tricep dip'),
});
const frontRaiseLoading = Tweak('loading', 'dumbbell', {
  'barbell': Option({}, 'barbell', equipment: Equipment.barbell),
  'cable': Option({}, 'cable', equipment: Equipment.cableTower),
  'dumbbell': Option({}, 'dumbbell', equipment: Equipment.dumbbell),
  'elastic band': Option({}, 'elastic band', equipment: Equipment.elastic),
  'ez-bar': Option({}, 'ez-bar', equipment: Equipment.ezbar),
  'kettlebell': Option({}, 'kettlebell', equipment: Equipment.kettlebell),
  'plate': Option({}, 'plate', equipment: Equipment.plate),
});
const frontRaiseBodyPosition = Tweak('body position', 'standing', {
  'standing': Option({}, 'standing'),
  'seated': Option({}, 'seated'),
  'prone at 45 incline': Option({}, 'chest supported on bench at 45 incline (contraction focus)'),
  'supine at 70 incline': Option({}, 'back supported on bench at 70 incline (stretch focus) '),
});
const frontRaiseGrip = Tweak('grip', 'pronated', {
  'supinated': Option({
    ProgramGroup.sideDelts: Assign(0, 'shoulder flexion when shoulder externally rotated'),
    ProgramGroup.wristFlexors: Assign(0.3, 'isometric'),
  }, 'underhand grip, palms down'),
  'pronated': Option({
    ProgramGroup.sideDelts: Assign(0.5, "shoulder flexion when shoulder internally rotated"),
    ProgramGroup.wristExtensors: Assign(0.3, 'isometric'),
  }, 'overhand grip, palms up'),
  'neutral': Option({
    ProgramGroup.sideDelts: Assign(0.25, 'shoulder flexion when shoulder externally rotated'),
  }, 'hammer grip, palms facing outward'),
});
