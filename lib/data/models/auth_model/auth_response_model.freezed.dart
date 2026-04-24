// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_response_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AuthResponseModel _$AuthResponseModelFromJson(Map<String, dynamic> json) {
  return _AuthResponseModel.fromJson(json);
}

/// @nodoc
mixin _$AuthResponseModel {
  @JsonKey(name: 'idToken')
  String get token => throw _privateConstructorUsedError;
  @JsonKey(name: 'localId')
  String get userId => throw _privateConstructorUsedError;
  @JsonKey(name: 'expiresIn')
  String get expiresIn => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AuthResponseModelCopyWith<AuthResponseModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AuthResponseModelCopyWith<$Res> {
  factory $AuthResponseModelCopyWith(
          AuthResponseModel value, $Res Function(AuthResponseModel) then) =
      _$AuthResponseModelCopyWithImpl<$Res, AuthResponseModel>;
  @useResult
  $Res call(
      {@JsonKey(name: 'idToken') String token,
      @JsonKey(name: 'localId') String userId,
      @JsonKey(name: 'expiresIn') String expiresIn});
}

/// @nodoc
class _$AuthResponseModelCopyWithImpl<$Res, $Val extends AuthResponseModel>
    implements $AuthResponseModelCopyWith<$Res> {
  _$AuthResponseModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? token = null,
    Object? userId = null,
    Object? expiresIn = null,
  }) {
    return _then(_value.copyWith(
      token: null == token
          ? _value.token
          : token // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      expiresIn: null == expiresIn
          ? _value.expiresIn
          : expiresIn // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AuthResponseModelImplCopyWith<$Res>
    implements $AuthResponseModelCopyWith<$Res> {
  factory _$$AuthResponseModelImplCopyWith(_$AuthResponseModelImpl value,
          $Res Function(_$AuthResponseModelImpl) then) =
      __$$AuthResponseModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'idToken') String token,
      @JsonKey(name: 'localId') String userId,
      @JsonKey(name: 'expiresIn') String expiresIn});
}

/// @nodoc
class __$$AuthResponseModelImplCopyWithImpl<$Res>
    extends _$AuthResponseModelCopyWithImpl<$Res, _$AuthResponseModelImpl>
    implements _$$AuthResponseModelImplCopyWith<$Res> {
  __$$AuthResponseModelImplCopyWithImpl(_$AuthResponseModelImpl _value,
      $Res Function(_$AuthResponseModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? token = null,
    Object? userId = null,
    Object? expiresIn = null,
  }) {
    return _then(_$AuthResponseModelImpl(
      token: null == token
          ? _value.token
          : token // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      expiresIn: null == expiresIn
          ? _value.expiresIn
          : expiresIn // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AuthResponseModelImpl implements _AuthResponseModel {
  const _$AuthResponseModelImpl(
      {@JsonKey(name: 'idToken') this.token = '',
      @JsonKey(name: 'localId') this.userId = '',
      @JsonKey(name: 'expiresIn') this.expiresIn = '3600'});

  factory _$AuthResponseModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$AuthResponseModelImplFromJson(json);

  @override
  @JsonKey(name: 'idToken')
  final String token;
  @override
  @JsonKey(name: 'localId')
  final String userId;
  @override
  @JsonKey(name: 'expiresIn')
  final String expiresIn;

  @override
  String toString() {
    return 'AuthResponseModel(token: $token, userId: $userId, expiresIn: $expiresIn)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthResponseModelImpl &&
            (identical(other.token, token) || other.token == token) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.expiresIn, expiresIn) ||
                other.expiresIn == expiresIn));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, token, userId, expiresIn);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AuthResponseModelImplCopyWith<_$AuthResponseModelImpl> get copyWith =>
      __$$AuthResponseModelImplCopyWithImpl<_$AuthResponseModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AuthResponseModelImplToJson(
      this,
    );
  }
}

abstract class _AuthResponseModel implements AuthResponseModel {
  const factory _AuthResponseModel(
          {@JsonKey(name: 'idToken') final String token,
          @JsonKey(name: 'localId') final String userId,
          @JsonKey(name: 'expiresIn') final String expiresIn}) =
      _$AuthResponseModelImpl;

  factory _AuthResponseModel.fromJson(Map<String, dynamic> json) =
      _$AuthResponseModelImpl.fromJson;

  @override
  @JsonKey(name: 'idToken')
  String get token;
  @override
  @JsonKey(name: 'localId')
  String get userId;
  @override
  @JsonKey(name: 'expiresIn')
  String get expiresIn;
  @override
  @JsonKey(ignore: true)
  _$$AuthResponseModelImplCopyWith<_$AuthResponseModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
