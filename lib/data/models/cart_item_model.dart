import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/cart_item_entity.dart';

part 'cart_item_model.freezed.dart';
part 'cart_item_model.g.dart';

@freezed
class CartItemModel with _$CartItemModel {
  const factory CartItemModel({
    @Default('') String id,
    @JsonKey(name: 'productId') @Default('') String productId,
    @Default('') String title,
    @Default(1) int quantity,
    @Default(0) double price,
    @Default('') String imageUrl,
    @Default('') String category,
    @Default('') String author,
    @Default('') String language,
    @JsonKey(name: 'country') @Default('') String country,
  }) = _CartItemModel;

  factory CartItemModel.fromJson(Map<String, dynamic> json) =>
      _$CartItemModelFromJson(json);
}