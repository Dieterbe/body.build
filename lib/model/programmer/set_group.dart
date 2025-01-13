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
  }) = _Sets;

  factory Sets.fromJson(Map<String, dynamic> json) => _$SetsFromJson(json);

  double recruitmentFiltered(ProgramGroup pg, double cutoff) {
    if (ex == null) return 0.0;
    return ex!.recruitmentFiltered(pg, cutoff).volume * n;
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
