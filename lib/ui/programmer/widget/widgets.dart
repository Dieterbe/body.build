import 'package:flutter/material.dart';

Widget rotatedText(String text) {
  return FittedBox(
    fit: BoxFit.cover,
    child: Transform.rotate(
      angle: 45 / 180 * 3.14,
      child: Text(text),
    ),
  );
}

Widget muscleMark(double recruitment, BuildContext context) {
  return Container(
    // padding: const EdgeInsets.all(2.0),
    width: 30,
    height: 30,
    color: Theme.of(context).colorScheme.primary.withValues(alpha: recruitment),
  );
}

// fixed with, for use in rows
Widget titleText(String title, BuildContext context) => titleWidget(
    Text(title, style: Theme.of(context).textTheme.titleMedium), context);

Widget titleTextLarge(String title, BuildContext context) => titleWidget(
    Text(title, style: Theme.of(context).textTheme.titleLarge), context);

// fixed with, for use in rows
Widget titleWidget(Widget child, BuildContext context) =>
    Container(alignment: Alignment.centerRight, width: 140, child: child);
