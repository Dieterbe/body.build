/// URL encoding and decoding utilities for exercise IDs
/// see exercises.dart for detailed character rules of the various fields
/// most importantly, '_' is not allowed, so we can use them in the URL

/// Builds an exercise detail URL with encoded exercise ID and tweak options.
String buildExerciseDetailUrl(String exerciseId, Map<String, String> tweakOptions) {
  // Encode spaces as underscores in exercise ID
  final encodedExerciseId = exerciseId.replaceAll(' ', '_');

  if (tweakOptions.isEmpty) {
    return '/exercises/$encodedExerciseId';
  }

  final queryParams = <String, String>{};
  tweakOptions.forEach((key, value) {
    // Encode spaces as underscores in both keys and values
    final encodedKey = key.replaceAll(' ', '_');
    final encodedValue = value.replaceAll(' ', '_');
    queryParams['mod_$encodedKey'] = encodedValue;
  });

  final uri = Uri(path: '/exercises/$encodedExerciseId', queryParameters: queryParams);

  return uri.toString();
}

/// Parses tweak options from URL query parameters.
/// Strips 'mod_' prefix and decodes underscores back to spaces.
Map<String, String> parseExerciseParams(Map<String, String> queryParameters) {
  final tweakOptions = <String, String>{};

  queryParameters.forEach((key, value) {
    if (key.startsWith('mod_')) {
      // Strip 'mod_' prefix and decode underscores to spaces
      final decodedKey = key.substring(4).replaceAll('_', ' ');
      final decodedValue = value.replaceAll('_', ' ');
      tweakOptions[decodedKey] = decodedValue;
    }
  });

  return tweakOptions;
}

String parseExerciseId(String path) {
  return path.replaceAll('_', ' ');
}
