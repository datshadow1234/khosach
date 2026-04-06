import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../domain/entities/order_entity.dart';

part 'order_model.freezed.dart';
part 'order_model.g.dart';

@freezed
class OrderModel with _$OrderModel {
  const factory OrderModel({
    String? id,
    required double amount,
    required List<Map<String, dynamic>> products,
    required int totalQuantity,
    required String name,
    required String phone,
    required String address,
    required String customerId,
    required String payResult,
    required String dateTime,
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