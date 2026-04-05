import '../entities/cart_item_entity.dart';

abstract class CartRepository {
  Future<List<CartItemEntity>> getCartItems();
  Future<void> addToCart(CartItemEntity item);
  Future<void> removeCart(String productId);
  Future<void> removeSingleItem(String productId);
  Future<void> clearCart();
  double getTotalAmount();
  int getTotalQuantity();
}