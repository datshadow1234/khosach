import 'usecase.dart';

class GetProductsUseCase {
  final ProductRepository repository;

  GetProductsUseCase({required this.repository});

  Future<List<ProductEntity>> execute() async {
    return await repository.fetchAllProducts();
  }
}