extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }

  String camelToSpace() {
    return replaceAllMapped(
        RegExp(r'([A-Z])'), (match) => ' ${match.group(0)}');
  }

  String camelToTitle() {
    return camelToSpace().capitalize();
  }
}
