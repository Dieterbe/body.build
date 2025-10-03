import 'package:bodybuild/data/programmer/exercises.dart';
import 'package:bodybuild/data/programmer/groups.dart';
import 'package:bodybuild/data/programmer/rating.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'set_group.freezed.dart';
part 'set_group.g.dart';

/// Migrates a map of tweak options
/// at some point we stopped allowing '&' in tweak options, so they encode easier into json
Map<String, String> migrateTweakOptions(Map<String, String> options) {
  return options.map((key, value) => MapEntry(key, value.replaceFirst('&', 'and')));
}

@freezed
abstract class Sets with _$Sets {
  const Sets._(); // to support custom methods
  const factory Sets(
    int intensity, {
    @JsonKey(toJson: _exToJson, fromJson: _exFromJson) Ex? ex,
    @Default(1) int n,
    @JsonKey(includeToJson: false) @Default(false) bool changeEx,
    @Default({}) Map<String, String> tweakOptions, // Map of tweak name to selected option
    @Default({}) Map<String, bool> cueOptions, // Map of cue name to enabled state
  }) = _Sets;

  factory Sets.fromJson(Map<String, dynamic> json) => _$SetsFromJson(json)._migrateTweakOptions();

  Sets _migrateTweakOptions() {
    return copyWith(tweakOptions: migrateTweakOptions(tweakOptions));
  }

  double recruitmentFiltered(ProgramGroup pg, double cutoff) {
    if (ex == null) return 0.0;
    return ex!.recruitmentFiltered(pg, tweakOptions, cutoff).volume * n;
  }

  // note: this isn't quite the same as programgroups.
  // e.g. lower pecs, upper pecs are counted as one, gastroc and soleus are counted as one, etc
  int? involvedMuscleGroups() {
    if (ex == null) return null;

    // Get all unique non-null isolationKeys from ProgramGroups with significant recruitment
    final img = ProgramGroup.values
        .where((pg) => ex!.recruitmentFiltered(pg, tweakOptions, 0.5).volume > 0)
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

  // Filter ratings that are compatible with current set configuration
  Iterable<Rating> getApplicableRatings() {
    if (ex == null) return [];
    return _getApplicableRatings(ex!.ratings, tweakOptions, cueOptions);
  }

  // Get applicable ratings for a specific configuration
  Iterable<Rating> getApplicableRatingsForConfig(
    Map<String, String> tweakConfig,
    Map<String, bool> cueConfig,
  ) {
    if (ex == null) return [];
    return _getApplicableRatings(ex!.ratings, tweakConfig, cueConfig);
  }

  // Helper method to filter ratings based on configuration
  Iterable<Rating> _getApplicableRatings(
    List<Rating> ratings,
    Map<String, String> tweakConfig,
    Map<String, bool> cueConfig,
  ) {
    return ratings.where((rating) {
      // HERE get rating
      // Check if all required tweaks are configured correctly
      for (final entry in rating.tweaks.entries) {
        final selectedOption =
            tweakConfig[entry.key] ?? ex!.tweaks.firstWhere((m) => m.name == entry.key).defaultVal;
        if (selectedOption != entry.value) return false;
      }

      // Check if all required cues are enabled
      for (final cue in rating.cues) {
        final isEnabled = cueConfig[cue] ?? ex!.cues[cue]!.$1;
        if (!isEnabled) return false;
      }

      return true;
    });
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
abstract class SetGroup with _$SetGroup {
  const factory SetGroup(List<Sets> sets) = _SetGroup;

  factory SetGroup.fromJson(Map<String, dynamic> json) => _$SetGroupFromJson(json);
}
