import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

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

extension IterableExtension<T> on Iterable<T> {
  /// Insert any item<T> inBetween the list items
  Iterable<T> insertBetween(T item) => expand((e) sync* {
    yield item;
    yield e;
  }).skip(1);

  // insertBetween will be called with index 0 up until iterable.length
  // (i.o.w iterable.length + 1 times)
  Iterable<T> insertBeforeBetweenAfter(T Function(int index) insert) sync* {
    for (final (i, element) in indexed) {
      yield insert(i);
      yield element;
    }
    yield insert(length);
  }
}

bool isMobileApp() {
  if (kIsWeb) return false; // not sure if needed
  return (defaultTargetPlatform == TargetPlatform.android ||
      defaultTargetPlatform == TargetPlatform.iOS);
}

bool isTabletOrDesktop(BuildContext context) {
  return MediaQuery.of(context).size.width > 768;
}
