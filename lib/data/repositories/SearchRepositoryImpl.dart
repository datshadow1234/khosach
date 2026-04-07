import 'repositories_widget.dart';

class SearchRepositoryImpl implements SearchRepository {
  @override
  List<ProductEntity> search(List<ProductEntity> products, String query) {
    return products.where((product) {
      return product.title.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }
}
