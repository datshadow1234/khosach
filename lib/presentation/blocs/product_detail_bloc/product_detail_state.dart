abstract class ProductDetailState {}

class ProductDetailInitial extends ProductDetailState {}
class ProductDetailLoading extends ProductDetailState {}
class ProductDetailLoaded extends ProductDetailState {
  final dynamic product;

  ProductDetailLoaded(this.product);
}

class ProductDetailError extends ProductDetailState {
  final String message;

  ProductDetailError(this.message);
}