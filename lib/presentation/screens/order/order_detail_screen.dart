import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart';
import 'order.dart';

class OrderDetailScreen extends HookWidget {
  static const routeName = 'order-detail-screen';
  final OrderEntity order;

  const OrderDetailScreen(this.order, {super.key});
  String formatCurrency(double amount) {
    return NumberFormat.currency(locale: 'vi_VN', symbol: 'VNĐ').format(amount);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cartBloc = BlocProvider.of<CartBloc>(context);
    final shippingFee = order.shippingFee == 0 ? 30000.0 : order.shippingFee;

    void buyAgain() {
      for (final prod in order.products) {
        cartBloc.add(AddCartEvent(prod));
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đã thêm sản phẩm vào giỏ hàng')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi tiết đơn hàng'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Card(
              elevation: 0,
              color: theme.cardColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _infoRow(
                      context,
                      'Ngày đặt',
                      DateFormat('dd/MM/yyyy HH:mm').format(order.dateTime),
                    ),
                    const SizedBox(height: 10),
                    _infoRow(context, 'Họ và tên', order.name),
                    const SizedBox(height: 10),
                    _infoRow(context, 'Số điện thoại', order.phone),
                    const SizedBox(height: 10),
                    _infoRow(context, 'Địa chỉ', order.address),

                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Divider(),
                    ),
                    Text(
                      'Sản phẩm đã mua',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: theme.textTheme.titleLarge?.color,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...order.products.map(
                      (prod) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                prod.title,
                                maxLines: 2,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  'x${prod.quantity}',
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                  ),
                                ),
                                Text(
                                  formatCurrency(prod.price),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Divider(),
                    ),
                    _infoRow(
                      context,
                      'Tổng số lượng',
                      '${order.totalQuantity} quyển',
                    ),
                    const SizedBox(height: 10),
                    _infoRow(
                      context,
                      'Phí vận chuyển',
                      formatCurrency(shippingFee),
                    ),
                    const SizedBox(height: 10),
                    _infoRow(context, 'Hình thức', order.payResult),
                    const SizedBox(height: 10),
                    _infoRow(
                      context,
                      'Tác giả',
                      order.products.isNotEmpty
                          ? order.products.first.author
                          : '-',
                    ),
                    const SizedBox(height: 10),
                    _infoRow(
                      context,
                      'Quốc gia',
                      order.products.isNotEmpty
                          ? order.products.first.country
                          : '-',
                    ),

                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: theme.brightness == Brightness.dark
                            ? Colors.white10
                            : Colors.grey[50],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: _infoRow(
                        context,
                        'TỔNG THANH TOÁN',
                        formatCurrency(order.amount),
                        valueStyle: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: buyAgain,
                icon: const Icon(Icons.replay),
                label: const Text(
                  'MUA LẠI ĐƠN HÀNG',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.brightness == Brightness.dark
                      ? Colors.blueAccent
                      : Colors.black,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(
    BuildContext context,
    String label,
    String value, {
    TextStyle? valueStyle,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, color: Colors.grey)),
        Text(
          value,
          style:
              valueStyle ??
              TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: isDark ? Colors.white : Colors.black,
              ),
        ),
      ],
    );
  }
}
