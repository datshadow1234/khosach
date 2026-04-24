import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'product_list.dart';

class ProductListBloc extends HydratedBloc<ProductListEvent, ProductListState> {
  final GetProductsUseCase getProductsUseCase;
  final SearchProductsUseCase searchProductsUseCase;

  ProductListBloc({
    required this.getProductsUseCase,
    required this.searchProductsUseCase,
  }) : super(ProductListInitial()) {
    on<FetchProductsEvent>(_onFetchProducts);
    on<RefreshProductsEvent>(_onRefreshProducts);
    on<SearchProductsEvent>(_onSearchProducts);
  }

  @override
  String get storagePrefix => 'product_list_bloc';

  // ✅ Bỏ hoàn toàn việc cache sản phẩm xuống disk
  @override
  ProductListState? fromJson(Map<String, dynamic> json) => ProductListInitial();

  @override
  Map<String, dynamic>? toJson(ProductListState state) => null;

  Future<void> _onFetchProducts(
    FetchProductsEvent event,
    Emitter<ProductListState> emit,
  ) async {
    final currentState = state;
    if (currentState is! ProductListLoaded) {
      emit(ProductListLoading());
    }

    try {
      final products = await getProductsUseCase.execute();
      emit(ProductListLoaded(allProducts: products, displayProducts: products));
    } catch (e) {
      if (currentState is ProductListLoaded) return;
      emit(ProductListError(e.toString()));
    }
  }

  Future<void> _onRefreshProducts(
    RefreshProductsEvent event,
    Emitter<ProductListState> emit,
  ) async {
    emit(ProductListLoading());
    try {
      final products = await getProductsUseCase.execute();
      emit(ProductListLoaded(allProducts: products, displayProducts: products));
    } catch (e) {
      emit(ProductListError(e.toString()));
    }
  }

  void _onSearchProducts(
    SearchProductsEvent event,
    Emitter<ProductListState> emit,
  ) {
    if (state is ProductListLoaded) {
      final current = state as ProductListLoaded;
      final filtered = searchProductsUseCase.execute(
        current.allProducts,
        event.query,
      );
      emit(current.copyWith(displayProducts: filtered));
    }
  }
}
