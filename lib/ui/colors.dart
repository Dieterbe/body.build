import 'dart:ui';

const colorSeed = Color.fromARGB(255, 15, 209, 157);
const colorActive = Color.fromARGB(255, 219, 124, 0);

const strengthColors = [
  Color.fromARGB(255 ~/ 6, 0, 0, 0),
  Color.fromARGB(255 * 2 ~/ 6, 0, 0, 0),
  Color.fromARGB(255 * 3 ~/ 6, 0, 0, 0),
  Color.fromARGB(255 * 4 ~/ 6, 253, 173, 0),
  Color.fromARGB(255 * 5 ~/ 6, 255, 102, 0),
  Color.fromARGB(255, 255, 0, 0),
];

const strengthStrings = [
  'trivial',
  'very weak',
  'weak',
  'moderate/unknown',
  'strong',
  'strongest'
];
