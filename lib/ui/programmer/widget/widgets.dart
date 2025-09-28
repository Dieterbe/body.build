import 'package:bodybuild/ui/core/text_style.dart';
import 'package:flutter/material.dart';

Widget rotatedText(String text) {
  return FittedBox(
    fit: BoxFit.cover,
    child: Transform.rotate(angle: 45 / 180 * 3.14, child: Text(text)),
  );
}

Widget muscleMark(double recruitment, BuildContext context) {
  return Container(
    // padding: const EdgeInsets.all(2.0),
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.primary.withValues(alpha: recruitment),
      borderRadius: const BorderRadius.all(Radius.circular(3)),
    ),
    width: 30,
    height: 30,
  );
}

Widget pad8(Widget child) => Padding(padding: const EdgeInsets.all(8.0), child: child);

// TODO: rename these to convey the align & width capping: prefixFoo maybe?
// fixed with, for use in rows
// TODO: no actually, this should be deprecated as we auto-manage our layouts now
Widget titleTextMedium(String title, BuildContext context) =>
    titleWidget(Text(title, style: ts100(context)), context);

Widget titleTextLarge(String title, BuildContext context) =>
    titleWidget(Text(title, style: Theme.of(context).textTheme.titleLarge), context);

// fixed with, for use in rows
Widget titleWidget(Widget child, BuildContext context) => Expanded(
  flex: 10,
  child: Container(alignment: Alignment.centerRight, child: child),
);
