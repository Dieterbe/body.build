// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'set_group.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SetsImpl _$$SetsImplFromJson(Map<String, dynamic> json) => _$SetsImpl(
      (json['intensity'] as num).toInt(),
      ex: _exFromJson(json['ex'] as String?),
      n: (json['n'] as num?)?.toInt() ?? 1,
      changeEx: json['changeEx'] as bool? ?? false,
    );

Map<String, dynamic> _$$SetsImplToJson(_$SetsImpl instance) =>
    <String, dynamic>{
      'intensity': instance.intensity,
      'ex': _exToJson(instance.ex),
      'n': instance.n,
    };

_$SetGroupImpl _$$SetGroupImplFromJson(Map<String, dynamic> json) =>
    _$SetGroupImpl(
      (json['sets'] as List<dynamic>)
          .map((e) => Sets.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$SetGroupImplToJson(_$SetGroupImpl instance) =>
    <String, dynamic>{
      'sets': instance.sets,
    };
