import 'package:freezed_annotation/freezed_annotation.dart';

part 'resource.freezed.dart';
part 'resource.g.dart';

@freezed
class Resource with _$Resource {
  const factory Resource({
    required String id,
    @JsonKey(name: 'county_id') required String countyId,
    required String category, // 'shelter', 'meal', etc.
    @JsonKey(name: 'organization_name') required String organizationName,
    String? description,
    String? address,
    double? latitude,
    double? longitude,
    @JsonKey(name: 'phone_number') String? phoneNumber,
    @JsonKey(name: 'website_url') String? websiteUrl,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
  }) = _Resource;

  factory Resource.fromJson(Map<String, dynamic> json) =>
      _$ResourceFromJson(json);
}
