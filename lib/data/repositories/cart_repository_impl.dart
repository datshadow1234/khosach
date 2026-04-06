import '../../domain/entities/cart_item_entity.dart';
import '../../domain/repositories/cart_repository.dart';
import '../clients/cart_client/cart_client.dart';
import '../datasources/auth_local_data_source.dart';
import '../models/cart_model/cart_item_model.dart';
class CartRepositoryImpl implements CartRepository {
  final CartClient cartClient;
  final AuthLocalDataSource authLocalDataSource;
  Map<String, CartItemEntity> _items = {};
  String? _currentUid;

  CartRepositoryImpl({
    required this.cartClient,
    required this.authLocalDataSource,
  });

  Future<void> _syncToServer() async {
    final uid = authLocalDataSource.getUid();
    final token = authLocalDataSource.getToken();

    if (uid == null || token == null) return;

    if (_items.isEmpty) {
      await cartClient.deleteCart(uid, token);
    } else {
      final data = _items.map((key, value) => MapEntry(key, value.toJson()));
      await cartClient.updateCart(uid, token, data);
    }
  }

  @override
  Future<List<CartItemEntity>> getCartItems() async {
    final uid = authLocalDataSource.getUid();
    final token = authLocalDataSource.getToken();

    if (uid == null || token == null) return [];

    if (_currentUid != uid || _items.isEmpty) {
      _currentUid = uid;
      try {
        final response = await cartClient.getCart(uid, token);
        _items.clear();
        if (response != null) {
          response.forEach((key, value) {
            final model = CartItemModel.fromJson(Map<String, dynamic>.from(value as Map));
            _items[key] = _mapModelToEntity(model);
          });
        }
      } catch (e) {
        print("Lỗi tải giỏ hàng từ Firebase: $e");
      }
    }
    return _items.values.toList();
  }

  CartItemEntity _mapModelToEntity(CartItemModel model) {
    return CartItemEntity(
      id: model.id,
      productId: model.productId,
      title: model.title,
      quantity: model.quantity,
      price: model.price,
      imageUrl: model.imageUrl,
      category: model.category,
      author: model.author,
      language: model.language,
      country: model.country,
    );
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
    await _syncToServer();
  }

  @override
  Future<void> removeCart(String productId) async {
    _items.remove(productId);
    await _syncToServer();
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
    await _syncToServer();
  }

  @override
  Future<void> clearCart() async {
    _items.clear();
    await _syncToServer();
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