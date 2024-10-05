import 'package:ptc/backend/articulations.dart';
import 'package:ptc/backend/bones.dart';
import 'package:ptc/backend/movements.dart';
import 'package:ptc/backend/muscles.dart';

final abdominals = MultiHeadMuscle(
    nick: ['abs'],
    insertion: Bone.pelvis, // TODO this is wrong. see insertions below
    movements: [],
    heads: {
      'rectus abdominis': const Head(
        nick: ['sixpack'],
        movements: [
          Movement(
            articulation: Articulation.spinalFlexion,
            strength: 4,
            rangeStart: 0,
            rangeEnd: 85,
          ),
          Movement(
            articulation: Articulation.intraAbdominalPressure,
            strength: 4,
          ),
        ],
        name: 'rectus abdominis',
        // inserts into sternum
        origin: [Bone.pelvis, Bone.pubicCrest],
      ),
      // lateral
      'external obliques': const Head(
        movements: [
          Movement(
            articulation: Articulation.spinalFlexion,
            strength: 4,
            rangeStart: 0,
            rangeEnd: 85,
          ),
          Movement(
            articulation: Articulation.spinalLateralFlexion,
            strength: 4,
            rangeStart: 0,
            rangeEnd: 40,
          ),
          Movement(
            articulation: Articulation.spinalRotation,
            strength: 2,
            rangeStart: 0,
            rangeEnd: 40,
          ),
          Movement(
            articulation: Articulation.intraAbdominalPressure,
            strength: 6,
          ),
        ],
        name: 'external obliques',
        // insert into iliciac Crest, pubic crest
        origin: [Bone.lowerRibs],
      ),
      // inner & invisible
      'internal obliques': const Head(
        movements: [],
        name: 'internal obliques',
        origin: [Bone.spine],
      ),
      // inner & invisible
      'transverse abdominis': const Head(
        movements: [],
        name: 'transverse abdominis',
        origin: [Bone.spine],
      )
    });
