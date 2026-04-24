import 'package:shopbansach/presentation/blocs/product_list_bloc/product_list_state.dart';

import 'search.dart';

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
