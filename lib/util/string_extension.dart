extension StringExtension on String {
  String capitalizeFirstOnly() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }

  String capitalizeFirstOnlyButKeepAcronym() {
    // If string is all uppercase, keep it as-is (e.g., "ROM" stays "ROM")
    if (this == toUpperCase()) {
      return this;
    }
    return capitalizeFirstOnly();
  }

  String capitalizeFirst() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }

  String camelToSpace() {
    return replaceAllMapped(RegExp(r'([A-Z])'), (match) => ' ${match.group(0)}');
  }

  String camelToTitle() {
    return camelToSpace().capitalizeFirstOnly();
  }

  /// Converts camelCase to snake_case for URL paths
  String camelToSnake() {
    return replaceAllMapped(RegExp(r'[A-Z]'), (match) => '_${match.group(0)!.toLowerCase()}');
  }

  /// Converts snake_case to camelCase for parsing URL paths
  String snakeToCamel() {
    return replaceAllMapped(RegExp(r'_([a-z])'), (match) => match.group(1)!.toUpperCase());
  }
}
