import '../entities/order_entity.dart';

abstract class OrderRepository {
  Future<void> addOrder(OrderEntity order, String token);
  Future<List<OrderEntity>> getOrders(String uid, String token);
}