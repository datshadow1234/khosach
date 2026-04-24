abstract class ProductDetailEvent {}

class LoadProductDetailEvent extends ProductDetailEvent {
  final dynamic product;

  LoadProductDetailEvent(this.product);
}