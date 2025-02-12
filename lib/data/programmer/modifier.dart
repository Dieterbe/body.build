import 'package:bodybuild/data/programmer/groups.dart';

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
);
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
