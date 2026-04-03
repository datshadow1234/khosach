import '../../../domain/entities/product_entity.dart';

abstract class ProductDetailEvent {}
class LoadProductDetailEvent extends ProductDetailEvent {
  final ProductEntity product;
  LoadProductDetailEvent(this.product);
}