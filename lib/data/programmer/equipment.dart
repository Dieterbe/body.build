enum EquipmentCategory {
  nonMachine("Non-machine"),
  generalMachines("General Machines"),
  upperBodyMachines("Upper Body Machines"),
  coreAndGluteMachines("Core and Glute Machines"),
  lowerBodyMachines("Lower Body Machines");

  final String displayName;
  const EquipmentCategory(this.displayName);
}

// built-in: doesn't need to be persisted
enum Equipment {
  // Non-machine
  barbell("Barbell", EquipmentCategory.nonMachine),
  dumbbell("Dumbbells", EquipmentCategory.nonMachine),
  kettlebell("Kettlebells", EquipmentCategory.nonMachine),
  trx("TRX (or similar)", EquipmentCategory.nonMachine),
  gymnasticRings("Gymnastic Rings", EquipmentCategory.nonMachine),
  elastic("Resistance bands", EquipmentCategory.nonMachine),

  // General machines
  smithMachineAngled("Smith Machine angled", EquipmentCategory.generalMachines),
  smithMachineVertical(
      "Smith Machine vertical", EquipmentCategory.generalMachines),
  cableTower("Cable Tower", EquipmentCategory.generalMachines),
  cableTowerDual("Dual Cable Tower", EquipmentCategory.generalMachines),

  // Upper body machines
  shoulderPressMachine(
      "Shoulder Press Machine", EquipmentCategory.upperBodyMachines),
  chestPressMachine("Chest Press Machine", EquipmentCategory.upperBodyMachines),
  pecDeckMachine("Pec Deck (elbow pad)", EquipmentCategory.upperBodyMachines),
  chestFlyMachine(
      "Chest Fly Machine (hand grips)", EquipmentCategory.upperBodyMachines),
  rearDeltFlyMachine(
      "Rear Delt Fly Machine", EquipmentCategory.upperBodyMachines),
  latPullDownMachine(
      "Lat Pulldown Machine", EquipmentCategory.upperBodyMachines),
  cableRowMachine("Cable Row Machine", EquipmentCategory.upperBodyMachines),
  rowMachine(
      "Row Machine (chest supported)", EquipmentCategory.upperBodyMachines),
  preacherCurlBench("Preacher Curl Bench", EquipmentCategory.upperBodyMachines),
  preacherCurlMachine(
      "Preacher Curl Machine", EquipmentCategory.upperBodyMachines),
  bicepCurlMachine("Biceps Curl Machine", EquipmentCategory.upperBodyMachines),

  // Core and glute machines
  abCrunchMachine("Ab Crunch Machine", EquipmentCategory.coreAndGluteMachines),
  hyper45("45° Back Extension", EquipmentCategory.coreAndGluteMachines),
  hyper90("90° Back Extension", EquipmentCategory.coreAndGluteMachines),
  hyperReverse("Reverse Hyper", EquipmentCategory.coreAndGluteMachines),
  hipThrustMachine(
      "Hip Thrust Machine", EquipmentCategory.coreAndGluteMachines),
  gluteKickbackMachine(
      "Glute Kickback Machine", EquipmentCategory.coreAndGluteMachines),
  pendulumGluteKickback(
      "Pendulum Kickback", EquipmentCategory.coreAndGluteMachines),
  hipAdductionAbductionMachine(
      "Hip (Add/Abd)uction Machine", EquipmentCategory.coreAndGluteMachines),

  // Lower body machines

  beltSquatMachine("Belt Squat Machine", EquipmentCategory.lowerBodyMachines),
  hackSquatMachine("Hack Squat Machine", EquipmentCategory.lowerBodyMachines),
  squatRack("Squat rack/cage", EquipmentCategory.lowerBodyMachines),
  hamCurlMachineLying(
      "Lying Leg Curl Machine", EquipmentCategory.lowerBodyMachines),
  hamCurlMachineSeated(
      "Seated Leg Curl Machine", EquipmentCategory.lowerBodyMachines),
  hamCurlMachineStanding(
      "Standing Leg Curl Machine", EquipmentCategory.lowerBodyMachines),
  legExtensionMachine(
      "Leg Extension Machine", EquipmentCategory.lowerBodyMachines),
  legPressMachine("Leg Press Machine", EquipmentCategory.lowerBodyMachines),
  calfRaiseMachineSeated(
      "Seated Calf Raise Machine", EquipmentCategory.lowerBodyMachines),
  calfRaiseMachineStanding(
      "Standing Calf Raise Machine", EquipmentCategory.lowerBodyMachines);

  /*
others that menno asks about, but are not supported here:
a glute-ham raise
a dip/chin-up belt
a pair of knee wraps 
powerlifting bands (not the light home workout stuff)
powerlifting chains
*/

  final String displayName;
  final EquipmentCategory category;
  const Equipment(this.displayName, this.category);
}
