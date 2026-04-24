import 'search.dart';

abstract class SearchState {}

class SearchInitial extends SearchState {}

class SearchLoaded extends SearchState {
  final List<ProductEntity> products;

  SearchLoaded(this.products);
}