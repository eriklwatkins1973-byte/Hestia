import 'package:freezed_annotation/freezed_annotation.dart';

part 'state_config.freezed.dart';
part 'state_config.g.dart';

@freezed
class StateConfig with _$StateConfig {
  const factory StateConfig({
    required String id,
    required String name,
    required String abbreviation,
    @JsonKey(name: 'primary_color') @Default('#1A73E8') String primaryColor,
    @JsonKey(name: 'logo_url') String? logoUrl,
  }) = _StateConfig;

  factory StateConfig.fromJson(Map<String, dynamic> json) =>
      _$StateConfigFromJson(json);
}
