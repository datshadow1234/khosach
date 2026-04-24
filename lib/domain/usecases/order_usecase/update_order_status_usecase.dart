import '../../repositories/order_repository.dart';

class UpdateOrderStatusUseCase {
  final OrderRepository repository;

  UpdateOrderStatusUseCase(this.repository);

  Future<void> call(String orderId, String status, String token) {
    return repository.updateOrderStatus(orderId, status, token);
  }
}