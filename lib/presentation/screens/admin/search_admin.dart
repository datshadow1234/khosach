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
      appBar: AppBar(
        title: const Text('Tìm kiếm sản phẩm'),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            const SizedBox(height: 12),
            TextField(
              onChanged: (value) {
                BlocProvider.of<AdminProductBloc>(context)
                    .add(SearchAdminProducts(value));
              },
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: "Nhập tên sách cần tìm...",
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide(color: Colors.grey.shade200),
                ),
              ),
            ),
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
                      return _buildEmptyState();
                    }

                    return ListView.builder(
                      itemCount: products.length,
                      padding: const EdgeInsets.only(bottom: 20),
                      itemBuilder: (context, index) => _buildProductItem(
                          context,
                          products[index]
                      ),
                    );
                  }
                  return const SizedBox();
                },
              ),
            )
          ],
        ),
      ),
    );
  }
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off_rounded, size: 64, color: Colors.grey[300]),
          const SizedBox(height: 12),
          Text(
            'Không tìm thấy sản phẩm nào',
            style: TextStyle(color: Colors.grey[600], fontSize: 16),
          ),
        ],
      ),
    );
  }
  Widget _buildProductItem(BuildContext context, ProductEntity product) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            product.imageUrl,
            width: 50,
            height: 70,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => const Icon(Icons.book, size: 40),
          ),
        ),
        title: Text(
          product.title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          '${product.price}đ',
          style: TextStyle(color: Colors.blueGrey[700], fontWeight: FontWeight.w500),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildEditButton(context, product),
            _buildDeleteButton(context, product),
          ],
        ),
      ),
    );
  }

  Widget _buildEditButton(BuildContext context, ProductEntity product) {
    return IconButton(
      icon: const Icon(Icons.edit_note_rounded, color: Colors.blue),
      onPressed: () {
        Navigator.of(context).pushNamed(
          EditProductScreen.routeName,
          arguments: product,
        );
      },
    );
  }

  Widget _buildDeleteButton(BuildContext context, ProductEntity product) {
    return IconButton(
      icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent),
      onPressed: () {
        BlocProvider.of<AdminProductBloc>(context).add(DeleteAdminProduct(product.id));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Đã xóa ${product.title}'),
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 2),
          ),
        );
      },
    );
  }
}