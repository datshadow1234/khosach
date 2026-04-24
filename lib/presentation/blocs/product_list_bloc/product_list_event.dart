import 'package:shopbansach/presentation/blocs/admin_product_bloc/admin_product.dart';

abstract class ProductListEvent {}

class FetchProductsEvent extends ProductListEvent {}

class RefreshProductsEvent extends ProductListEvent {}

class SearchProductsEvent extends ProductListEvent {
  final String query;
  SearchProductsEvent(this.query);
}

abstract class ProductListState extends Equatable {
  @override
  List<Object?> get props => [];
}
