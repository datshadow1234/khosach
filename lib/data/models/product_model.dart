import 'package:freezed_annotation/freezed_annotation.dart';

part 'product_model.freezed.dart';
part 'product_model.g.dart';

double _priceFromJson(dynamic value) {
  if (value is int) return value.toDouble();
  if (value is double) return value;
  return 0.0;
}

@freezed
class ProductModel with _$ProductModel {
  const factory ProductModel({
    @JsonKey(name: 'id') String? id,
    @Default('') String title,
    @Default('') String category,
    @Default('') String author,
    @Default('') String language,
    @JsonKey(name: 'coutry') @Default('') String coutry,
    @Default('') String description,
    @JsonKey(fromJson: _priceFromJson) @Default(0.0) double price,
    @Default('') String imageUrl,
  }) = _ProductModel;
  factory ProductModel.fromJson(Map<String, dynamic> json) =>
      _$ProductModelFromJson(json);
}