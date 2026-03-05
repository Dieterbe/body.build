// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AppSettings _$AppSettingsFromJson(Map<String, dynamic> json) => _AppSettings(
  wgerApiKey: json['wgerApiKey'] as String? ?? '',
  defaultRir: (json['defaultRir'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$AppSettingsToJson(_AppSettings instance) => <String, dynamic>{
  'wgerApiKey': instance.wgerApiKey,
  'defaultRir': instance.defaultRir,
};
