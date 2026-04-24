import 'order.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final AddOrderUseCase addOrderUseCase;
  final GetOrdersUseCase getOrdersUseCase;
  final UpdateOrderStatusUseCase updateOrderStatusUseCase;

  OrderBloc({
    required this.addOrderUseCase,
    required this.getOrdersUseCase,
    required this.updateOrderStatusUseCase,
  }) : super(OrderInitial()) {
    on<AddOrderEvent>((event, emit) async {
      emit(OrderLoading());

      try {
        await addOrderUseCase(event.order, event.token);

        emit(Ordercompleted());
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
    on<UpdateOrderStatusEvent>((event, emit) async {
      try {
        await updateOrderStatusUseCase(
          event.orderId,
          event.newStatus,
          event.token,
        );

        final orders = await getOrdersUseCase(event.uid, event.token);

        emit(OrdersLoaded(orders));
      } catch (e) {
        emit(OrderError(e.toString()));
      }
    });
  }
}