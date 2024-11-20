import 'package:ptc/data/programmer/exercises.dart';

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
}

// represents a group of sets (e.g. a comboset or circuit)
class SetGroup {
  final List<Sets> sets;
  SetGroup(this.sets);
}
