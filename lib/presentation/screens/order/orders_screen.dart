import 'order_screen_widget.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName = '/orders';
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  void initState() {
    super.initState();
    _loadOrders();
  }
  Future<void> _loadOrders() async {
    final uid = await sl<AuthLocalDataSource>().getUid();
    final token = await sl<AuthLocalDataSource>().getToken();

    if (uid != null && token != null && mounted) {
      context.read<OrderBloc>().add(FetchOrdersEvent(uid, token));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ĐƠN HÀNG')),
      body: RefreshIndicator(
        onRefresh: _loadOrders,
        child: BlocBuilder<OrderBloc, OrderState>(
          builder: (context, state) {
            if (state is OrderLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is OrdersLoaded) {
              if (state.orders.isEmpty) {
                return const Center(child: Text('Đơn hàng trống!'));
              }
              return ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: state.orders.length,
                itemBuilder: (ctx, i) => GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => OrderDetailScreen(state.orders[i])),
                    );
                  },
                  child: OrderItemCard(state.orders[i]),
                ),
              );
            }
            if (state is OrderError) {
              return Center(child: Text(state.message));
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}