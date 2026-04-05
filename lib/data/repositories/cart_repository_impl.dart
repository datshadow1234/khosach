import '../../domain/entities/cart_item_entity.dart';
import '../../domain/repositories/cart_repository.dart';

class CartRepositoryImpl implements CartRepository {
  final Map<String, CartItemEntity> _items = {};

  @override
  Future<List<CartItemEntity>> getCartItems() async {
    return _items.values.toList();
  }

  @override
  Future<void> addToCart(CartItemEntity item) async {
    if (_items.containsKey(item.productId)) {
      final existing = _items[item.productId]!;
      _items.update(
        item.productId,
            (_) => existing.copyWith(quantity: existing.quantity + 1),
      );
    } else {
      _items[item.productId] = item;
    }
  }

  @override
  Future<void> removeCart(String productId) async {
    _items.remove(productId);
  }

  @override
  Future<void> removeSingleItem(String productId) async {
    if (!_items.containsKey(productId)) return;
    final existing = _items[productId]!;
    if (existing.quantity > 1) {
      _items.update(
        productId,
            (_) => existing.copyWith(quantity: existing.quantity - 1),
      );
    } else {
      _items.remove(productId);
    }
  }

  @override
  Future<void> clearCart() async {
    _items.clear();
  }

  @override
  double getTotalAmount() {
    return _items.values.fold(0.0, (sum, item) => sum + (item.price * item.quantity));
  }

  @override
  int getTotalQuantity() {
    return _items.values.fold(0, (sum, item) => sum + item.quantity);
  }
}