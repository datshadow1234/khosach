import 'status_order.dart';

class OrderItem extends HookWidget {
  final OrderEntity order;

  const OrderItem({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final status = useState(OrderStatusX.fromString(order.status));

    return Card(
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Khách: ${order.name}"),
            Text("Tổng: ${order.amount}"),
            const SizedBox(height: 8),

            DropdownButton<OrderStatus>(
              value: status.value,
              items: OrderStatus.values
                  .map((e) => DropdownMenuItem(value: e, child: Text(e.label)))
                  .toList(),
              onChanged: (val) => status.value = val!,
            ),

            const SizedBox(height: 8),

            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Đã lưu trạng thái")),
                );
              },
              child: const Text("Lưu"),
            ),
          ],
        ),
      ),
    );
  }

  OrderStatus _map(String val) {
    switch (val) {
      case 'placed':
        return OrderStatus.placed;
      case 'preparing':
        return OrderStatus.preparing;
      case 'delivering':
        return OrderStatus.delivering;
      default:
        return OrderStatus.completed;
    }
  }
}
