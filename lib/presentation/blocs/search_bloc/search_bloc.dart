import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopbansach/presentation/blocs/search_bloc/search_event.dart';
import 'package:shopbansach/presentation/blocs/search_bloc/search_state.dart';
import '../../../domain/usecases/search_products_usecase.dart';
import '../product_list_bloc/product_list_bloc.dart';
import '../product_list_bloc/product_list_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchProductsUseCase searchProductsUseCase;
  final ProductListBloc productListBloc;

  SearchBloc({
    required this.searchProductsUseCase,
    required this.productListBloc,
  }) : super(SearchInitial()) {
    on<SearchTextChanged>(_onSearch);
  }

  void _onSearch(SearchTextChanged event, Emitter<SearchState> emit) {
    final productState = productListBloc.state;

    if (productState is ProductListLoaded) {
      final result = searchProductsUseCase.execute(
        productState.allProducts,
        event.query,
      );

      emit(SearchLoaded(result));
    }
  }
}