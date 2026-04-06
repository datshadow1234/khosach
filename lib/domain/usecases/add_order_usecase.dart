import '../entities/order_entity.dart';
import '../repositories/order_repository.dart';

class AddOrderUseCase {
  final OrderRepository repository;
  AddOrderUseCase(this.repository);
  Future<void> call(OrderEntity order, String token) => repository.addOrder(order, token);
}