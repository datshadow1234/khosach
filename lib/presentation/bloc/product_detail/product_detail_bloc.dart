import 'package:flutter_bloc/flutter_bloc.dart';

import 'product_detail_event.dart';
import 'product_detail_state.dart';

class ProductDetailBloc extends Bloc<ProductDetailEvent, ProductDetailState> {
  ProductDetailBloc() : super(ProductDetailInitial()) {
    on<LoadProductDetailEvent>((event, emit) {
      emit(ProductDetailLoading());
      emit(ProductDetailLoaded(event.product));
    });
  }
}