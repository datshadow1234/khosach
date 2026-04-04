import '../entities/product_entity.dart';
import '../repositories/search_repository.dart';

class SearchProductsUseCase {
  final SearchRepository repository;

  SearchProductsUseCase({
    required this.repository,
  });

  List<ProductEntity> execute(List<ProductEntity> allProducts, String query) {
    return repository.search(allProducts, query);
  }
}

