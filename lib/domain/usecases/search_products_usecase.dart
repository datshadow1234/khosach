import '../entities/product_entity.dart';

class SearchProductsUseCase {
  List<ProductEntity> execute(List<ProductEntity> allProducts, String query) {
    return allProducts
        .where((p) => p.title.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }
}