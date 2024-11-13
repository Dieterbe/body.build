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
    color: Theme.of(context).colorScheme.primary.withOpacity(recruitment),
  );
}
