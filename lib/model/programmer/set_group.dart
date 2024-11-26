import 'package:ptc/data/programmer/exercises.dart';
import 'package:ptc/data/programmer/groups.dart';

// represents a single set with its properties
class Sets {
  Ex? ex;
  bool changeEx;
  int n;
  int intensity;

  Sets(this.intensity, {this.ex, this.n = 1, this.changeEx = false});

  Sets copyWith({Ex? ex, int? n, int? intensity, bool? changeEx}) {
    return Sets(
      intensity ?? this.intensity,
      ex: ex ?? this.ex,
      n: n ?? this.n,
      changeEx: changeEx ?? this.changeEx,
    );
  }

  @override
  String toString() {
    return "Set(int=$intensity, n=$n, changeEx=$changeEx, ex=${ex?.id})";
  }

  double recruitment(ProgramGroup pg, double cutoff) {
    if (ex == null) return 0.0;
    final r = ex!.recruitment(pg);
    return (r >= cutoff) ? r * n : 0.0;
  }
}

// represents a group of sets (e.g. a comboset or circuit)
class SetGroup {
  final List<Sets> sets;
  SetGroup(this.sets);

  SetGroup copyWith({List<Sets>? sets}) {
    return SetGroup(sets ?? this.sets);
  }

  @override
  String toString() {
    return "SetGroup(sets=${sets.map((s) => s.toString()).join(', ')})";
  }
}
