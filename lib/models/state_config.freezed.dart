// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'state_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

StateConfig _$StateConfigFromJson(Map<String, dynamic> json) {
  return _StateConfig.fromJson(json);
}

/// @nodoc
mixin _$StateConfig {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get abbreviation => throw _privateConstructorUsedError;
  @JsonKey(name: 'primary_color')
  String get primaryColor => throw _privateConstructorUsedError;
  @JsonKey(name: 'logo_url')
  String? get logoUrl => throw _privateConstructorUsedError;

  /// Serializes this StateConfig to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of StateConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StateConfigCopyWith<StateConfig> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StateConfigCopyWith<$Res> {
  factory $StateConfigCopyWith(
          StateConfig value, $Res Function(StateConfig) then) =
      _$StateConfigCopyWithImpl<$Res, StateConfig>;
  @useResult
  $Res call({
    String id,
    String name,
    String abbreviation,
    @JsonKey(name: 'primary_color') String primaryColor,
    @JsonKey(name: 'logo_url') String? logoUrl,
  });
}

/// @nodoc
class _$StateConfigCopyWithImpl<$Res, $Val extends StateConfig>
    implements $StateConfigCopyWith<$Res> {
  _$StateConfigCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StateConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? abbreviation = null,
    Object? primaryColor = null,
    Object? logoUrl = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      abbreviation: null == abbreviation
          ? _value.abbreviation
          : abbreviation // ignore: cast_nullable_to_non_nullable
              as String,
      primaryColor: null == primaryColor
          ? _value.primaryColor
          : primaryColor // ignore: cast_nullable_to_non_nullable
              as String,
      logoUrl: freezed == logoUrl
          ? _value.logoUrl
          : logoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$StateConfigImplCopyWith<$Res>
    implements $StateConfigCopyWith<$Res> {
  factory _$$StateConfigImplCopyWith(
          _$StateConfigImpl value, $Res Function(_$StateConfigImpl) then) =
      __$$StateConfigImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    String abbreviation,
    @JsonKey(name: 'primary_color') String primaryColor,
    @JsonKey(name: 'logo_url') String? logoUrl,
  });
}

/// @nodoc
class __$$StateConfigImplCopyWithImpl<$Res>
    extends _$StateConfigCopyWithImpl<$Res, _$StateConfigImpl>
    implements _$$StateConfigImplCopyWith<$Res> {
  __$$StateConfigImplCopyWithImpl(
      _$StateConfigImpl _value, $Res Function(_$StateConfigImpl) _then)
      : super(_value, _then);

  /// Create a copy of StateConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? abbreviation = null,
    Object? primaryColor = null,
    Object? logoUrl = freezed,
  }) {
    return _then(_$StateConfigImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      abbreviation: null == abbreviation
          ? _value.abbreviation
          : abbreviation // ignore: cast_nullable_to_non_nullable
              as String,
      primaryColor: null == primaryColor
          ? _value.primaryColor
          : primaryColor // ignore: cast_nullable_to_non_nullable
              as String,
      logoUrl: freezed == logoUrl
          ? _value.logoUrl
          : logoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StateConfigImpl implements _StateConfig {
  const _$StateConfigImpl({
    required this.id,
    required this.name,
    required this.abbreviation,
    @JsonKey(name: 'primary_color') this.primaryColor = '#1A73E8',
    @JsonKey(name: 'logo_url') this.logoUrl,
  });

  factory _$StateConfigImpl.fromJson(Map<String, dynamic> json) =>
      _$$StateConfigImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String abbreviation;
  @override
  @JsonKey(name: 'primary_color')
  final String primaryColor;
  @override
  @JsonKey(name: 'logo_url')
  final String? logoUrl;

  @override
  String toString() {
    return 'StateConfig(id: $id, name: $name, abbreviation: $abbreviation, primaryColor: $primaryColor, logoUrl: $logoUrl)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StateConfigImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.abbreviation, abbreviation) ||
                other.abbreviation == abbreviation) &&
            (identical(other.primaryColor, primaryColor) ||
                other.primaryColor == primaryColor) &&
            (identical(other.logoUrl, logoUrl) || other.logoUrl == logoUrl));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, name, abbreviation, primaryColor, logoUrl);

  /// Create a copy of StateConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StateConfigImplCopyWith<_$StateConfigImpl> get copyWith =>
      __$$StateConfigImplCopyWithImpl<_$StateConfigImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StateConfigImplToJson(
      this,
    );
  }
}

abstract class _StateConfig implements StateConfig {
  const factory _StateConfig({
    required final String id,
    required final String name,
    required final String abbreviation,
    @JsonKey(name: 'primary_color') final String primaryColor,
    @JsonKey(name: 'logo_url') final String? logoUrl,
  }) = _$StateConfigImpl;

  factory _StateConfig.fromJson(Map<String, dynamic> json) =>
      _$StateConfigImpl.fromJson(json);

  @override
  String get id;
  @override
  String get name;
  @override
  String get abbreviation;
  @override
  @JsonKey(name: 'primary_color')
  String get primaryColor;
  @override
  @JsonKey(name: 'logo_url')
  String? get logoUrl;

  /// Create a copy of StateConfig
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StateConfigImplCopyWith<_$StateConfigImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
