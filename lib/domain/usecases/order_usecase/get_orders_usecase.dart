import '../usecase.dart';

class GetOrdersUseCase {
  final OrderRepository repository;

  GetOrdersUseCase(this.repository);

  Future<List<OrderEntity>> call(String uid, String token) async {
    return await repository.getOrders(uid, token);
  }
}