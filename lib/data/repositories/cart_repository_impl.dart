import 'repositories.dart';

class CartRepositoryImpl implements CartRepository {
  final CartClient cartClient;
  final AuthLocalDataSource authLocalDataSource;

  Map<String, CartItemEntity> _items = {};
  String? _currentUid;

  CartRepositoryImpl({
    required this.cartClient,
    required this.authLocalDataSource,
  });

  Future<void> resetCartCache() async {
    _items.clear();
    _currentUid = null;
  }

  Future<void> _syncToServer() async {
    final uid = authLocalDataSource.getUid();
    final token = authLocalDataSource.getToken();

    if (uid == null || token == null) return;

    if (_items.isEmpty) {
      await cartClient.deleteCart(uid, token);
      return;
    }

    final data = _items.map(
          (key, value) => MapEntry(key, value.toJson()),
    );

    await cartClient.updateCart(uid, token, data);
  }

  @override
  Future<List<CartItemEntity>> getCartItems() async {
    final uid = authLocalDataSource.getUid();
    final token = authLocalDataSource.getToken();

    if (uid == null || token == null) return [];

    if (_currentUid != uid) {
      _items.clear();
      _currentUid = uid;
    }

    try {
      final response = await cartClient.getCart(uid, token);

      _items.clear();

      if (response != null) {
        response.forEach((key, value) {
          final model = CartItemModel.fromJson(Map<String, dynamic>.from(value));
          _items[key] = _mapModelToEntity(model);
        });
      }
    } catch (_) {}

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
    final key = item.productId ?? item.id;
    if (key == null) return;

    if (_items.containsKey(key)) {
      final existing = _items[key]!;
      _items[key] = existing.copyWith(quantity: existing.quantity + 1);
    } else {
      _items[key] = item;
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
      _items[productId] = existing.copyWith(quantity: existing.quantity - 1);
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
    return _items.values.fold(0.0, (sum, item) => sum + item.totalPrice);
  }

  @override
  int getTotalQuantity() {
    return _items.values.fold(0, (sum, item) => sum + item.quantity);
  }
}