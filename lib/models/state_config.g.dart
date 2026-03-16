// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'state_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$StateConfigImpl _$$StateConfigImplFromJson(Map<String, dynamic> json) =>
    _$StateConfigImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      abbreviation: json['abbreviation'] as String,
      primaryColor: json['primary_color'] as String? ?? '#1A73E8',
      logoUrl: json['logo_url'] as String?,
    );

Map<String, dynamic> _$$StateConfigImplToJson(_$StateConfigImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'abbreviation': instance.abbreviation,
      'primary_color': instance.primaryColor,
      'logo_url': instance.logoUrl,
    };
