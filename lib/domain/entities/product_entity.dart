import 'package:equatable/equatable.dart';

double _priceFromJson(dynamic value) {
  if (value is int) return value.toDouble();
  if (value is double) return value;
  if (value is String) return double.tryParse(value) ?? 0.0;
  return 0.0;
}

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
  final String bookLink;
  final List<String> images;
  final String videoUrl;

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
    required this.bookLink,
    this.images = const [],
    this.videoUrl = '',
  });

  factory ProductEntity.fromJson(Map<String, dynamic> json) {
    return ProductEntity(
      id: (json['id'] ?? '').toString(),
      title: (json['title'] ?? '').toString(),
      category: (json['category'] ?? '').toString(),
      author: (json['author'] ?? '').toString(),
      language: (json['language'] ?? '').toString(),
      coutry: (json['coutry'] ?? '').toString(),
      description: (json['description'] ?? '').toString(),
      price: _priceFromJson(json['price']),
      imageUrl: (json['imageUrl'] ?? '').toString(),
      bookLink: (json['bookLink'] ?? '').toString(),
      images:
          (json['images'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      videoUrl: (json['videoUrl'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'category': category,
      'author': author,
      'language': language,
      'coutry': coutry,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'bookLink': bookLink,
      'images': images,
      'videoUrl': videoUrl,
    };
  }

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
    String? bookLink,
    List<String>? images,
    String? videoUrl,
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
      bookLink: bookLink ?? this.bookLink,
      images: images ?? this.images,
      videoUrl: videoUrl ?? this.videoUrl,
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
    bookLink,
    images,
    videoUrl,
  ];
}
