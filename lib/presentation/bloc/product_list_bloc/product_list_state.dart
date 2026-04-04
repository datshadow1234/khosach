import 'package:equatable/equatable.dart';
import '../../../domain/entities/product_entity.dart';

abstract class ProductListState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ProductListInitial extends ProductListState {}

class ProductListLoading extends ProductListState {}

class ProductListLoaded extends ProductListState {
  final List<ProductEntity> allProducts;
  final List<ProductEntity> displayProducts;

  ProductListLoaded({
    required this.allProducts,
    required this.displayProducts,
  });
  ProductListLoaded copyWith({
    List<ProductEntity>? allProducts,
    List<ProductEntity>? displayProducts,
  }) {
    return ProductListLoaded(
      allProducts: allProducts ?? this.allProducts,
      displayProducts: displayProducts ?? this.displayProducts,
    );
  }
  @override
  List<Object?> get props => [allProducts, displayProducts];
}

class ProductListError extends ProductListState {
  final String message;
  ProductListError(this.message);

  @override
  List<Object?> get props => [message];
}