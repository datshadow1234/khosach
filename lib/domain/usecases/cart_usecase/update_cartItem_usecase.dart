import '../../entities/cart_item_entity.dart';
import '../../repositories/cart_repository.dart';

class UpdateCartItemUseCase {
  final CartRepository repository;

  UpdateCartItemUseCase({required this.repository});

  Future<void> call(CartItemEntity item) async {
    await repository.updateCartItem(item);
  }
}