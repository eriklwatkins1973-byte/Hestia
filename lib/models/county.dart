import 'package:freezed_annotation/freezed_annotation.dart';

part 'county.freezed.dart';
part 'county.g.dart';

/// Represents a county within a US state.
///
/// Maps to the `counties` database table.
@freezed
class County with _$County {
  const factory County({
    required String id,
    @JsonKey(name: 'state_id') required String stateId,
    required String name,
  }) = _County;

  factory County.fromJson(Map<String, dynamic> json) => _$CountyFromJson(json);
}
