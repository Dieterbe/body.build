enum ActivityLevel {
  sedentary('Sedentary'),
  somewhatActive('Somewhat active'),
  active('Active'),
  veryActive('Very active');

  final String displayName;
  const ActivityLevel(this.displayName);
}
