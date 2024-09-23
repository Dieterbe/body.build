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

extension IterableExtension<T> on Iterable<T> {
  /// Insert any item<T> inBetween the list items
  Iterable<T> insertBetween(T item) => expand((e) sync* {
        yield item;
        yield e;
      }).skip(1);
}
