import '../entities/product_entity.dart';

abstract class ProductRepository {
  Future<List<ProductEntity>> fetchAllProducts();
  Future<void> addProduct(ProductEntity product);
  Future<void> updateProduct(ProductEntity product);
  Future<void> deleteProduct(String id);
}