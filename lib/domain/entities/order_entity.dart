import 'package:equatable/equatable.dart';
import 'cart_item_entity.dart';

class OrderEntity extends Equatable {
  final String? id;
  final double amount;
  final double shippingFee;
  final List<CartItemEntity> products;
  final int totalQuantity;
  final String name;
  final String phone;
  final String address;
  final String customerId;
  final String payResult;
  final DateTime dateTime;
  final String status;

  const OrderEntity({
    this.id,
    required this.amount,
    required this.shippingFee,
    required this.products,
    required this.totalQuantity,
    required this.name,
    required this.phone,
    required this.address,
    required this.customerId,
    required this.payResult,
    required this.dateTime,
    this.status = 'pending',
  });

  OrderEntity copyWith({String? status}) {
    return OrderEntity(
      id: id,
      amount: amount,
      shippingFee: shippingFee,
      products: products,
      totalQuantity: totalQuantity,
      name: name,
      phone: phone,
      address: address,
      customerId: customerId,
      payResult: payResult,
      dateTime: dateTime,
      status: status ?? this.status,
    );
  }

  int get productCount => products.length;

  @override
  List<Object?> get props => [
    id,
    amount,
    shippingFee,
    products,
    totalQuantity,
    name,
    phone,
    address,
    customerId,
    payResult,
    dateTime,
    status,
  ];
}
