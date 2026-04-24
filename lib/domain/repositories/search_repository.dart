import '../entities/product_entity.dart';

abstract class SearchRepository {
  List<ProductEntity> search(List<ProductEntity> products, String query);
}