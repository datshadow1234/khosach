import '../../../domain/entities/product_entity.dart';

abstract class ProductDetailState {}
class ProductDetailInitial extends ProductDetailState {}
class ProductDetailLoading extends ProductDetailState {}
class ProductDetailLoaded extends ProductDetailState {
  final ProductEntity product;
  ProductDetailLoaded(this.product);
}