import 'package:bodybuild/data/programmer/groups.dart';

class Modifier {
  final String name;
  final String defaultVal;
  final Map<String, Map<ProgramGroup, Assign>> opts;

  Modifier(this.name, this.defaultVal, this.opts);
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

final legExtensionLean = Modifier(
  'lean',
  'upright',
  {
    'upright': {
      ProgramGroup.quadsRF: const Assign(
          0.25, 'knee extension, short length to active insufficency'),
    },
    'back': {
      ProgramGroup.quadsRF:
          const Assign(1.0, 'knee extension, medium to long length'),
    },
  },
);

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
    );
