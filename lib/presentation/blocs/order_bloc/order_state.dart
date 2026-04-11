import 'order.dart';
abstract class OrderState {}

class OrderInitial extends OrderState {}
class OrderLoading extends OrderState {}
class OrderSuccess extends OrderState {}
class OrdersLoaded extends OrderState {
  final List<OrderEntity> orders;
  OrdersLoaded(this.orders);
}

class OrderError extends OrderState {
  final String message;

  OrderError(this.message);
}