import 'package:bodybuild/data/programmer/groups.dart';
import 'package:bodybuild/data/programmer/volume_assignment.dart';

/*
- If it's a different machine , it's a different exercise, is a valid way. Other way would be valid too. Comes down to preference I guess
- Sometimes the type of machine / equipment affects the tweaks (e.g. for BSQ with dumbbells or smith allows symmetrical vs assymetrical loading, barbell does not). Doing everything as tweaks would complicate things
- I guess it make sense that main equipment constitutes different exercise, tweaks are more for small tweaks
*/
typedef Option = (VolumeAssignment va, String desc);

class Tweak {
  final String name;
  final String defaultVal;
  final Map<String, Option> opts;
  final String? desc;

  const Tweak(this.name, this.defaultVal, this.opts, {this.desc});
}

const benchPressBenchAngle = Tweak(
  'bench angle',
  '0',
  {
    '-30': ({}, '30° decline.'),
    '-15': ({}, '15° decline.'),
    '0': ({}, 'flat bench'),
    '15': ({}, '15° incline.'),
    '30': ({}, '30° incline.'),
    '45': ({}, '45° incline.'),
  },
  desc: '''
* Flat bench should stimulate lower & mid pecs well, and upper pecs relatively well.
* Incline angles may recruit a bit more upper pecs without affecting lower/mid pec recruitment.
* Decline angles are unlikely to be beneficial.

Therefore, an incline is usually the best option for stimulating all pecs well, but the exact angle is up
to personal anatomy and preference.
''',
);
const flyThumbs = Tweak('thumbs', 'up', {
  'up': (
    {
      ProgramGroup.lowerPecs: Assign(1, 'full ROM horizontal shoulder adduction'),
      ProgramGroup.upperPecs: Assign(1, 'full ROM horizontal shoulder adduction'),
      ProgramGroup.frontDelts: Assign(0.5, 'full ROM horizontal shoulder adduction (weak)'),
    },
    'shoulder externally rotated, recruits front delts less',
  ),
  'forward': (
    {
      ProgramGroup.lowerPecs: Assign(1, 'full ROM horizontal shoulder flexion'),
      ProgramGroup.upperPecs: Assign(1, 'full ROM horizontal shoulder flexion'),
      ProgramGroup.frontDelts: Assign(1, 'full ROM horizontal shoulder flexion'),
    },
    'shoulders internally rotated, recruits front delts more',
  ),
});

const legCurlAnkleDorsiflexed = Tweak(
  'ankle dorsiflexed',
  'no',
  {
    'yes': ({ProgramGroup.gastroc: Assign(1, 'medium to long length knee flexion')}, ''),
    'no': ({}, ''),
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
    'yes': (
      {
        ProgramGroup.hamsShortHead: Assign(1, 'full length'),
        ProgramGroup.hams: Assign(1, 'medium to long length knee flexion'),
      },
      '',
    ),
    'no': (
      {
        ProgramGroup.hamsShortHead: Assign(1, 'full length'),
        ProgramGroup.hams: Assign(1, 'knee flexion (short to medium length)'),
      },
      '',
    ),
  },
  desc: '''Flexing the hip stretches the hamstrings and results in higher growth stimulus.  
        Study: [Greater Hamstrings Muscle Hypertrophy but Similar Damage Protection after Training at Long versus Short Muscle Lengths](https://pubmed.ncbi.nlm.nih.gov/33009197/)
''',
);

/*
NOTE: for now, we don't have different programgroups for upper/lower back, that would be a good use case here
*/
const squatBarPlacement = Tweak(
  'bar placement',
  'high back',
  {
    'front': ({}, 'bar rests on front deltoids and clavicles'),
    'safety bar': (
      {},
      'special bar that shifts load up & forward. [see this insta](https://www.instagram.com/menno.henselmans/p/C8hUNGhuZ3C/?img_index=1)',
    ),
    'high back': ({}, 'bar rests on upper traps, shoulders'),
    'mid back': ({}, 'bar rests on middle traps'),
    'low back': ({}, 'bar rests on rear deltoids below spine of scapula'),
  },
  desc: '''
Most people are stronger, the lower the bar placement. Therefore the low back bar placement is often used in powerlifting.
The higher the bar placement, the less weight you need and the more you can target the back, in particular the upper back.
''',
);

