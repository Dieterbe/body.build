import 'package:ptc/data/programmer/exercises.dart';

// represents 1 or multiple straight sets with a given intensity
// for 1 specific exercise
class SetGroup {
  Ex? ex;
  bool changeEx;
  int n;
  int intensity;
  SetGroup(this.intensity, {this.ex, this.n = 1, this.changeEx = false});

  SetGroup copyWith({Ex? ex, int? n, int? intensity, bool? changeEx}) {
    return SetGroup(
      intensity ?? this.intensity,
      ex: ex ?? this.ex,
      n: n ?? this.n,
      changeEx: changeEx ?? this.changeEx,
    );
  }
}
