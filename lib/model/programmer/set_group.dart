import 'package:bodybuild/data/programmer/exercises.dart';
import 'package:bodybuild/data/programmer/groups.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'set_group.freezed.dart';
part 'set_group.g.dart';

@freezed
class Sets with _$Sets {
  const Sets._(); // to support custom methods
  const factory Sets(
    int intensity, {
    @JsonKey(
      toJson: _exToJson,
      fromJson: _exFromJson,
    )
    Ex? ex,
    @Default(1) int n,
    @JsonKey(includeToJson: false) @Default(false) bool changeEx,
    @Default({})
    Map<String, String>
        modifierOptions, // Map of modifier name to selected option
    @Default({})
    Map<String, bool> cueOptions, // Map of cue name to enabled state
  }) = _Sets;

  factory Sets.fromJson(Map<String, dynamic> json) => _$SetsFromJson(json);

  double recruitmentFiltered(ProgramGroup pg, double cutoff) {
    if (ex == null) return 0.0;
    return ex!.recruitmentFiltered(pg, modifierOptions, cutoff).volume * n;
  }

// note: this isn't quite the same as programgroups.
// e.g. lower pecs, upper pecs are counted as one, gastroc and soleus are counted as one, etc
  int? involvedMuscleGroups() {
    if (ex == null) return null;

    // Get all unique non-null isolationKeys from ProgramGroups with significant recruitment
    final img = ProgramGroup.values
        .where((pg) =>
            ex!.recruitmentFiltered(pg, modifierOptions, 0.5).volume > 0)
        .map((pg) => pg.isolationKey)
        .toSet();

    // this is a bit of a hack.  see the docs for [pg.isolationKey]
    if (img.length == 1 && img.first == 'forearm') {
      return 1;
    }
    if (img.contains('forearm')) {
      return img.length - 1;
    }
    return img.length;
  }
}

String? _exToJson(Ex? ex) => ex?.id;

Ex? _exFromJson(String? id) {
  if (id == null) return null;
  try {
    return exes.firstWhere((e) => e.id == id);
  } catch (e) {
    print('could not find exercise $id - this should never happen');
    return null;
  }
}

@freezed
class SetGroup with _$SetGroup {
  const factory SetGroup(
    List<Sets> sets,
  ) = _SetGroup;

  factory SetGroup.fromJson(Map<String, dynamic> json) =>
      _$SetGroupFromJson(json);
}
