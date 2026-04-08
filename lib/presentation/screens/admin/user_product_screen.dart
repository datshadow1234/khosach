import 'admin_screen_widget.dart';

class UserProductsScreen extends StatefulWidget {
  static const routeName = '/admin-product';
  const UserProductsScreen({super.key});

  @override
  State<UserProductsScreen> createState() => _UserProductsScreenState();
}

class _UserProductsScreenState extends State<UserProductsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<AdminProductBloc>().add(FetchAdminProducts());
  }

  Future<void> _refreshProduct(BuildContext context) async {
    context.read<AdminProductBloc>().add(FetchAdminProducts());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ADMIN'),
        actions: [
          buildAddButton(context),
        ],
      ),
      body: BlocBuilder<AdminProductBloc, AdminProductState>(
        builder: (context, state) {
          if (state is AdminProductLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is AdminProductError) {
            return Center(child: Text(state.message));
          }
          if (state is AdminProductLoaded) {
            return RefreshIndicator(
              onRefresh: () => _refreshProduct(context),
              child: Column(
                children: [
                  buildTotalProduct(state.allProducts.length),
                  SizedBox(
                    height: 650,
                    child: buildUserProductListView(state.allProducts),
                  ),
                ],
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }

  Widget buildTotalProduct(int itemCount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          "Tổng số sản phẩm là: $itemCount",
          style: const TextStyle(color: Colors.grey, fontSize: 18),
        ),
      ],
    );
  }

  Widget buildAddButton(BuildContext context) {
    return IconButton(
        onPressed: () {
          Navigator.of(context).pushNamed(
            EditProductScreen.routeName,
          );
        },
        icon: const Icon(Icons.add));
  }

  Widget buildUserProductListView(List products) {
    return ListView.builder(
      itemCount: products.length,
      itemBuilder: (context, index) => Column(
        children: [
          UserProductListTile(
            products[index],
          ),
          const Divider(),
        ],
      ),
    );
  }
}