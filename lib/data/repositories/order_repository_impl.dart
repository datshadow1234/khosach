import 'repositories.dart';

import 'package:flutter/foundation.dart';

List<OrderEntity> _parseOrdersIsolate(Map<String, dynamic> data) {
  final List<OrderEntity> validOrders = [];

  for (var e in data.entries) {
    try {
      var orderData = Map<String, dynamic>.from(e.value);
      if (orderData['amount'] is int) {
        orderData['amount'] = (orderData['amount'] as int).toDouble();
      }
      if (orderData['shippingFee'] is int) {
        orderData['shippingFee'] = (orderData['shippingFee'] as int).toDouble();
      }

      final model = OrderModel.fromJson(orderData);
      final products = (model.products).map<CartItemEntity>((p) {
        final pData = Map<String, dynamic>.from(p);
        return CartItemEntity.fromJson({
          'id': pData['id'] ?? '',
          'productId': pData['productId'] ?? '',
          'title': pData['title'] ?? '',
          'quantity': pData['quantity'] ?? 1,
          'price': pData['price'] ?? 0,
          'imageUrl': pData['imageUrl'] ?? '',
          'category': pData['category'] ?? '',
          'author': pData['author'] ?? '',
          'language': pData['language'] ?? '',
          'country': pData['country'] ?? '',
          'bookLink': pData['bookLink'] ?? '',
          'isSelected': pData['isSelected'] ?? true,
        });
      }).toList();

      validOrders.add(
        OrderEntity(
          id: e.key,
          amount: model.amount,
          shippingFee: model.shippingFee,
          products: products,
          totalQuantity: model.totalQuantity,
          name: model.name,
          phone: model.phone,
          address: model.address,
          customerId: model.customerId,
          payResult: model.payResult,
          dateTime: DateTime.parse(model.dateTime),
          status: orderData['status'] ?? 'placed',
        ),
      );
    } catch (error) {
      debugPrint("Lỗi parse đơn hàng ID ${e.key}: $error");
    }
  }

  validOrders.sort((a, b) => b.dateTime.compareTo(a.dateTime));
  return validOrders;
}

class OrderRepositoryImpl implements OrderRepository {
  final OrderClient orderClient;

  OrderRepositoryImpl({required this.orderClient});

  @override
  Future<void> addOrder(OrderEntity order, String token) async {
    await orderClient.createOrder(token, OrderModel.fromEntity(order).toJson());
  }

  @override
  Future<void> updateOrderStatus(
    String orderId,
    String status,
    String token,
  ) async {
    await orderClient.updateOrderStatus(orderId, token, {"status": status});
  }

  @override
  Future<List<OrderEntity>> getOrders(String uid, String token) async {
    try {
      final response = uid.isEmpty
          ? await orderClient.getOrders(token, null, null)
          : await orderClient.getOrders(token, '"customerId"', '"$uid"');

      if (response == null || response is! Map || response.isEmpty) return [];
      if (response.containsKey('error')) {
        debugPrint('Firebase Error: ${response['error']}');
        return [];
      }

      final Map<String, dynamic> data = Map<String, dynamic>.from(response);
      return await compute(_parseOrdersIsolate, data);
    } catch (e) {
      debugPrint("LỖI GỌI API GET ORDERS: $e");
      return [];
    }
  }
}
