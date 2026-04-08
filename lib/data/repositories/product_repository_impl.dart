import 'repositories_widget.dart';

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
  Map<String, dynamic> _productToJson(ProductEntity product) {
    return {
      'title': product.title,
      'category': product.category,
      'author': product.author,
      'language': product.language,
      'coutry': product.coutry,
      'description': product.description,
      'price': product.price,
      'imageUrl': product.imageUrl,
    };
  }

  @override
  Future<void> addProduct(ProductEntity product) async {
    final tokenData = await authLocalDataSource.getAuthToken();
    if (tokenData == null) throw Exception('Token null');

    await client.addProduct(tokenData.token, _productToJson(product));
  }

  @override
  Future<void> updateProduct(ProductEntity product) async {
    final tokenData = await authLocalDataSource.getAuthToken();
    if (tokenData == null) throw Exception('Token null');

    await client.updateProduct(product.id, tokenData.token, _productToJson(product));
  }

  @override
  Future<void> deleteProduct(String id) async {
    final tokenData = await authLocalDataSource.getAuthToken();
    if (tokenData == null) throw Exception('Token null');

    await client.deleteProduct(id, tokenData.token);
  }
}
