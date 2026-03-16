import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_state.freezed.dart';
part 'app_state.g.dart';

/// Represents a US state that acts as a top-level tenant in the system.
///
/// Maps to the `states` database table.
@freezed
class AppState with _$AppState {
  const factory AppState({
    required String id,
    required String name,
    required String abbreviation,
    /// Tenant branding color. Defaults to `#1A73E8` (Google Blue) when the
    /// state has not configured its own primary color.
    @JsonKey(name: 'primary_color') @Default('#1A73E8') String primaryColor,
    @JsonKey(name: 'logo_url') String? logoUrl,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  }) = _AppState;

  factory AppState.fromJson(Map<String, dynamic> json) =>
      _$AppStateFromJson(json);
}