const bsqRearLeg = Tweak('rear leg', 'for balance', {
  'for balance': ({}, 'for stability. no contraction. Most coaches recommend this'),
  'active': (
    {ProgramGroup.quadsRF: Assign(1, 'knee extension while stretched (rear leg)')},
    '''rear leg actively pushes and contributes to the movement.  
  Great way to train the Rectus Femoris quadricep. (which is typically neglected in squats).  
  this style is less common, but Menno Henselmans recommends it. I (Dieter) do too.''',
  ),
});

const hipExtensionKneeFlexion = Tweak('knee flexion', 'no', {
  'yes': (
    {ProgramGroup.quadsVasti: Assign(0.5, 'knee extension during hip extension')},
    'adds 0.5 quadriceps recruitment',
  ),
  'no': (
    {ProgramGroup.quadsVasti: Assign(0.15, 'knee extension during hip extension')},
    'very minor quadriceps recruitment',
  ),
}, desc: 'Whether the movement involves knee flexion (and extension)');

const legExtensionLean = Tweak(
  'lean',
  'upright',
  {
    'upright': (
      {ProgramGroup.quadsRF: Assign(0.25, 'knee extension, short length to active insufficency')},
      '',
    ),
    'back': ({ProgramGroup.quadsRF: Assign(1.0, 'knee extension, medium to long length')}, ''),
  },
  desc: '''leaning back stretches the Rectus Femoris and triggers more growth.  
See this RCT: [The effects of hip flexion angle on quadriceps femoris muscle hypertrophy in the leg extension exercise](https://pubmed.ncbi.nlm.nih.gov/39699974/)

Menno Henselmans clarifies this study:
* [in this instagram post](https://www.instagram.com/menno.henselmans/p/DF2zq9sTWdo/?img_index=1)
* [and in this one](https://www.instagram.com/menno.henselmans/p/C7O6ydlR7qV/?img_index=1)
''',
);

const squatLowerLegMovement = Tweak('lower leg movement', 'still', {
  'still': (
    {
      // assume no soleus contribution
      // Note: in menno's sheet, he still counts soleus 0.25 - not sure why -
      // but such a low value is below threshold anyway
    },
    'soleus inactive',
  ),
  'back and forth': (
    {ProgramGroup.soleus: Assign(0.5, 'ankle plantarflexion in limited ROM')},
    'soleus contributes to the movement (0.5 recruitment)',
  ),
});

const deficit = Tweak(
  'deficit',
  'no',
  {'max': ({}, ''), 'small': ({}, ''), 'no': ({}, '')},
  desc: '''Whether the exercise is performed without a deficit, with a small or large/max deficit.  
Does not affect recruitment, but increases ROM and probably gains''',
);

