import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/product_repository.dart';
import '../clients/products_client.dart';
import '../datasources/auth_local_data_source.dart';
import '../models/product_model.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductClient client;
  final AuthLocalDataSource authLocalDataSource;

  ProductRepositoryImpl(
      this.client,
      this.authLocalDataSource,
      );

  @override
  Future<List<ProductEntity>> fetchAllProducts() async {
    final tokenData = await authLocalDataSource.getAuthToken();

    if (tokenData == null) {
      throw Exception('Token null');
    }
    final response = await client.getProducts(tokenData.token);

    final List<ProductEntity> products = [];

    if (response == null) {
      return products;
    }

    response.forEach((key, value) {
      if (value != null) {
        final model = ProductModel.fromJson({
          'id': key,
          ...(value as Map<String, dynamic>),
        });

        products.add(
          ProductEntity(
            id: model.id ?? '',
            title: model.title,
            category: model.category,
            author: model.author,
            language: model.language,
            coutry: model.coutry,
            description: model.description,
            price: model.price,
            imageUrl: model.imageUrl,
          ),
        );
      }
    });

    return products;
  }
}