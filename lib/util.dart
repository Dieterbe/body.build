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

// insertBetween will be called with index 0 up until iterable.length
// (i.o.w iterable.length + 1 times)
  Iterable<T> insertBeforeBetweenAfter(
    T Function(int index) insert,
  ) sync* {
    for (final (i, element) in indexed) {
      yield insert(i);
      yield element;
    }
    yield insert(length);
  }
}
