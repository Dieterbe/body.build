import 'package:flutter/material.dart';
import 'package:ptc/data/programmer/groups.dart';

Color bgColorForProgramGroup(ProgramGroup g) {
  switch (g) {
    case ProgramGroup.wristExtensors:
      return Colors.orange.shade50;
    case ProgramGroup.wristFlexors:
      return Colors.orange.shade100;
    case ProgramGroup.lowerPecs:
      return Colors.yellow.shade200;
    case ProgramGroup.upperPecs:
      return Colors.yellow.shade100;
    case ProgramGroup.frontDelts:
      return Colors.yellow.shade200;
    case ProgramGroup.sideDelts:
      return Colors.yellow.shade100;
    case ProgramGroup.rearDelts:
      return Colors.yellow.shade200;
    case ProgramGroup.lowerTraps:
      return Colors.blue.shade50;
    case ProgramGroup.middleTraps:
      return Colors.blue.shade100;
    case ProgramGroup.upperTraps:
      return Colors.blue.shade50;
    case ProgramGroup.lats:
      return Colors.blue.shade100;
    case ProgramGroup.biceps:
      return Colors.green.shade100;
    case ProgramGroup.tricepsMedLatH:
      return Colors.green.shade200;
    case ProgramGroup.tricepsLongHead:
      return Colors.green.shade100;
    case ProgramGroup.abs:
      return Colors.purple.shade100;
    case ProgramGroup.spinalErectors:
      return Colors.purple.shade50;
    case ProgramGroup.quadsVasti:
      return Colors.red.shade100;
    case ProgramGroup.quadsRF:
      return Colors.red.shade50;
    case ProgramGroup.hams:
      return Colors.red.shade100;
    case ProgramGroup.hamsShortHead:
      return Colors.red.shade50;
    case ProgramGroup.gluteMax:
      return Colors.red.shade100;
    case ProgramGroup.gluteMed:
      return Colors.red.shade50;
    case ProgramGroup.gastroc:
      return Colors.red.shade100;
    case ProgramGroup.soleus:
      return Colors.red.shade50;
    default:
      return Colors.transparent;
  }
}
