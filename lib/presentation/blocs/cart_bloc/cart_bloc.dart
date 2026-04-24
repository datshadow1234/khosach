import 'cart.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final GetCartUseCase getCartUseCase;
  final AddToCartUseCase addToCartUseCase;
  final UpdateCartItemUseCase updateCartItemUseCase;
  final RemoveCartUseCase removeCartUseCase;
  final ClearCartUseCase clearCartUseCase;

  CartBloc({
    required this.getCartUseCase,
    required this.addToCartUseCase,
    required this.updateCartItemUseCase,
    required this.removeCartUseCase,
    required this.clearCartUseCase,
  }) : super(CartInitial()) {
    on<LoadCartEvent>(_onLoad);
    on<AddCartEvent>(_onAdd);
    on<RemoveCartEvent>(_onRemove);
    on<ClearCartEvent>(_onClear);
    on<DecreaseCartItemEvent>(_onDecrease);
    on<ToggleSelectItemEvent>(_onToggleSelect);
  }

  List<CartItemEntity> _currentItems() {
    if (state is CartLoaded) {
      return List.from((state as CartLoaded).items);
    }
    return [];
  }

  Future<void> _onLoad(LoadCartEvent event, Emitter<CartState> emit) async {
    if (state is CartLoaded) return;

    emit(CartLoading());

    try {
      final items = await getCartUseCase();
      emit(_buildState(items));
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  Future<void> _onAdd(AddCartEvent event, Emitter<CartState> emit) async {
    final items = _currentItems();
    final index = items.indexWhere((e) => e.productId == event.item.productId);

    if (index >= 0) {
      items[index] = items[index].copyWith(quantity: items[index].quantity + 1);
      await updateCartItemUseCase(items[index]);
    } else {
      items.add(event.item);
      await addToCartUseCase(event.item);
    }

    emit(_buildState(items));
  }

  Future<void> _onRemove(RemoveCartEvent event, Emitter<CartState> emit) async {
    final items = _currentItems();
    items.removeWhere((e) => e.productId == event.productId);

    await removeCartUseCase(event.productId);
    emit(_buildState(items));
  }

  Future<void> _onClear(ClearCartEvent event, Emitter<CartState> emit) async {
    await clearCartUseCase();

    emit(const CartLoaded(items: [], totalAmount: 0, totalQuantity: 0));
  }

  Future<void> _onToggleSelect(
    ToggleSelectItemEvent event,
    Emitter<CartState> emit,
  ) async {
    final items = _currentItems();
    final index = items.indexWhere((e) => e.productId == event.productId);

    if (index >= 0) {
      final current = items[index];
      items[index] = current.copyWith(isSelected: !current.isSelected);

      await updateCartItemUseCase(items[index]);
      emit(_buildState(items));
    }
  }

  Future<void> _onDecrease(
    DecreaseCartItemEvent event,
    Emitter<CartState> emit,
  ) async {
    final items = _currentItems();
    final index = items.indexWhere((e) => e.productId == event.productId);

    if (index >= 0) {
      final current = items[index];

      if (current.quantity > 1) {
        items[index] = current.copyWith(quantity: current.quantity - 1);
        await updateCartItemUseCase(items[index]);
      } else {
        items.removeAt(index);
        await removeCartUseCase(event.productId);
      }

      emit(_buildState(items));
    }
  }

  CartLoaded _buildState(List<CartItemEntity> items) {
    final totalAmount = items
        .where((e) => e.isSelected)
        .fold(0.0, (sum, item) => sum + item.totalPrice);

    final totalQuantity = items
        .where((e) => e.isSelected)
        .fold(0, (sum, item) => sum + item.quantity);

    return CartLoaded(
      items: items,
      totalAmount: totalAmount,
      totalQuantity: totalQuantity,
    );
  }
}
