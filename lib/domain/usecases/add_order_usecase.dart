import 'usecase_widget.dart';

class AddOrderUseCase {
  final OrderRepository repository;
  AddOrderUseCase(this.repository);
  Future<void> call(OrderEntity order, String token) => repository.addOrder(order, token);
}