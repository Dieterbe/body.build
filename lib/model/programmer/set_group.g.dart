// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'set_group.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Sets _$SetsFromJson(Map<String, dynamic> json) => _Sets(
  (json['intensity'] as num).toInt(),
  ex: _exFromJson(json['ex'] as String?),
  n: (json['n'] as num?)?.toInt() ?? 1,
  changeEx: json['changeEx'] as bool? ?? false,
  modifierOptions:
      (json['modifierOptions'] as Map<String, dynamic>?)?.map((k, e) => MapEntry(k, e as String)) ??
      const {},
  cueOptions:
      (json['cueOptions'] as Map<String, dynamic>?)?.map((k, e) => MapEntry(k, e as bool)) ??
      const {},
);

Map<String, dynamic> _$SetsToJson(_Sets instance) => <String, dynamic>{
  'intensity': instance.intensity,
  'ex': _exToJson(instance.ex),
  'n': instance.n,
  'modifierOptions': instance.modifierOptions,
  'cueOptions': instance.cueOptions,
};

_SetGroup _$SetGroupFromJson(Map<String, dynamic> json) => _SetGroup(
  (json['sets'] as List<dynamic>).map((e) => Sets.fromJson(e as Map<String, dynamic>)).toList(),
);

Map<String, dynamic> _$SetGroupToJson(_SetGroup instance) => <String, dynamic>{
  'sets': instance.sets,
};
