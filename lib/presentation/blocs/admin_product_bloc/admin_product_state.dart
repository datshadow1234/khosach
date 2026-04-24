import 'admin_product.dart';

abstract class AdminProductState extends Equatable {
  @override
  List<Object?> get props => [];
}
class AdminProductInitial extends AdminProductState {}
class AdminProductLoading extends AdminProductState {}
class AdminProductActionLoading extends AdminProductState {}
class AdminProductActionSuccess extends AdminProductState {}
class AdminProductError extends AdminProductState {
  final String message;
  AdminProductError(this.message);
  @override
  List<Object?> get props => [message];
}
class AdminProductLoaded extends AdminProductState {
  final List<ProductEntity> allProducts;
  final List<ProductEntity> displayProducts;
  AdminProductLoaded({required this.allProducts, required this.displayProducts});
  @override
  List<Object?> get props => [allProducts, displayProducts];
}