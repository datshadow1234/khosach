// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProductModelImpl _$$ProductModelImplFromJson(Map<String, dynamic> json) =>
    _$ProductModelImpl(
      id: json['id'] as String?,
      title: json['title'] as String? ?? '',
      category: json['category'] as String? ?? '',
      author: json['author'] as String? ?? '',
      language: json['language'] as String? ?? '',
      coutry: json['coutry'] as String? ?? '',
      description: json['description'] as String? ?? '',
      price: json['price'] == null ? 0.0 : _priceFromJson(json['price']),
      imageUrl: json['imageUrl'] as String? ?? '',
      bookLink: json['bookLink'] as String? ?? '',
      images:
          json['images'] == null ? const [] : _imagesFromJson(json['images']),
      videoUrl: json['videoUrl'] as String? ?? '',
    );

Map<String, dynamic> _$$ProductModelImplToJson(_$ProductModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'category': instance.category,
      'author': instance.author,
      'language': instance.language,
      'coutry': instance.coutry,
      'description': instance.description,
      'price': instance.price,
      'imageUrl': instance.imageUrl,
      'bookLink': instance.bookLink,
      'images': instance.images,
      'videoUrl': instance.videoUrl,
    };
