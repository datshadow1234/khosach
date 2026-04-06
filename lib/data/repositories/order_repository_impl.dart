import '../../domain/entities/cart_item_entity.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/repositories/order_repository.dart';
import '../clients/order_client/order_client.dart';
import '../models/order_model/order_model.dart';

class OrderRepositoryImpl implements OrderRepository {
  final OrderClient orderClient;

  OrderRepositoryImpl({required this.orderClient});

  @override
  Future<void> addOrder(OrderEntity order, String token) async {
    await orderClient.createOrder(
      token,
      OrderModel.fromEntity(order).toJson(),
    );
  }

  @override
  Future<List<OrderEntity>> getOrders(String uid, String token) async {
    final response = await orderClient.getOrders(
      token,
      '"customerId"',
      '"$uid"',
    );

    if (response == null) return [];
    final Map<String, dynamic> data = Map<String, dynamic>.from(response as Map);
    return data.entries.map<OrderEntity>((e) {
      final model = OrderModel.fromJson(
        Map<String, dynamic>.from(e.value as Map),
      );

      final products = model.products
          .map<CartItemEntity>((p) => CartItemEntity.fromJson(Map<String, dynamic>.from(p as Map)))
          .toList();

      return OrderEntity(
        id: e.key,
        amount: model.amount,
        products: products,
        totalQuantity: model.totalQuantity,
        name: model.name,
        phone: model.phone,
        address: model.address,
        customerId: model.customerId,
        payResult: model.payResult,
        dateTime: DateTime.parse(model.dateTime),
      );
    }).toList();
  }
}