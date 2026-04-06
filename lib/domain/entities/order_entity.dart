import 'package:equatable/equatable.dart';
import 'cart_item_entity.dart';

class OrderEntity extends Equatable {
  final String? id;
  final double amount;
  final List<CartItemEntity> products;
  final int totalQuantity;
  final String name;
  final String phone;
  final String address;
  final String customerId;
  final String payResult;
  final DateTime dateTime;

  const OrderEntity({
    this.id,
    required this.amount,
    required this.products,
    required this.totalQuantity,
    required this.name,
    required this.phone,
    required this.address,
    required this.customerId,
    required this.payResult,
    required this.dateTime,
  });

  int get productCount => products.length;

  @override
  List<Object?> get props => [
    id,
    amount,
    products,
    totalQuantity,
    name,
    phone,
    address,
    customerId,
    payResult,
    dateTime,
  ];
}