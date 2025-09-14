import 'dart:math';

import 'package:bodybuild/data/anatomy/articulations.dart';
import 'package:bodybuild/data/anatomy/muscles.dart';

// types of strength:
// "absolute" due to muscle length
// relative due to moment arm
// comparison to other muscles for a movement (so you know which muscles get trained)
// comparison to other movements for the same muscle (so you know how to train a muscle)
class Movement {
  const Movement({
    required this.articulation,
    // range is indicative , most people may have different range
    // flexions and abductions generally go from 0 to a high number. also rotations. pronation. supination. scapular movements. any transverse movements
    // and (non-transverse) extensions and adductions back from high number down to 0 (or minus) for hyperextension
    this.rangeStart,
    this.rangeEnd,
    this.momentMax,
    required this.strength,
  });
  final Articulation articulation;
  final int? rangeStart;
  final int? rangeEnd;
  final int? momentMax; // degrees of the movement for max moment
  // strength. this is not an "absolute scale". it's wrt to the max strength you can achieve for
  // the given movement (so the primary knee extensor and the primary wrist extensor would get the same score)
  // 1: trivial, 2: very weak, 3: weak, 4: moderate or unknown (!), 5: strong, 6: strongest
  // best practice: put a comment in words any time you set this parameter, to easy future refactors
  // primary function -> 5/6 (depends on other muscles if they're stronger)
  // secondary function -> 4/5 (depends on other muscles if they're stronger)
  final int strength;
}
// NOTE: degrees of supination and pronation come from:
// https://musculoskeletalkey.com/structure-and-function-of-the-elbow-and-forearm-complex/

// the result of compiling all movement information for any given articulation
class ArticulationMovements {
  final Articulation articulation;
  late List<MovementStruct> moves;

  late bool hasRange;
  late int rangeStart;
  late int rangeEnd;

  ArticulationMovements(this.articulation) {
    moves = _getMovements(articulation).toList();
    if (moves.isEmpty) {
      print('no moves found for $articulation - not doing further processing');
      hasRange = false;
      return;
    }
    for (var m in moves) {
      print(
          '${articulation.name} ${m.muscle.name} -> ${m.mo.rangeStart} - ${m.mo.momentMax} - ${m.mo.rangeEnd}');
    }
    final rangeStarts = moves.map((m) => m.mo.rangeStart).whereType<int>().toList();
    final rangeEnds = moves.map((m) => m.mo.rangeEnd).whereType<int>().toList();
    if (rangeStarts.isEmpty) {
      print('no rangeStarts found for $articulation');
      hasRange = false;
      return;
    }
    if (rangeEnds.isEmpty) {
      print('no rangeEnds found for $articulation');
      hasRange = false;
      return;
    }
    hasRange = true;
    // the movement could happen from a low value to a high, or vice versa
    // therefore, to figure out the full range, we must account for this

    final rangeStartMin = rangeStarts.fold(1000, min);
    final rangeStartMax = rangeStarts.fold(-1000, max);
    final rangeEndMax = rangeEnds.fold(-1000, max);
    final rangeEndMin = rangeEnds.fold(1000, min);
    if (rangeStartMin < rangeEndMin) {
      rangeStart = rangeStartMin;
      rangeEnd = rangeEndMax;
      return;
    }

    rangeStart = rangeStartMax;
    rangeEnd = rangeEndMin;
  }
  int get range => (rangeEnd - rangeStart).abs();

  List<MovementStruct> _getMovements(Articulation a) =>
      muscles.expand((mu) => mu.getMovements(a)).toList();
}
