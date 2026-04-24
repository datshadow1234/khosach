import 'cart.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object?> get props => [];
}

class LoadCartEvent extends CartEvent {}
class AddCartEvent extends CartEvent {
  final CartItemEntity item;
  const AddCartEvent(this.item);

  @override
  List<Object?> get props => [item];
}

class RemoveCartEvent extends CartEvent {
  final String productId;
  const RemoveCartEvent(this.productId);

  @override
  List<Object?> get props => [productId];
}

class ClearCartEvent extends CartEvent {}
class ToggleSelectItemEvent extends CartEvent {
  final String productId;
  const ToggleSelectItemEvent(this.productId);
}
class DecreaseCartItemEvent extends CartEvent {
  final String productId;
  const DecreaseCartItemEvent(this.productId);

  @override
  List<Object?> get props => [productId];
}
