import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/get_products_usecase.dart';
import '../../../domain/usecases/search_products_usecase.dart';
import '../product_list/product_list_event.dart';
import '../product_list/product_list_state.dart';
class ProductListBloc extends Bloc<ProductListEvent, ProductListState> {
  final GetProductsUseCase getProductsUseCase;
  final SearchProductsUseCase searchProductsUseCase;

  ProductListBloc({
    required this.getProductsUseCase,
    required this.searchProductsUseCase,
  }) : super(ProductListInitial()) {
    on<FetchProductsEvent>(_onFetchProducts);
    on<SearchProductsEvent>(_onSearchProducts);
  }

  Future<void> _onFetchProducts(FetchProductsEvent event, Emitter<ProductListState> emit) async {
    emit(ProductListLoading());
    try {
      final products = await getProductsUseCase.execute();
      emit(ProductListLoaded(allProducts: products, displayProducts: products));
    } catch (e) {
      emit(ProductListError(e.toString()));
    }
  }

  void _onSearchProducts(SearchProductsEvent event, Emitter<ProductListState> emit) {
    if (state is ProductListLoaded) {
      final current = state as ProductListLoaded;
      final filtered = searchProductsUseCase.execute(current.allProducts, event.query);
      emit(current.copyWith(displayProducts: filtered));
    }
  }
}