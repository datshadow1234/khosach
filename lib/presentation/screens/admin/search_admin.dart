import 'package:shopbansach/presentation/screens/admin/admin_search_bar.dart';

import 'admin.dart';

class SearchAdminScreen extends HookWidget {
  static const routeName = '/search1';
  const SearchAdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      BlocProvider.of<AdminProductBloc>(context).add(FetchAdminProducts());
      return null;
    }, []);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(title: const Text('Tìm kiếm sản phẩm'), elevation: 0),
      body: Column(
        children: [
          const AdminSearchBar(),

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
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: products.length,
                    itemBuilder: (context, index) =>
                        _item(context, products[index]),
                  );
                }
                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _empty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 64, color: Colors.grey[300]),
          const SizedBox(height: 12),
          Text(
            'Không tìm thấy sản phẩm nào',
            style: TextStyle(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _item(BuildContext context, ProductEntity product) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: Image.network(product.imageUrl, width: 50, fit: BoxFit.cover),
        title: Text(product.title),
        subtitle: Text('${product.price} VNĐ'),
      ),
    );
  }
}
