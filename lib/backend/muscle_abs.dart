import 'package:ptc/backend/articulations.dart';
import 'package:ptc/backend/bones.dart';
import 'package:ptc/backend/movements.dart';
import 'package:ptc/backend/muscles.dart';

final abdominals = Muscle(
    nick: ['abs'],
    pseudo: false,
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
        articular: 1,
        // inserts into sternum
        origin: [Bone.pelvis, Bone.pubicCrest],
      ),
      // lateral
      'external obliques': const Head(
        nick: [],
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
        articular: 1,
        // insert into iliciac Crest, pubic crest
        origin: [Bone.lowerRibs],
      ),
      // inner & invisible
      'internal obliques': const Head(
        nick: [],
        movements: [],
        name: 'internal obliques',
        articular: 1,
        origin: [Bone.spine],
      ),
      // inner & invisible
      'transverse abdominis': const Head(
        nick: [],
        movements: [],
        name: 'transverse abdominis',
        articular: 1,
        origin: [Bone.spine],
      )
    });
