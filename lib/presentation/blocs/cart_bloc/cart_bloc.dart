import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/cart_usecase/get_cart_usecase.dart';
import '../../../domain/usecases/cart_usecase/remove_cart_usecase.dart';
import '../../../domain/usecases/cart_usecase/add_to_cart_usecase.dart';
import '../../../domain/usecases/cart_usecase/clear_cart_usecase.dart';
import 'cart_event.dart';
import 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final GetCartUseCase getCartUseCase;
  final AddToCartUseCase addToCartUseCase;
  final RemoveCartUseCase removeCartUseCase;
  final ClearCartUseCase clearCartUseCase;

  CartBloc({
    required this.getCartUseCase,
    required this.addToCartUseCase,
    required this.removeCartUseCase,
    required this.clearCartUseCase,
  }) : super(CartInitial()) {
    on<LoadCartEvent>(_onLoad);
    on<AddCartEvent>(_onAdd);
    on<RemoveCartEvent>(_onRemove);
    on<ClearCartEvent>(_onClear);
  }

  Future<void> _onLoad(LoadCartEvent event, Emitter<CartState> emit) async {
    emit(CartLoading());
    try {
      final items = await getCartUseCase();
      final totalAmount = items.fold(0.0, (sum, item) => sum + (item.price * item.quantity));
      final totalQuantity = items.fold(0, (sum, item) => sum + item.quantity);

      emit(CartLoaded(
        items: items,
        totalAmount: totalAmount,
        totalQuantity: totalQuantity,
      ));
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  Future<void> _onAdd(AddCartEvent event, Emitter<CartState> emit) async {
    await addToCartUseCase(event.item);
    add(LoadCartEvent());
  }

  Future<void> _onRemove(RemoveCartEvent event, Emitter<CartState> emit) async {
    await removeCartUseCase(event.productId);
    add(LoadCartEvent());
  }

  Future<void> _onClear(ClearCartEvent event, Emitter<CartState> emit) async {
    await clearCartUseCase();
    add(LoadCartEvent());
  }
}