// import 'package:shopbansach/services/products_service.dart';
//
// import '../../models/product.dart';
//
// // import '../../models/auth_token.dart';
// import '../../models/product.dart';
// // import '../../services/products_service.dart';
//
// import 'package:flutter/foundation.dart';
//
// class ProductsManager with ChangeNotifier {
//   ProductsService _productsService = ProductsService();
//     late List<Product> _items = [
//   //   Product(
//   //     id: 'p1',
//   //     title: 'Red Shirt',
//   //     description: 'A red shirt - it is pretty red!',
//   //     price: 29.99,
//   //     imageUrl:
//   //         'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
//   //     category: 'kinh di',
//   //     author: 'thanh tra',
//   //     coutry: 'vietnam',
//   //     language: 'vietnam'
//
//   //   ),
//   ];
//   List<Product> _display_product = [];
//
//   Future<void> fetchProducts() async {
//     _items = await _productsService.fetchProducts();
//     print("AAAAAAAAAAAAAAAAAAAAAAA");
//     print(_items.length);
//     print("AAAAAAAAAAAAAAAAAAAAAAAAAAa");
//     notifyListeners();
//   }
//
//   Future<void> addProduct(Product product) async {
//     final newProduct = await _productsService.addProduct(product);
//     if (newProduct != null) {
//       _items.add(product);
//       notifyListeners();
//     }
//   }
//
//   int get itemCount {
//     return _items.length;
//   }
//
//   List<Product> get items {
//     return [..._items];
//   }
//   Product? findById(String id) {
//     try {
//       return _items.firstWhere((item) => item.id == id);
//     } catch (error) {
//       return null;
//     }
//   }
//
//   Future<void> updateProduct(Product product) async {
//     final index = _items.indexWhere((item) => item.id == product.id);
//     if (index >= 0) {
//       if (await _productsService.updateProduct(product)) {
//         _items[index] = product;
//         notifyListeners();
//       }
//     }
//   }
//
//   Future<void> deleteProduct(String id) async {
//     final index = _items.indexWhere((item) => item.id == id);
//     Product? exitstingProduct = _items[index];
//     _items.removeAt(index);
//     notifyListeners();
//
//     if (!await _productsService.deleteProduct(id)) {
//       _items.insert(index, exitstingProduct);
//       notifyListeners();
//     }
//   }
//
//   List<Product> updateList(String value) {
//     _display_product = _items
//         .where((element) =>
//             element.title.toLowerCase().contains(value.toLowerCase()))
//         .toList();
//     return _display_product;
//   }
//
//   int get display_product_Count {
//     return _display_product.length;
//   }
//   List<Product> get display_product {
//     return [..._display_product];
//   }
// }
