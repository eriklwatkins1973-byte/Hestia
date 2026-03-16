// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'resource.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Resource _$ResourceFromJson(Map<String, dynamic> json) =>
    _$$ResourceImplFromJson(json);

_$ResourceImpl _$$ResourceImplFromJson(Map<String, dynamic> json) =>
    _$ResourceImpl(
      id: json['id'] as String,
      countyId: json['county_id'] as String,
      category: $enumDecode(_$ResourceCategoryEnumMap, json['category']),
      organizationName: json['organization_name'] as String,
      address: json['address'] as String?,
      phoneNumber: json['phone_number'] as String?,
      websiteUrl: json['website_url'] as String?,
      isActive: json['is_active'] as bool? ?? true,
    );

Map<String, dynamic> _$$ResourceImplToJson(_$ResourceImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'county_id': instance.countyId,
      'category': _$ResourceCategoryEnumMap[instance.category]!,
      'organization_name': instance.organizationName,
      'address': instance.address,
      'phone_number': instance.phoneNumber,
      'website_url': instance.websiteUrl,
      'is_active': instance.isActive,
    };

const _$ResourceCategoryEnumMap = {
  ResourceCategory.shelter: 'shelter',
  ResourceCategory.meal: 'meal',
  ResourceCategory.healthcare: 'healthcare',
  ResourceCategory.legal: 'legal',
  ResourceCategory.other: 'other',
};
