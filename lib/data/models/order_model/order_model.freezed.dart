// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'order_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

OrderModel _$OrderModelFromJson(Map<String, dynamic> json) {
  return _OrderModel.fromJson(json);
}

/// @nodoc
mixin _$OrderModel {
  String? get id => throw _privateConstructorUsedError;
  double get amount => throw _privateConstructorUsedError;
  List<Map<String, dynamic>> get products => throw _privateConstructorUsedError;
  int get totalQuantity => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get phone => throw _privateConstructorUsedError;
  String get address => throw _privateConstructorUsedError;
  String get customerId => throw _privateConstructorUsedError;
  String get payResult => throw _privateConstructorUsedError;
  String get dateTime => throw _privateConstructorUsedError;

  /// Serializes this OrderModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OrderModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OrderModelCopyWith<OrderModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrderModelCopyWith<$Res> {
  factory $OrderModelCopyWith(
          OrderModel value, $Res Function(OrderModel) then) =
      _$OrderModelCopyWithImpl<$Res, OrderModel>;
  @useResult
  $Res call(
      {String? id,
      double amount,
      List<Map<String, dynamic>> products,
      int totalQuantity,
      String name,
      String phone,
      String address,
      String customerId,
      String payResult,
      String dateTime});
}

/// @nodoc
class _$OrderModelCopyWithImpl<$Res, $Val extends OrderModel>
    implements $OrderModelCopyWith<$Res> {
  _$OrderModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OrderModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? amount = null,
    Object? products = null,
    Object? totalQuantity = null,
    Object? name = null,
    Object? phone = null,
    Object? address = null,
    Object? customerId = null,
    Object? payResult = null,
    Object? dateTime = null,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      products: null == products
          ? _value.products
          : products // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>,
      totalQuantity: null == totalQuantity
          ? _value.totalQuantity
          : totalQuantity // ignore: cast_nullable_to_non_nullable
              as int,
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
      customerId: null == customerId
          ? _value.customerId
          : customerId // ignore: cast_nullable_to_non_nullable
              as String,
      payResult: null == payResult
          ? _value.payResult
          : payResult // ignore: cast_nullable_to_non_nullable
              as String,
      dateTime: null == dateTime
          ? _value.dateTime
          : dateTime // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$OrderModelImplCopyWith<$Res>
    implements $OrderModelCopyWith<$Res> {
  factory _$$OrderModelImplCopyWith(
          _$OrderModelImpl value, $Res Function(_$OrderModelImpl) then) =
      __$$OrderModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? id,
      double amount,
      List<Map<String, dynamic>> products,
      int totalQuantity,
      String name,
      String phone,
      String address,
      String customerId,
      String payResult,
      String dateTime});
}

/// @nodoc
class __$$OrderModelImplCopyWithImpl<$Res>
    extends _$OrderModelCopyWithImpl<$Res, _$OrderModelImpl>
    implements _$$OrderModelImplCopyWith<$Res> {
  __$$OrderModelImplCopyWithImpl(
      _$OrderModelImpl _value, $Res Function(_$OrderModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of OrderModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? amount = null,
    Object? products = null,
    Object? totalQuantity = null,
    Object? name = null,
    Object? phone = null,
    Object? address = null,
    Object? customerId = null,
    Object? payResult = null,
    Object? dateTime = null,
  }) {
    return _then(_$OrderModelImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      products: null == products
          ? _value._products
          : products // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>,
      totalQuantity: null == totalQuantity
          ? _value.totalQuantity
          : totalQuantity // ignore: cast_nullable_to_non_nullable
              as int,
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
      customerId: null == customerId
          ? _value.customerId
          : customerId // ignore: cast_nullable_to_non_nullable
              as String,
      payResult: null == payResult
          ? _value.payResult
          : payResult // ignore: cast_nullable_to_non_nullable
              as String,
      dateTime: null == dateTime
          ? _value.dateTime
          : dateTime // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$OrderModelImpl implements _OrderModel {
  const _$OrderModelImpl(
      {this.id,
      this.amount = 0.0,
      final List<Map<String, dynamic>> products = const [],
      this.totalQuantity = 0,
      this.name = '',
      this.phone = '',
      this.address = '',
      this.customerId = '',
      this.payResult = '',
      this.dateTime = '2024-01-01T00:00:00.000'})
      : _products = products;

  factory _$OrderModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$OrderModelImplFromJson(json);

  @override
  final String? id;
  @override
  @JsonKey()
  final double amount;
  final List<Map<String, dynamic>> _products;
  @override
  @JsonKey()
  List<Map<String, dynamic>> get products {
    if (_products is EqualUnmodifiableListView) return _products;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_products);
  }

  @override
  @JsonKey()
  final int totalQuantity;
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
  final String customerId;
  @override
  @JsonKey()
  final String payResult;
  @override
  @JsonKey()
  final String dateTime;

  @override
  String toString() {
    return 'OrderModel(id: $id, amount: $amount, products: $products, totalQuantity: $totalQuantity, name: $name, phone: $phone, address: $address, customerId: $customerId, payResult: $payResult, dateTime: $dateTime)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrderModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            const DeepCollectionEquality().equals(other._products, _products) &&
            (identical(other.totalQuantity, totalQuantity) ||
                other.totalQuantity == totalQuantity) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.customerId, customerId) ||
                other.customerId == customerId) &&
            (identical(other.payResult, payResult) ||
                other.payResult == payResult) &&
            (identical(other.dateTime, dateTime) ||
                other.dateTime == dateTime));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      amount,
      const DeepCollectionEquality().hash(_products),
      totalQuantity,
      name,
      phone,
      address,
      customerId,
      payResult,
      dateTime);

  /// Create a copy of OrderModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OrderModelImplCopyWith<_$OrderModelImpl> get copyWith =>
      __$$OrderModelImplCopyWithImpl<_$OrderModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OrderModelImplToJson(
      this,
    );
  }
}

abstract class _OrderModel implements OrderModel {
  const factory _OrderModel(
      {final String? id,
      final double amount,
      final List<Map<String, dynamic>> products,
      final int totalQuantity,
      final String name,
      final String phone,
      final String address,
      final String customerId,
      final String payResult,
      final String dateTime}) = _$OrderModelImpl;

  factory _OrderModel.fromJson(Map<String, dynamic> json) =
      _$OrderModelImpl.fromJson;

  @override
  String? get id;
  @override
  double get amount;
  @override
  List<Map<String, dynamic>> get products;
  @override
  int get totalQuantity;
  @override
  String get name;
  @override
  String get phone;
  @override
  String get address;
  @override
  String get customerId;
  @override
  String get payResult;
  @override
  String get dateTime;

  /// Create a copy of OrderModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OrderModelImplCopyWith<_$OrderModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
