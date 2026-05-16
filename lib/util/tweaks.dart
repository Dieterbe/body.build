import 'dart:convert';

Map<String, String> tweaksFromJson(String jsonStr) {
  if (jsonStr.isEmpty) return {};
  final decoded = json.decode(jsonStr);
  return Map<String, String>.from(decoded);
}

String tweaksToJson(Map<String, String> tweaks) => json.encode(tweaks);
