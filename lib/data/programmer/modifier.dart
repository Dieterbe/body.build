import 'package:bodybuild/data/programmer/groups.dart';

class Modifier {
  final String name;
  final Map<String, Map<ProgramGroup, Assign>> opts;
  final String defaultValue;

  Modifier(this.name, this.opts, {required this.defaultValue});
}

final legCurlAnkleDorsiflexed = Modifier(
  'ankle dorsiflexed',
  {
    'yes': {
      ProgramGroup.gastroc:
          const Assign(1, 'medium to long length knee flexion')
    },
    'no': {},
  },
  defaultValue: 'no',
);

Modifier hipAbductionHipFlexion(String defaultValue) => Modifier(
      'hip flexion',
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
      defaultValue: defaultValue,
    );
