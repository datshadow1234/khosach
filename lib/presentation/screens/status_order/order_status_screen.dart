import 'package:intl/intl.dart';
import 'status_order.dart';

class OrderStatusScreen extends HookWidget {
  const OrderStatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tabController = useTabController(initialLength: 5);
    final formatter = NumberFormat.currency(
      locale: 'vi_VN',
      symbol: 'VNĐ',
      decimalDigits: 0,
    );

    useEffect(() {
      final authState = context.read<AuthBloc>().state;
      if (authState is AuthAuthenticated) {
        final token = authState.authToken.token;
        context.read<OrderBloc>().add(FetchOrdersEvent('', token));
      }
      return null;
    }, []);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản Lý Đơn Hàng'),
        bottom: TabBar(
          controller: tabController,
          isScrollable: true,
          tabs: const [
            Tab(text: 'Tất cả'),
            Tab(text: 'Đã đặt'),
            Tab(text: 'Đang chuẩn bị'),
            Tab(text: 'Đang giao'),
            Tab(text: 'Thành công'),
          ],
        ),
      ),
      body: BlocBuilder<OrderBloc, OrderState>(
        builder: (context, state) {
          if (state is OrderLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is OrderError) {
            return Center(child: Text('Lỗi: ${state.message}'));
          }

          if (state is OrdersLoaded) {
            final allOrders = state.orders;

            final placedOrders = allOrders
                .where((o) => o.status == 'placed')
                .toList();
            final preparingOrders = allOrders
                .where((o) => o.status == 'preparing')
                .toList();
            final deliveringOrders = allOrders
                .where((o) => o.status == 'delivering')
                .toList();
            final completedOrders = allOrders
                .where((o) => o.status == 'completed')
                .toList();

            return TabBarView(
              controller: tabController,
              children: [
                _buildOrderList(context, allOrders, formatter),
                _buildOrderList(context, placedOrders, formatter),
                _buildOrderList(context, preparingOrders, formatter),
                _buildOrderList(context, deliveringOrders, formatter),
                _buildOrderList(context, completedOrders, formatter),
              ],
            );
          }
          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildOrderList(
    BuildContext context,
    List<OrderEntity> orders,
    NumberFormat formatter,
  ) {
    if (orders.isEmpty) {
      return const Center(child: Text('Không có đơn hàng nào.'));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            title: Text('Mã đơn: ${order.id ?? "N/A"} - ${order.name}'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Tổng: ${formatter.format(order.amount)}'),
                Text(
                  'Trạng thái: ${_getStatusText(order.status)}',
                  style: TextStyle(
                    color: _getStatusColor(order.status),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            trailing: const Icon(Icons.edit),
            onTap: () => _showUpdateStatusDialog(context, order),
          ),
        );
      },
    );
  }

  void _showUpdateStatusDialog(BuildContext context, OrderEntity order) {
    String selectedStatus = order.status;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (bottomSheetContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Cập nhật trạng thái',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),

                  DropdownButtonFormField<String>(
                    value: selectedStatus,
                    items: const [
                      DropdownMenuItem(value: 'placed', child: Text('Đã đặt')),
                      DropdownMenuItem(
                        value: 'preparing',
                        child: Text('Đang chuẩn bị'),
                      ),
                      DropdownMenuItem(
                        value: 'delivering',
                        child: Text('Đang giao'),
                      ),
                      DropdownMenuItem(
                        value: 'completed',
                        child: Text('Thành công'),
                      ),
                    ],
                    onChanged: (val) => setState(() => selectedStatus = val!),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        final authState = context.read<AuthBloc>().state;

                        if (authState is AuthAuthenticated) {
                          final token = authState.authToken.token;
                          BlocProvider.of<OrderBloc>(context).add(
                            UpdateOrderStatusEvent(
                              order.id!,
                              selectedStatus,
                              token,
                              '',
                            ),
                          );
                        }

                        Navigator.pop(bottomSheetContext);
                      },
                      child: const Text('Lưu lại'),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'placed':
        return 'Đã đặt';
      case 'preparing':
        return 'Đang chuẩn bị';
      case 'delivering':
        return 'Đang giao';
      case 'completed':
        return 'Thành công';
      default:
        return 'Không xác định';
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'placed':
        return Colors.orange;
      case 'preparing':
        return Colors.blue;
      case 'delivering':
        return Colors.purple;
      case 'completed':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}
