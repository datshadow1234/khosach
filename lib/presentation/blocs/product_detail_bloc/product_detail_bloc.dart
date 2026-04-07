import 'product_detail_bloc_widget.dart';

class ProductDetailBloc extends Bloc<ProductDetailEvent, ProductDetailState> {
  ProductDetailBloc() : super(ProductDetailInitial()) {
    on<LoadProductDetailEvent>(_onLoadProductDetail);
  }

  Future<void> _onLoadProductDetail(
      LoadProductDetailEvent event,
      Emitter<ProductDetailState> emit,
      ) async {
    try {
      emit(ProductDetailLoading());

      await Future.delayed(const Duration(milliseconds: 500));

      emit(ProductDetailLoaded(event.product));
    } catch (e) {
      emit(ProductDetailError(e.toString()));
    }
  }
}