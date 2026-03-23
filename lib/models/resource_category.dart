import 'package:json_annotation/json_annotation.dart';

/// Represents the permitted values for [Resource.category], mirroring the
/// database CHECK constraint:
/// `category IN ('shelter', 'meal', 'healthcare', 'legal', 'other')`.
enum ResourceCategory {
  @JsonValue('shelter')
  shelter,

  @JsonValue('meal')
  meal,

  @JsonValue('healthcare')
  healthcare,

  @JsonValue('legal')
  legal,

  @JsonValue('other')
  other,
}
