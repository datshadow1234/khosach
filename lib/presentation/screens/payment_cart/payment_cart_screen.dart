import 'payment_widget.dart';

class PaymentCartScreen1 extends StatefulWidget {
  static const routeName = '/payment-cart1';

  const PaymentCartScreen1({super.key});

  @override
  State<PaymentCartScreen1> createState() => _PaymentCartScreen1State();
}

class _PaymentCartScreen1State extends State<PaymentCartScreen1> {
  final String payResult = "Thanh toán bằng tiền mặt";

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() {
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      context.read<UserBloc>().add(
        FetchUserInfoEvent(
          uid: authState.authToken.userId,
          token: authState.authToken.token,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trang thanh toán'),
      ),
      body: BlocListener<OrderBloc, OrderState>(
        listener: (context, state) {
          if (state is OrderLoading) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) => const Center(child: CircularProgressIndicator()),
            );
          } else if (state is OrderSuccess) {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Đặt hàng thành công!")),
            );
            Navigator.of(context).popUntil((route) => route.isFirst);
          } else if (state is OrderError) {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Lỗi: ${state.message}")),
            );
          }
        },
        child: BlocBuilder<UserBloc, UserState>(
          builder: (context, userState) {
            if (userState is UserLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (userState is UserLoaded) {
              final user = userState.user;

              return BlocBuilder<CartBloc, CartState>(
                builder: (context, cartState) {
                  if (cartState is CartLoaded) {
                    return SingleChildScrollView(
                      padding: const EdgeInsets.only(bottom: 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),
                          paymentAddress(user.address),
                          inforNameUser(user.name),
                          inforPhoneUser(user.phone),
                          const Divider(height: 30, thickness: 1),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            child: Text(
                              "Danh sách sản phẩm",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                          ),
                          const SizedBox(height: 10),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: cartState.items.length,
                            itemBuilder: (ctx, i) {
                              final item = cartState.items[i];
                              return CartItemCard(
                                productId: item.productId,
                                cardItem: item,
                              );
                            },
                          ),
                          const SizedBox(height: 10),
                          buildProductTotal(cartState),
                          const SizedBox(height: 20),
                          paymentNow(user, cartState),
                        ],
                      ),
                    );
                  }
                  return const Center(child: Text("Giỏ hàng đang trống"));
                },
              );
            }

            if (userState is UserError) {
              return Center(child: Text("Lỗi tải thông tin: ${userState.message}"));
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }

  Widget paymentAddress(String data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 15, bottom: 5),
          child: Text(
            'Địa chỉ giao hàng',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 15),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Text(data, style: const TextStyle(fontSize: 15)),
        ),
      ],
    );
  }

  Widget inforNameUser(String data) {
    return ListTile(
      leading: const Icon(Icons.person, color: Colors.blue),
      title: const Text('Người mua'),
      subtitle: Text(data,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
    );
  }

  Widget inforPhoneUser(String data) {
    return ListTile(
      leading: const Icon(Icons.phone, color: Colors.green),
      title: const Text('Số điện thoại'),
      subtitle: Text(data,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
    );
  }

  Widget buildProductTotal(CartLoaded cart) {
    return Container(
      margin: const EdgeInsets.all(15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          CustomRowText(
            title: 'Tổng số lượng items',
            value: '${cart.totalQuantity}',
          ),
          const Divider(),
          CustomRowText(
            title: 'Tổng thanh toán',
            value: '${cart.totalAmount} đ',
          ),
        ],
      ),
    );
  }

  Widget paymentNow(dynamic user, CartLoaded cart) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.redAccent,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: 5,
        ),
        onPressed: () {
          final authState = context.read<AuthBloc>().state;
          if (authState is AuthAuthenticated) {
            final order = OrderEntity(
              amount: cart.totalAmount,
              products: cart.items,
              totalQuantity: cart.totalQuantity,
              name: user.name,
              phone: user.phone,
              address: user.address,
              customerId: user.uid,
              payResult: payResult,
              dateTime: DateTime.now(),
            );

            context.read<OrderBloc>().add(
              AddOrderEvent(order, authState.authToken.token),
            );
          }
        },
        child: const Text(
          'XÁC NHẬN THANH TOÁN TIỀN MẶT',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class CustomRowText extends StatelessWidget {
  final String title;
  final String value;

  const CustomRowText({
    super.key,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 16)),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}