import 'package:equatable/equatable.dart';

class CartItemEntity extends Equatable {
  final String id;
  final String productId;
  final String title;
  final int quantity;
  final double price;
  final String imageUrl;
  final String category;
  final String author;
  final String language;
  final String country;

  const CartItemEntity({
    required this.id,
    required this.productId,
    required this.title,
    required this.quantity,
    required this.price,
    required this.imageUrl,
    required this.category,
    required this.author,
    required this.language,
    required this.country,
  });

  // THÊM HÀM NÀY VÀO ĐỂ HẾT LỖI GẠCH ĐỎ Ở REPOSITORY
  CartItemEntity copyWith({
    String? id,
    String? productId,
    String? title,
    int? quantity,
    double? price,
    String? imageUrl,
    String? category,
    String? author,
    String? language,
    String? country,
  }) {
    return CartItemEntity(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      title: title ?? this.title,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      category: category ?? this.category,
      author: author ?? this.author,
      language: language ?? this.language,
      country: country ?? this.country,
    );
  }

  double get totalPrice => price * quantity;

  @override
  List<Object?> get props => [id, productId, title, quantity, price, imageUrl, category, author, language, country];
}