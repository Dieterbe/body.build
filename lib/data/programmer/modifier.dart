import 'package:bodybuild/data/programmer/groups.dart';

/*
- If it's a different machine , it's a different exercise, is a valid way. Other way would be valid too. Comes down to preference I guess
- Sometimes the type of machine / equipment affects the modifiers (although i don't remember the exercise for which this was the case). Doing everything as modifiers would complicate things
- I guess it make sense that main equipment constitutes different exercise, modifiers are more for small tweaks
*/
class Modifier {
  final String name;
  final String defaultVal;
  final Map<String, Map<ProgramGroup, Assign>> opts;
  final String? desc;

  Modifier(this.name, this.defaultVal, this.opts, {this.desc});
}

final legCurlAnkleDorsiflexed = Modifier(
    'ankle dorsiflexed',
    'no',
    {
      'yes': {
        ProgramGroup.gastroc:
            const Assign(1, 'medium to long length knee flexion')
      },
      'no': {},
    },
    desc:
        '[for the instagram lovers](https://www.instagram.com/menno.henselmans/p/DBWTmsmRyji/)');
/*
NOTE: for now, we don't have different programgroups for upper/lower back, that would be a good use case here
*/
final squatBarPlacement = Modifier('bar placement', 'high back', {
  'front': {},
  'safety bar': {},
  'high back': {},
  'mid back': {},
  'low back': {},
}, desc: '''Bar placement options for squats:

* Front: bar rests on front deltoids and clavicles
* Safety bar: [special bar that shifts load up & forward](https://www.instagram.com/menno.henselmans/p/C8hUNGhuZ3C/?img_index=10)
* High back: bar rests on upper traps, shoulders
* Mid back: bar rests on middle traps
* Low back: bar rests on rear deltoids below spine of scapula

Most people are stronger, the lower the bar placement. Therefore the low back bar placement is often used in powerlifting.
The higher the bar placement, the less weight you need and the more you can target the back, in particular the upper back.
''');

final bsqRearLeg = Modifier('rear leg', 'for balance', {
  'for balance': {},
  'active': {
    ProgramGroup.quadsRF:
        const Assign(1, 'knee extension while stretched (rear leg)'),
  },
}, desc: '''How the rear leg is used in the Bulgarian split squat:

* For balance: rear leg only used for balance/stability
* Active: rear leg actively pushes and contributes to the movement.  
  A Great way to train the Rectus Femoris quadricep. (which is typically neglected in squats).  
  this style is less common, but Menno Henselmans recommends it. I (Dieter) do too.
''');

final hipExtensionKneeFlexion = Modifier('knee flexion', 'no', {
  'yes': {
    ProgramGroup.quadsVasti:
        const Assign(0.5, 'knee extension during hip extension'),
  },
  'no': {
    ProgramGroup.quadsVasti:
        const Assign(0.15, 'knee extension during hip extension'),
  },
}, desc: '''Whether the movement involves knee flexion (and extension):

* Yes: adds 0.5 quadriceps recruitment
* No: very minor quadriceps recruitment
''');

final legExtensionLean = Modifier('lean', 'upright', {
  'upright': {
    ProgramGroup.quadsRF: const Assign(
        0.25, 'knee extension, short length to active insufficency'),
  },
  'back': {
    ProgramGroup.quadsRF:
        const Assign(1.0, 'knee extension, medium to long length'),
  },
},
    desc:
        '''see [this instagram post by Menno Henselmans](https://www.instagram.com/menno.henselmans/p/DF2zq9sTWdo/?img_index=1) which explains the study.
or [this one](https://www.instagram.com/menno.henselmans/p/C7O6ydlR7qV/?img_index=1)
''');

final squatLowerLegMovement = Modifier('lower leg movement', 'still', {
  'still': {
    // assume no soleus contribution
    // Note: in menno's sheet, he still counts soleus 0.25 - not sure why -
    // but such a low value is below threshold anyway
  },
  'back & forth': {
    ProgramGroup.soleus:
        const Assign(0.5, 'ankle plantarflexion in limited ROM'),
  },
}, desc: '''Whether the lower leg moves during the exercise:

* Still: leg does not move: soleus inactive
* Back & forth: leg moves back and forth: soleus contributes to the movement
''');

