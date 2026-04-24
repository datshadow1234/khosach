import '../usecase.dart';

class AddProductUseCase {
  final ProductRepository repository;
  AddProductUseCase({required this.repository});
  Future<void> execute(ProductEntity product) => repository.addProduct(product);
}

class UpdateProductUseCase {
  final ProductRepository repository;
  UpdateProductUseCase({required this.repository});
  Future<void> execute(ProductEntity product) => repository.updateProduct(product);
}

class DeleteProductUseCase {
  final ProductRepository repository;
  DeleteProductUseCase({required this.repository});
  Future<void> execute(String id) => repository.deleteProduct(id);
}