Tweak lateralRaiseShoulderRotation = const Tweak(
  'wrist position',
  'pinkie up',
  {
    'pinkie up': (
      {
        ProgramGroup.frontDelts: Assign(
          0.25,
          'deactivation from shoulder abduction (due to internal rotation)',
        ),
      },
      '',
    ),
    'horizontal': ({ProgramGroup.frontDelts: Assign(0.75, 'shoulder abduction')}, ''),
    'pinkie down': (
      {ProgramGroup.frontDelts: Assign(1, 'shoulder abduction (externally rotated)')},
      '',
    ),
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
    'in front': (
      {
        ProgramGroup.rearDelts: Assign(1, 'transverse extension'),
        ProgramGroup.frontDelts: Assign(0.5, 'shoulder flexion'),
      },
      'biases more towards rear delts',
    ),
    'behind': (
      {
        ProgramGroup.frontDelts: Assign(1, 'shoulder flexion'),
        ProgramGroup.rearDelts: Assign(0.5, 'transverse extension'),
      },
      'biases more towards front delts',
    ),
  },
  desc:
      'See [this youtube short by The Modern Meathead](https://www.youtube.com/shorts/jc900Wb-bCY)',
);
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
  'hip flexion',
  defaultValue,
  {
    '0°': (
      {
        ProgramGroup.gluteMax: const Assign(0.25, 'hip abduction at 0° hip flexion (upper fibers)'),
        ProgramGroup.gluteMed: const Assign(1.0, 'hip abduction at 0° hip flexion'),
      },
      '',
    ),
    '15°': (
      {
        ProgramGroup.gluteMax: const Assign(
          0.375,
          'hip abduction at 15° hip flexion (upper fibers)',
        ),
        ProgramGroup.gluteMed: const Assign(0.917, 'hip abduction at 15° hip flexion'),
      },
      '',
    ),
    '30°': (
      {
        ProgramGroup.gluteMax: const Assign(0.5, 'hip abduction at 30° hip flexion (upper fibers)'),
        ProgramGroup.gluteMed: const Assign(0.833, 'hip abduction at 30° hip flexion'),
      },
      '',
    ),
    '45°': (
      {
        ProgramGroup.gluteMax: const Assign(
          0.625,
          'hip abduction at 45° hip flexion (upper fibers)',
        ),
        ProgramGroup.gluteMed: const Assign(
          0.75,
          'hip abduction at 45° hip flexion (upper fibers)',
        ),
      },
      '',
    ),
    '60°': (
      {
        ProgramGroup.gluteMax: const Assign(
          0.75,
          'hip abduction at 60° hip flexion (upper fibers)',
        ),
        ProgramGroup.gluteMed: const Assign(0.667, 'hip abduction at 60° hip flexion'),
      },
      '',
    ),
    '75°': (
      {
        ProgramGroup.gluteMax: const Assign(
          0.875,
          'hip abduction at 75° hip flexion (upper fibers)',
        ),
        ProgramGroup.gluteMed: const Assign(0.583, 'hip abduction at 75° hip flexion'),
      },
      '',
    ),
    '90°': (
      {
        ProgramGroup.gluteMax: const Assign(1.0, 'hip abduction at 90° hip flexion (upper fibers)'),
        ProgramGroup.gluteMed: const Assign(0.5, 'hip abduction at 90° hip flexion'),
      },
      '',
    ),
  },
  desc: '''Relevant:
* 2014 study: [Hip Muscle Activity during Isometric Contraction of Hip Abduction](https://pmc.ncbi.nlm.nih.gov/articles/PMC3944285/)
* [Menno Henselmans breakdown of a 2024 study](https://www.instagram.com/menno.henselmans/p/DFxp8jezDfj/?img_index=1)
''',
);

const Tweak dbCurlGrip = Tweak('grip', 'hammer to supinated', {
  'supinated': ({}, 'supinated grip throughout the entire movement'),
  'hammer': ({}, 'neutral grip throughout the entire movement'),
  'hammer to supinated': (
    {},
    'the bicep is a supinator. this adds a slightly higher demand on the bicep and is therefore the most commonly recommended form. see [form instruction](https://www.youtube.com/watch?v=ykJmrZ5v0Oo)',
  ),
  'hammer to supinated, inside heavier': (
    {},
    'grip the dumbbell on the outside, or use a custom dumbbell with more weight on the inside. The loaded supination exercises the bicep better (Arnold does this!)',
  ),
});

const Tweak cableCurlStyle = Tweak('style', 'standard', {
  'standard': ({}, 'bar grip, face the cable stack. arms to the side'),
  'bayesian': (
    {},
    'original "bayesian" cable curl. face away from the cable stack. arms to the side, move upper body such that cable always provides max tension throughout ROM. [in-depth article by menno henselmans](https://mennohenselmans.com/bayesian-curls/). As a unilateral movement, it takes more time',
  ),
  'bayesian with arms behind': (
    {},
    'unlike the original bayesian curl, keep arms behind and torso rigid. Jeff Nippard uses this form. claims it keeps even tension throughout ROM, but it doesn\'t, actually. But can be done with both arms at the same time',
  ),
  'bayesian with arms behind and up': (
    {},
    'more extreme version of bayesian with arms behind. extreme tension at the longest length. can also be done with both arms',
  ),
});