final deficit = Modifier('deficit', 'no', {
  'max': {},
  'small': {},
  'no': {},
},
    desc:
        '''Whether the exercise is performed without a deficit, with a small or large/max deficit.  
Does not affect recruitment, but increases ROM and probably gains''');

Modifier lateralRaiseShoulderRotation = Modifier(
    'wrist position',
    'pinkie up',
    {
      'pinkie up': {
        ProgramGroup.frontDelts: const Assign(0,
            'deactivation from shoulder abduction (due to internal rotation)'),
      },
      'horizontal': {
        ProgramGroup.frontDelts: const Assign(0.5, 'shoulder abduction'),
      },
      'pinkie down': {
        ProgramGroup.frontDelts:
            const Assign(0.75, 'shoulder abduction (externally rotated)'),
      },
    },
    desc:
        'The more you internally rotate the shoulder (raise the pinkie), the less you activate the front delts.');

Modifier lateralRaiseCablePath = Modifier('cable path', 'in front', {
  'in front': {
    ProgramGroup.rearDelts: const Assign(0.25, 'transverse extension'),
  },
  'behind': {
    ProgramGroup.frontDelts: const Assign(0.25, 'shoulder flexion'),
  }
},
    desc:
        '''Holding the cable in front biases more towards the rear delts, whereas the cable behind the body biases more towards the front delts
See [this youtube short](https://www.youtube.com/shorts/jc900Wb-bCY)''');

Modifier hipAbductionHipFlexion(String defaultValue) => Modifier(
      'hip flexion',
      defaultValue,
      {
        '0°': {
          ProgramGroup.gluteMax: const Assign(
              0.25, 'hip abduction at 0° hip flexion (upper fibers)'),
          ProgramGroup.gluteMed:
              const Assign(1.0, 'hip abduction at 0° hip flexion'),
        },
        '15°': {
          ProgramGroup.gluteMax: const Assign(
              0.375, 'hip abduction at 15° hip flexion (upper fibers)'),
          ProgramGroup.gluteMed:
              const Assign(0.917, 'hip abduction at 15° hip flexion'),
        },
        '30°': {
          ProgramGroup.gluteMax: const Assign(
              0.5, 'hip abduction at 30° hip flexion (upper fibers)'),
          ProgramGroup.gluteMed:
              const Assign(0.833, 'hip abduction at 30° hip flexion'),
        },
        '45°': {
          ProgramGroup.gluteMax: const Assign(
              0.625, 'hip abduction at 45° hip flexion (upper fibers)'),
          ProgramGroup.gluteMed: const Assign(
              0.75, 'hip abduction at 45° hip flexion (upper fibers)'),
        },
        '60°': {
          ProgramGroup.gluteMax: const Assign(
              0.75, 'hip abduction at 60° hip flexion (upper fibers)'),
          ProgramGroup.gluteMed:
              const Assign(0.667, 'hip abduction at 60° hip flexion'),
        },
        '75°': {
          ProgramGroup.gluteMax: const Assign(
              0.875, 'hip abduction at 75° hip flexion (upper fibers)'),
          ProgramGroup.gluteMed:
              const Assign(0.583, 'hip abduction at 75° hip flexion'),
        },
        '90°': {
          ProgramGroup.gluteMax: const Assign(
              1.0, 'hip abduction at 90° hip flexion (upper fibers)'),
          ProgramGroup.gluteMed:
              const Assign(0.5, 'hip abduction at 90° hip flexion'),
        },
      },
      desc: '''Relevant:
* 2014 study: [Hip Muscle Activity during Isometric Contraction of Hip Abduction](https://pmc.ncbi.nlm.nih.gov/articles/PMC3944285/)
* [Menno Henselmans breakdown of a 2024 study](https://www.instagram.com/menno.henselmans/p/DFxp8jezDfj/?img_index=1)
''',
    );
