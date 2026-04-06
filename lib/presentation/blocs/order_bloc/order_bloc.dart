import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/add_order_usecase.dart';
import '../../../domain/usecases/get_orders_usecase.dart';
import 'order_event.dart';
import 'order_state.dart';

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
        add(FetchOrdersEvent(event.order.customerId, event.token));

      } catch (e) {
        emit(OrderError(e.toString()));
      }
    });
    on<FetchOrdersEvent>((event, emit) async {
      emit(OrderLoading());
      try {
        final orders = await getOrdersUseCase(event.uid, event.token);
        emit(OrdersLoaded(orders));
      } catch (e) {
        emit(OrderError(e.toString()));
      }
    });
  }
}