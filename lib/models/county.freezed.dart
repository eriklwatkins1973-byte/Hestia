// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'county.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your copy of County directly. '
    'Please do not. Prefer using the generated \$CountyCopyWith setter or a constructor like County(...).');

/// @nodoc
mixin _$County {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'state_id')
  String get stateId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;

  /// Serializes this County to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of County
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CountyCopyWith<County> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CountyCopyWith<$Res> {
  factory $CountyCopyWith(County value, $Res Function(County) then) =
      _$CountyCopyWithImpl<$Res, County>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'state_id') String stateId,
    String name,
  });
}

/// @nodoc
class _$CountyCopyWithImpl<$Res, $Val extends County>
    implements $CountyCopyWith<$Res> {
  _$CountyCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of County
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? stateId = null,
    Object? name = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      stateId: null == stateId
          ? _value.stateId
          : stateId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CountyImplCopyWith<$Res> implements $CountyCopyWith<$Res> {
  factory _$$CountyImplCopyWith(
          _$CountyImpl value, $Res Function(_$CountyImpl) then) =
      __$$CountyImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'state_id') String stateId,
    String name,
  });
}

/// @nodoc
class __$$CountyImplCopyWithImpl<$Res>
    extends _$CountyCopyWithImpl<$Res, _$CountyImpl>
    implements _$$CountyImplCopyWith<$Res> {
  __$$CountyImplCopyWithImpl(
      _$CountyImpl _value, $Res Function(_$CountyImpl) _then)
      : super(_value, _then);

  /// Create a copy of County
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? stateId = null,
    Object? name = null,
  }) {
    return _then(_$CountyImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      stateId: null == stateId
          ? _value.stateId
          : stateId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CountyImpl implements _County {
  const _$CountyImpl({
    required this.id,
    @JsonKey(name: 'state_id') required this.stateId,
    required this.name,
  });

  factory _$CountyImpl.fromJson(Map<String, dynamic> json) =>
      _$$CountyImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'state_id')
  final String stateId;
  @override
  final String name;

  @override
  String toString() {
    return 'County(id: $id, stateId: $stateId, name: $name)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CountyImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.stateId, stateId) || other.stateId == stateId) &&
            (identical(other.name, name) || other.name == name));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, stateId, name);

  /// Create a copy of County
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CountyImplCopyWith<_$CountyImpl> get copyWith =>
      __$$CountyImplCopyWithImpl<_$CountyImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CountyImplToJson(
      this,
    );
  }
}

abstract class _County implements County {
  const factory _County({
    required final String id,
    @JsonKey(name: 'state_id') required final String stateId,
    required final String name,
  }) = _$CountyImpl;

  factory _County.fromJson(Map<String, dynamic> json) = _$CountyImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'state_id')
  String get stateId;
  @override
  String get name;

  /// Create a copy of County
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CountyImplCopyWith<_$CountyImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
