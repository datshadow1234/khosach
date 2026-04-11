import 'product_list.dart';
abstract class ProductListEvent {}

class FetchProductsEvent extends ProductListEvent {}

class SearchProductsEvent extends ProductListEvent {
  final String query;

  SearchProductsEvent(this.query);
}