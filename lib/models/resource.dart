import 'package:freezed_annotation/freezed_annotation.dart';

import 'resource_category.dart';

part 'resource.freezed.dart';
part 'resource.g.dart';

/// Represents a homelessness resource belonging to a county.
///
/// Maps to the `resources` database table.
@freezed
class Resource with _$Resource {
  const factory Resource({
    required String id,
    @JsonKey(name: 'county_id') required String countyId,
    required ResourceCategory category,
    @JsonKey(name: 'organization_name') required String organizationName,
    String? address,
    @JsonKey(name: 'phone_number') String? phoneNumber,
    @JsonKey(name: 'website_url') String? websiteUrl,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
  }) = _Resource;

  factory Resource.fromJson(Map<String, dynamic> json) =>
      _$ResourceFromJson(json);
}
