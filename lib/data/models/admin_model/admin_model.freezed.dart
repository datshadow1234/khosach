// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'admin_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AdminModel _$AdminModelFromJson(Map<String, dynamic> json) {
  return _AdminModel.fromJson(json);
}

/// @nodoc
mixin _$AdminModel {
  String get uid => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get phone => throw _privateConstructorUsedError;
  String get address => throw _privateConstructorUsedError;
  String get role => throw _privateConstructorUsedError;
  String get lastLogin => throw _privateConstructorUsedError;
  double get latitude => throw _privateConstructorUsedError;
  double get longitude => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AdminModelCopyWith<AdminModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AdminModelCopyWith<$Res> {
  factory $AdminModelCopyWith(
          AdminModel value, $Res Function(AdminModel) then) =
      _$AdminModelCopyWithImpl<$Res, AdminModel>;
  @useResult
  $Res call(
      {String uid,
      String email,
      String name,
      String phone,
      String address,
      String role,
      String lastLogin,
      double latitude,
      double longitude});
}

/// @nodoc
class _$AdminModelCopyWithImpl<$Res, $Val extends AdminModel>
    implements $AdminModelCopyWith<$Res> {
  _$AdminModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = null,
    Object? email = null,
    Object? name = null,
    Object? phone = null,
    Object? address = null,
    Object? role = null,
    Object? lastLogin = null,
    Object? latitude = null,
    Object? longitude = null,
  }) {
    return _then(_value.copyWith(
      uid: null == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      phone: null == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String,
      address: null == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as String,
      lastLogin: null == lastLogin
          ? _value.lastLogin
          : lastLogin // ignore: cast_nullable_to_non_nullable
              as String,
      latitude: null == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double,
      longitude: null == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AdminModelImplCopyWith<$Res>
    implements $AdminModelCopyWith<$Res> {
  factory _$$AdminModelImplCopyWith(
          _$AdminModelImpl value, $Res Function(_$AdminModelImpl) then) =
      __$$AdminModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String uid,
      String email,
      String name,
      String phone,
      String address,
      String role,
      String lastLogin,
      double latitude,
      double longitude});
}

/// @nodoc
class __$$AdminModelImplCopyWithImpl<$Res>
    extends _$AdminModelCopyWithImpl<$Res, _$AdminModelImpl>
    implements _$$AdminModelImplCopyWith<$Res> {
  __$$AdminModelImplCopyWithImpl(
      _$AdminModelImpl _value, $Res Function(_$AdminModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = null,
    Object? email = null,
    Object? name = null,
    Object? phone = null,
    Object? address = null,
    Object? role = null,
    Object? lastLogin = null,
    Object? latitude = null,
    Object? longitude = null,
  }) {
    return _then(_$AdminModelImpl(
      uid: null == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      phone: null == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String,
      address: null == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as String,
      lastLogin: null == lastLogin
          ? _value.lastLogin
          : lastLogin // ignore: cast_nullable_to_non_nullable
              as String,
      latitude: null == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double,
      longitude: null == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AdminModelImpl extends _AdminModel {
  const _$AdminModelImpl(
      {this.uid = '',
      this.email = '',
      this.name = '',
      this.phone = '',
      this.address = '',
      this.role = 'admin',
      this.lastLogin = '',
      this.latitude = 0.0,
      this.longitude = 0.0})
      : super._();

  factory _$AdminModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$AdminModelImplFromJson(json);

  @override
  @JsonKey()
  final String uid;
  @override
  @JsonKey()
  final String email;
  @override
  @JsonKey()
  final String name;
  @override
  @JsonKey()
  final String phone;
  @override
  @JsonKey()
  final String address;
  @override
  @JsonKey()
  final String role;
  @override
  @JsonKey()
  final String lastLogin;
  @override
  @JsonKey()
  final double latitude;
  @override
  @JsonKey()
  final double longitude;

  @override
  String toString() {
    return 'AdminModel(uid: $uid, email: $email, name: $name, phone: $phone, address: $address, role: $role, lastLogin: $lastLogin, latitude: $latitude, longitude: $longitude)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AdminModelImpl &&
            (identical(other.uid, uid) || other.uid == uid) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.lastLogin, lastLogin) ||
                other.lastLogin == lastLogin) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, uid, email, name, phone, address,
      role, lastLogin, latitude, longitude);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AdminModelImplCopyWith<_$AdminModelImpl> get copyWith =>
      __$$AdminModelImplCopyWithImpl<_$AdminModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AdminModelImplToJson(
      this,
    );
  }
}

abstract class _AdminModel extends AdminModel {
  const factory _AdminModel(
      {final String uid,
      final String email,
      final String name,
      final String phone,
      final String address,
      final String role,
      final String lastLogin,
      final double latitude,
      final double longitude}) = _$AdminModelImpl;
  const _AdminModel._() : super._();

  factory _AdminModel.fromJson(Map<String, dynamic> json) =
      _$AdminModelImpl.fromJson;

  @override
  String get uid;
  @override
  String get email;
  @override
  String get name;
  @override
  String get phone;
  @override
  String get address;
  @override
  String get role;
  @override
  String get lastLogin;
  @override
  double get latitude;
  @override
  double get longitude;
  @override
  @JsonKey(ignore: true)
  _$$AdminModelImplCopyWith<_$AdminModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
