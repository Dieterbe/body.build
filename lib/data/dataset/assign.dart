class Assign {
  final double volume;
  final bool multiplied;
  final String? modality; // work in progress
  const Assign(this.volume, [this.modality]) : multiplied = false;
  const Assign.merged(this.volume, this.multiplied, [this.modality]);

  Assign merge(Assign other) {
    final mergedModality = switch ((modality, other.modality)) {
      (null, null) => null,
      (String value, null) => value,
      (null, String value) => value,
      (String a, String b) => '$a, $b',
    };
    double newVolume;
    bool newMultiplied;
    if (volume == 0) {
      // if we didn't have a volume assignment yet, just use the new one
      newVolume = other.volume;
      newMultiplied = false;
    } else {
      // if we did, they are "multipliers" to one another.
      newVolume = volume * other.volume;
      newMultiplied = true;
    }

    if (newVolume > 1) {
      // in march 2025 this should never happen
      // in the future, we may want to allow it (to support extra-ordinary activation, e.g. eccentric overloading i think was an example. maybe also for leg curl with flexed hip)
      print('WARNING: Assign.merge -> volume > 1: $newVolume');
    }
    return Assign.merged(newVolume, newMultiplied, mergedModality);
  }
}
