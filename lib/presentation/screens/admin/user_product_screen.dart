import 'package:shopbansach/presentation/screens/admin/admin_search_bar.dart';

import 'admin.dart';

class UserProductsScreen extends HookWidget {
  const UserProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      BlocProvider.of<AdminProductBloc>(context).add(FetchAdminProducts());
      return null;
    }, []);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Quản lý sản phẩm'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routeName);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            const SizedBox(height: 12),
            const AdminSearchBar(),

            const SizedBox(height: 16),

            Expanded(
              child: BlocBuilder<AdminProductBloc, AdminProductState>(
                builder: (context, state) {
                  if (state is AdminProductLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is AdminProductLoaded) {
                    final products = state.displayProducts;

                    if (products.isEmpty) {
                      return _empty();
                    }

                    return ListView.builder(
                      itemCount: products.length,
                      padding: const EdgeInsets.only(bottom: 20),
                      itemBuilder: (context, index) {
                        final product = products[index];

                        return Dismissible(
                          key: ValueKey(product.id),
                          direction: DismissDirection.endToStart,
                          background: Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                              color: Colors.redAccent,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            alignment: Alignment.centerRight,
                            child: const Icon(
                              Icons.delete_outline,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                          onDismissed: (_) {
                            BlocProvider.of<AdminProductBloc>(
                              context,
                            ).add(DeleteAdminProduct(product.id));

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Đã xóa "${product.title}"'),
                              ),
                            );
                          },
                          child: Card(
                            elevation: 0,
                            margin: const EdgeInsets.only(bottom: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide(color: Colors.grey.shade200),
                            ),
                            child: UserProductListTile(product),
                          ),
                        );
                      },
                    );
                  }

                  return const SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _empty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inbox_outlined, size: 64, color: Colors.grey[300]),
          const SizedBox(height: 12),
          Text(
            'Không có sản phẩm nào',
            style: TextStyle(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}
