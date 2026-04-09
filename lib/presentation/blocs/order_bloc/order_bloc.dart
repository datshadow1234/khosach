import 'order_bloc_widget.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final AddOrderUseCase addOrderUseCase;
  final GetOrdersUseCase getOrdersUseCase;

  OrderBloc({
    required this.addOrderUseCase,
    required this.getOrdersUseCase,
  }) : super(OrderInitial()) {
    on<AddOrderEvent>((event, emit) async {
      emit(OrderLoading());

      try {
        await addOrderUseCase(event.order, event.token);

        emit(OrderSuccess());
      } catch (e) {
        emit(OrderError(e.toString()));
      }
    });

    on<FetchOrdersEvent>((event, emit) async {
      emit(OrderLoading());

      try {
        final orders = await getOrdersUseCase(
          event.uid,
          event.token,
        );

        emit(OrdersLoaded(orders));
      } catch (e) {
        emit(OrderError(e.toString()));
      }
    });
  }
}