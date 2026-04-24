import '../entities/order_entity.dart';

abstract class OrderRepository {
  Future<void> addOrder(OrderEntity order, String token);
  Future<List<OrderEntity>> getOrders(String uid, String token);
  Future<void> updateOrderStatus(
      String orderId,
      String status,
      String token,
      );
}