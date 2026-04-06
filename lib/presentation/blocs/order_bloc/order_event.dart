import '../../../domain/entities/order_entity.dart';

abstract class OrderEvent {}

class AddOrderEvent extends OrderEvent {
  final OrderEntity order;
  final String token;

  AddOrderEvent(this.order, this.token);
}

class FetchOrdersEvent extends OrderEvent {
  final String uid;
  final String token;

  FetchOrdersEvent(this.uid, this.token);
}