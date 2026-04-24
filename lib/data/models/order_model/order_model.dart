import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../domain/entities/order_entity.dart';

part 'order_model.freezed.dart';
part 'order_model.g.dart';

@freezed
class OrderModel with _$OrderModel {
  const factory OrderModel({
    String? id,
    @Default(0.0) double amount,
    @Default(0.0) double shippingFee,
    @Default([]) List<Map<String, dynamic>> products,
    @Default(0) int totalQuantity,
    @Default('') String name,
    @Default('') String phone,
    @Default('') String address,
    @Default('') String customerId,
    @Default('') String payResult,
    @Default('2024-01-01T00:00:00.000') String dateTime,
  }) = _OrderModel;

  factory OrderModel.fromJson(Map<String, dynamic> json) =>
      _$OrderModelFromJson(json);

  factory OrderModel.fromEntity(OrderEntity entity) => OrderModel(
    amount: entity.amount,
    products: entity.products.map((e) => e.toJson()).toList(),
    totalQuantity: entity.totalQuantity,
    name: entity.name,
    phone: entity.phone,
    address: entity.address,
    customerId: entity.customerId,
    payResult: entity.payResult,
    dateTime: entity.dateTime.toIso8601String(),
  );
}