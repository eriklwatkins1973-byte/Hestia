// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'county.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

County _$CountyFromJson(Map<String, dynamic> json) =>
    _$$CountyImplFromJson(json);

_$CountyImpl _$$CountyImplFromJson(Map<String, dynamic> json) => _$CountyImpl(
      id: json['id'] as String,
      stateId: json['state_id'] as String,
      name: json['name'] as String,
    );

Map<String, dynamic> _$$CountyImplToJson(_$CountyImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'state_id': instance.stateId,
      'name': instance.name,
    };
