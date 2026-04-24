import 'repositories.dart';

class CartRepositoryImpl implements CartRepository {
  final CartClient cartClient;
  final AuthLocalDataSource authLocalDataSource;

  Map<String, CartItemEntity> _items = {};
  String? _currentUid;
  bool _isLoaded = false;

  CartRepositoryImpl({
    required this.cartClient,
    required this.authLocalDataSource,
  });

  Future<void> resetCartCache() async {
    _items.clear();
    _currentUid = null;
    _isLoaded = false;
  }

  Future<void> _syncToServer() async {
    final uid = authLocalDataSource.getUid();
    final token = authLocalDataSource.getToken();

    if (uid == null || token == null) return;

    try {
      if (_items.isEmpty) {
        await cartClient.deleteCart(uid, token);
        return;
      }

      final data = _items.map((key, value) => MapEntry(key, value.toJson()));

      await cartClient.updateCart(uid, token, data);
    } catch (e) {
      debugPrint('Lỗi đồng bộ giỏ hàng lên server: $e');
    }
  }

  @override
  Future<List<CartItemEntity>> getCartItems() async {
    final uid = authLocalDataSource.getUid();
    final token = authLocalDataSource.getToken();

    if (uid == null || token == null) return [];

    try {
      final response = await cartClient.getCart(uid, token);
      final Map<String, CartItemEntity> freshItems = {};

      if (response != null && response is Map) {
        response.forEach((key, value) {
          final model = CartItemModel.fromJson(
            Map<String, dynamic>.from(value),
          );
          freshItems[key] = _mapModelToEntity(model);
        });
      }

      _items = freshItems;
      _currentUid = uid;
      _isLoaded = true;
    } catch (e) {
      debugPrint('Lỗi kéo giỏ hàng từ server: $e');
    }

    return _items.values.toList();
  }

  Future<void> _ensureLoaded() async {
    if (!_isLoaded) {
      await getCartItems();
    }
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
      bookLink: model.bookLink,
    );
  }

  @override
  Future<void> addToCart(CartItemEntity item) async {
    await _ensureLoaded();

    final key = item.productId;

    if (_items.containsKey(key)) {
      final existing = _items[key]!;
      _items[key] = existing.copyWith(quantity: existing.quantity + 1);
    } else {
      _items[key] = item;
    }

    _syncToServer();
  }

  @override
  Future<void> removeCart(String productId) async {
    _items.remove(productId);
    _syncToServer();
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
    _syncToServer();
  }

  @override
  Future<void> updateCartItem(CartItemEntity item) async {
    await _ensureLoaded();

    _items[item.productId] = item;

    _syncToServer();
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
