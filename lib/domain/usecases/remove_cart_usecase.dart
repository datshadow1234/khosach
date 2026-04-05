import '../repositories/cart_repository.dart';

class RemoveCartUseCase {
  final CartRepository repository;

  RemoveCartUseCase({required this.repository});

  Future<void> call(String productId) async {
    await repository.removeCart(productId);
  }
}