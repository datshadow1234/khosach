import 'package:flutter/foundation.dart';
import 'repositories.dart';

List<ProductEntity> _parseProductsIsolate(Map<String, dynamic> responseMap) {
  final List<ProductEntity> products = [];

  responseMap.forEach((key, value) {
    if (value != null) {
      final data = Map<String, dynamic>.from(value as Map);
      data['id'] = key;

      final model = ProductModel.fromJson(data);

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
          bookLink: model.bookLink,
          images: model.images,
          videoUrl: model.videoUrl,
        ),
      );
    }
  });

  return products;
}

class ProductRepositoryImpl implements ProductRepository {
  final ProductClient client;
  final AuthLocalDataSource authLocalDataSource;

  ProductRepositoryImpl(this.client, this.authLocalDataSource);

  @override
  Future<List<ProductEntity>> fetchAllProducts() async {
    final tokenData = await authLocalDataSource.getAuthToken();

    if (tokenData == null) {
      throw Exception('Token null');
    }

    final response = await client.getProducts(tokenData.token);

    if (response == null || response is! Map) {
      return [];
    }

    final Map<String, dynamic> responseMap = Map<String, dynamic>.from(
      response,
    );
    final products = await compute(_parseProductsIsolate, responseMap);
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
      'bookLink': product.bookLink,
      'images': product.images,
      'videoUrl': product.videoUrl,
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

    await client.updateProduct(
      product.id,
      tokenData.token,
      _productToJson(product),
    );
  }

  @override
  Future<void> deleteProduct(String id) async {
    final tokenData = await authLocalDataSource.getAuthToken();
    if (tokenData == null) throw Exception('Token null');

    await client.deleteProduct(id, tokenData.token);
  }
}
