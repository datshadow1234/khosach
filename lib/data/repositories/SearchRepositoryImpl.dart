import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/search_repository.dart';

class SearchRepositoryImpl implements SearchRepository {
  @override
  List<ProductEntity> search(List<ProductEntity> products, String query) {
    return products.where((product) {
      return product.title.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }
}
