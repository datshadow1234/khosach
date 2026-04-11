import 'repositories.dart';

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

    if (response == null || response.isEmpty) return [];

    final Map<String, dynamic> data = Map<String, dynamic>.from(response);
    final List<OrderEntity> validOrders = [];

    for (var e in data.entries) {
      try {
        final model = OrderModel.fromJson(
          Map<String, dynamic>.from(e.value),
        );

        final products = (model.products as List)
            .map<CartItemEntity>(
              (p) => CartItemEntity.fromJson(Map<String, dynamic>.from(p as Map)),
        )
            .toList();

        validOrders.add(OrderEntity(
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
        ));
      } catch (_) {}
    }

    validOrders.sort((a, b) => b.dateTime.compareTo(a.dateTime));
    return validOrders;
  }
}