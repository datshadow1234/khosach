import '../admin/admin.dart';
import 'payment.dart';

class PaymentCartScreen1 extends HookWidget {
  static const routeName = '/payment-cart1';
  const PaymentCartScreen1({super.key});

  @override
  Widget build(BuildContext context) {
    const double shippingFee = 30000;
    const String payResult = "Thanh toán bằng tiền mặt";

    useEffect(() {
      final authState = BlocProvider.of<AuthBloc>(context).state;
      if (authState is AuthAuthenticated) {
        BlocProvider.of<UserBloc>(context).add(
          FetchUserInfoEvent(
            uid: authState.authToken.userId,
            token: authState.authToken.token!,
          ),
        );
      }
      return null;
    }, []);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Thanh toán'), elevation: 0),
      body: BlocListener<OrderBloc, OrderState>(
        listener: (context, state) {
          if (state is OrderLoading) {
            showDialog(context: context, builder: (_) => const Center(child: CircularProgressIndicator()));
          } else if (state is OrderSuccess) {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Đặt hàng thành công!")));
            Navigator.of(context).popUntil((route) => route.isFirst);
          } else if (state is OrderError) {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Lỗi: ${state.message}")));
          }
        },
        child: BlocBuilder<UserBloc, UserState>(
          builder: (context, userState) {
            if (userState is UserLoading) return const Center(child: CircularProgressIndicator());
            if (userState is! UserLoaded) return const Center(child: Text("Lỗi tải thông tin"));

            final user = userState.user;

            return BlocBuilder<CartBloc, CartState>(
              builder: (context, cartState) {
                if (cartState is! CartLoaded) return const Center(child: Text("Giỏ hàng trống"));

                return Column(
                  children: [
                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.all(16),
                        children: [
                          _buildSectionTitle('Thông tin nhận hàng'),
                          _infoTile(Icons.person_outline, 'Người nhận', user.name),
                          _infoTile(Icons.phone_iphone, 'Số điện thoại', user.phone),
                          _infoTile(Icons.location_on_outlined, 'Địa chỉ', user.address),
                          const Divider(height: 40),
                          _buildSectionTitle('Sản phẩm đã chọn'),
                          ...cartState.items.map((item) => CartItemCard(productId: item.productId, cardItem: item)),
                        ],
                      ),
                    ),
                    _buildBottomSummary(context, cartState, user, shippingFee, payResult),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
    );
  }

  Widget _infoTile(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.blueGrey),
          const SizedBox(width: 12),
          Text('$label:', style: const TextStyle(color: Colors.grey)),
          const SizedBox(width: 8),
          Expanded(child: Text(value, style: const TextStyle(fontWeight: FontWeight.w500))),
        ],
      ),
    );
  }

  Widget _buildBottomSummary(BuildContext context, CartLoaded cart, dynamic user, double ship, String payType) {
    final double finalTotal = cart.totalAmount + ship;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _rowPrice('Tiền hàng', '${cart.totalAmount} đ'),
          _rowPrice('Phí vận chuyển', '${ship} đ'),
          const Divider(height: 20),
          _rowPrice('Tổng thanh toán', '${finalTotal} đ', isBold: true),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.black, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
              onPressed: () {
                final authState = BlocProvider.of<AuthBloc>(context).state;
                if (authState is AuthAuthenticated) {
                  final order = OrderEntity(
                    shippingFee: ship,
                    amount: finalTotal,
                    products: cart.items,
                    totalQuantity: cart.totalQuantity,
                    name: user.name,
                    phone: user.phone,
                    address: user.address,
                    customerId: user.uid,
                    payResult: payType,
                    dateTime: DateTime.now(),
                  );
                  BlocProvider.of<OrderBloc>(context).add(AddOrderEvent(order, authState.authToken.token!));
                }
              },
              child: const Text('XÁC NHẬN ĐẶT HÀNG', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _rowPrice(String label, String value, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: isBold ? 16 : 14, fontWeight: isBold ? FontWeight.bold : null)),
        Text(value, style: TextStyle(fontSize: isBold ? 18 : 14, fontWeight: isBold ? FontWeight.bold : null, color: isBold ? Colors.red : null)),
      ],
    );
  }
}