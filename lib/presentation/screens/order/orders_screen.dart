import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../blocs/auth_bloc/auth_bloc.dart';
import '../../blocs/auth_bloc/auth_state.dart';
import 'order.dart';

class OrdersScreen extends HookWidget {
  static const routeName = '/orders';
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      final authState = BlocProvider.of<AuthBloc>(context).state;
      if (authState is AuthAuthenticated) {
        BlocProvider.of<OrderBloc>(context).add(
          FetchOrdersEvent(authState.authToken.userId, authState.authToken.token!),
        );
      }
      return null;
    }, []);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('ĐƠN HÀNG CỦA TÔI'),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          final authState = BlocProvider.of<AuthBloc>(context).state;
          if (authState is AuthAuthenticated) {
            BlocProvider.of<OrderBloc>(context).add(
              FetchOrdersEvent(authState.authToken.userId, authState.authToken.token!),
            );
          }
        },
        child: BlocBuilder<OrderBloc, OrderState>(
          builder: (context, state) {
            if (state is OrderLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is OrdersLoaded) {
              if (state.orders.isEmpty) {
                return const Center(child: Text('Bạn chưa có đơn hàng nào.'));
              }

              return ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: state.orders.length,
                itemBuilder: (ctx, i) {
                  final order = state.orders[i];
                  return Card(
                    elevation: 0,
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => OrderDetailScreen(order)),
                        );
                      },
                      leading: CircleAvatar(
                        backgroundColor: Colors.blue.withOpacity(0.1),
                        child: const Icon(Icons.shopping_bag_outlined, color: Colors.blue),
                      ),
                      title: Text(
                        'Tổng: ${order.amount.toStringAsFixed(0)} đ',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          Text('Ngày đặt: ${DateFormat('dd/MM/yyyy HH:mm').format(order.dateTime)}'),
                          Text('${order.products.length} sản phẩm', style: const TextStyle(fontSize: 12)),
                        ],
                      ),
                      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                    ),
                  );
                },
              );
            }

            if (state is OrderError) {
              return Center(child: Text('Lỗi: ${state.message}'));
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }
}