import 'package:equatable/equatable.dart';

class ProductEntity extends Equatable {
  final String id;
  final String title;
  final String category;
  final String author;
  final String language;
  final String coutry;
  final String description;
  final double price;
  final String imageUrl;

  const ProductEntity({
    required this.id,
    required this.title,
    required this.category,
    required this.author,
    required this.language,
    required this.coutry,
    required this.description,
    required this.price,
    required this.imageUrl,
  });

  ProductEntity copyWith({
    String? id,
    String? title,
    String? category,
    String? author,
    String? language,
    String? coutry,
    String? description,
    double? price,
    String? imageUrl,
  }) {
    return ProductEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      author: author ?? this.author,
      language: language ?? this.language,
      coutry: coutry ?? this.coutry,
      description: description ?? this.description,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  @override
  List<Object?> get props => [
    id,
    title,
    category,
    author,
    language,
    coutry,
    description,
    price,
    imageUrl,
  ];
}