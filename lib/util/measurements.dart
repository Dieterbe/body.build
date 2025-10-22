import 'package:bodybuild/model/measurements/measurement.dart';

/// Interpolate value at a specific timestamp using all available measurements
MovingAveragePoint? interpolateValueAt(DateTime targetTime, List<MovingAveragePoint> sorted) {
  if (sorted.isEmpty) return null;

  // Find measurements before and after target time
  MovingAveragePoint? before;
  MovingAveragePoint? after;

  for (final m in sorted) {
    if (m.timestamp.isAtSameMomentAs(targetTime)) {
      return m;
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
    return after;
  }

  // If target is after all measurements, use last measurement
  if (before != null && after == null) {
    return before;
  }

  // Interpolate between before and after
  final beforeValue = before!.value;
  final afterValue = after!.value;
  final totalDuration = after.timestamp.difference(before.timestamp).inMilliseconds;
  final targetDuration = targetTime.difference(before.timestamp).inMilliseconds;

  if (totalDuration == 0) {
    return after;
  }

  final ratio = targetDuration / totalDuration;
  return MovingAveragePoint(
    timestamp: targetTime,
    value: beforeValue + (afterValue - beforeValue) * ratio,
  );
}
