// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'measurement.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Measurement _$MeasurementFromJson(Map<String, dynamic> json) => _Measurement(
  id: json['id'] as String,
  timestamp: DateTime.parse(json['timestamp'] as String),
  timezoneOffset: json['timezoneOffset'] as String,
  measurementType: $enumDecode(_$MeasurementTypeEnumMap, json['measurementType']),
  value: (json['value'] as num).toDouble(),
  unit: $enumDecode(_$UnitEnumMap, json['unit']),
  comment: json['comment'] as String?,
);

Map<String, dynamic> _$MeasurementToJson(_Measurement instance) => <String, dynamic>{
  'id': instance.id,
  'timestamp': instance.timestamp.toIso8601String(),
  'timezoneOffset': instance.timezoneOffset,
  'measurementType': _$MeasurementTypeEnumMap[instance.measurementType]!,
  'value': instance.value,
  'unit': _$UnitEnumMap[instance.unit]!,
  'comment': instance.comment,
};

const _$MeasurementTypeEnumMap = {MeasurementType.weight: 'weight'};

const _$UnitEnumMap = {Unit.kg: 'kg', Unit.lbs: 'lbs'};
