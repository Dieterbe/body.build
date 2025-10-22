import 'package:bodybuild/model/measurements/measurement.dart';

/// Interpolate value at a specific timestamp using all available measurements
/// since the inputs may have different units, the output is always in kg
double? interpolateValueAt(DateTime targetTime, List<Measurement> sorted) {
  if (sorted.isEmpty) return null;

  // Find measurements before and after target time
  Measurement? before;
  Measurement? after;

  for (final m in sorted) {
    if (m.timestamp.isAtSameMomentAs(targetTime)) {
      return m.unit.toKg(m.value);
    }
    if (m.timestamp.isBefore(targetTime)) {
      before = m;
    } else {
      after = m;
      break;
    }
  }

  // If both are null, we can't do anything
  if (before == null && after == null) return null;

  // If target is before all measurements, use first measurement
  if (before == null && after != null) {
    return after.unit.toKg(after.value);
  }

  // If target is after all measurements, use last measurement
  if (before != null && after == null) {
    return before.unit.toKg(before.value);
  }

  // Interpolate between before and after
  final beforeValue = before!.unit.toKg(before.value);
  final afterValue = after!.unit.toKg(after.value);
  final totalDuration = after.timestamp.difference(before.timestamp).inMilliseconds;
  final targetDuration = targetTime.difference(before.timestamp).inMilliseconds;

  if (totalDuration == 0) return (afterValue + beforeValue) / 2;

  final ratio = targetDuration / totalDuration;
  return beforeValue + (afterValue - beforeValue) * ratio;
}
