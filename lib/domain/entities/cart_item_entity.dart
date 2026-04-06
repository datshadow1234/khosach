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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productId': productId,
      'title': title,
      'quantity': quantity,
      'price': price,
      'imageUrl': imageUrl,
      'category': category,
      'author': author,
      'language': language,
      'country': country,
    };
  }

  factory CartItemEntity.fromJson(Map<String, dynamic> json) {
    return CartItemEntity(
      id: json['id'],
      productId: json['productId'],
      title: json['title'],
      quantity: json['quantity'],
      price: (json['price'] as num).toDouble(),
      imageUrl: json['imageUrl'],
      category: json['category'],
      author: json['author'],
      language: json['language'],
      country: json['country'],
    );
  }

  @override
  List<Object?> get props => [
    id,
    productId,
    title,
    quantity,
    price,
    imageUrl,
    category,
    author,
    language,
    country,
  ];
}