import 'package:freezed_annotation/freezed_annotation.dart';

part 'measurement.freezed.dart';
part 'measurement.g.dart';

/// A single measurement record
@freezed
abstract class Measurement with _$Measurement {
  const factory Measurement({
    required String id,
    required DateTime timestamp,
    required String timezoneOffset,
    required MeasurementType measurementType,
    required double value,
    required Unit unit,
    String? comment,
  }) = _Measurement;

  factory Measurement.fromJson(Map<String, dynamic> json) => _$MeasurementFromJson(json);
}

/// Enum for measurement types
enum MeasurementType {
  weight,
  // Future: bodyFat, waist, chest, etc.
}

/// Enum for units
enum Unit { kg, lbs }

/// Extension to get display string for units
extension UnitExtension on Unit {
  String get displayName {
    switch (this) {
      case Unit.kg:
        return 'kg';
      case Unit.lbs:
        return 'lbs';
    }
  }

  /// Convert value from this unit to kg
  double toKg(double value) {
    switch (this) {
      case Unit.kg:
        return value;
      case Unit.lbs:
        return value * 0.45359237;
    }
  }

  /// Convert value from kg to this unit
  double fromKg(double valueInKg) {
    switch (this) {
      case Unit.kg:
        return valueInKg;
      case Unit.lbs:
        return valueInKg / 0.45359237;
    }
  }
}

/// Helper to get timezone offset string from DateTime
String getTimezoneOffsetString(DateTime dateTime) {
  final offset = dateTime.timeZoneOffset;
  final hours = offset.inHours.abs();
  final minutes = (offset.inMinutes.abs() % 60);
  final sign = offset.isNegative ? '-' : '+';
  return '$sign${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
}

/// Helper to get default weight unit based on locale
Unit getDefaultWeightUnitFromLocale() {
  // Countries that use lbs: US, UK (partially), Myanmar, Liberia
  // For simplicity, we'll default to kg for most locales
  // This can be enhanced with actual locale detection
  return Unit.kg;
}

/// A point in the moving average time series
@freezed
abstract class MovingAveragePoint with _$MovingAveragePoint {
  const factory MovingAveragePoint({required DateTime timestamp, required double value}) =
      _MovingAveragePoint;
}

/// Container for measurement data with moving average
@freezed
abstract class MeasurementData with _$MeasurementData {
  const factory MeasurementData({
    required List<Measurement> measurements,
    required List<MovingAveragePoint> movingAverage7Day,
  }) = _MeasurementData;
}
