import 'admin_screen_widget.dart';

class SearchAdminScreen extends StatefulWidget {
  static const routeName = '/search1';

  const SearchAdminScreen({super.key});
  @override
  State<SearchAdminScreen> createState() => _SearchAdminScreenState();
}

class _SearchAdminScreenState extends State<SearchAdminScreen> {
  @override
  void initState() {
    super.initState();
    context.read<AdminProductBloc>().add(FetchAdminProducts());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Tìm kiếm - Admin'),
        ),
        body: Column(children: [
          TextField(
            onChanged: (value) {
              context.read<AdminProductBloc>().add(SearchAdminProducts(value));
            },
            decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
                hintText: "Tìm kiếm",
                prefixIcon: const Icon(Icons.search)),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: BlocBuilder<AdminProductBloc, AdminProductState>(
              builder: (context, state) {
                if (state is AdminProductLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is AdminProductLoaded) {
                  final products = state.displayProducts;
                  if (products.isEmpty) {
                    return const Center(
                      child: Text(
                        '',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.normal),
                      ),
                    );
                  }
                  return ListView.builder(
                    itemCount: products.length,
                    itemBuilder: (context, index) => ListTile(
                      onTap: () {},
                      title: Text(
                        products[index].title,
                        style: const TextStyle(color: Colors.black),
                      ),
                      subtitle: Text(
                        '${products[index].price}',
                        style: const TextStyle(color: Colors.black),
                      ),
                      leading: CircleAvatar(
                        backgroundImage:
                        NetworkImage(products[index].imageUrl),
                      ),
                      trailing: SizedBox(
                        width: 100,
                        child: Row(
                          children: [
                            buildEditButton(context, products[index]),
                            buildDeleteButton(context, products[index]),
                          ],
                        ),
                      ),
                    ),
                  );
                }
                return const SizedBox();
              },
            ),
          )
        ]));
  }

  Widget buildEditButton(BuildContext context, ProductEntity product) {
    return IconButton(
      onPressed: () async {
        Navigator.of(context).pushNamed(
          EditProductScreen.routeName,
          arguments: product,
        );
      },
      icon: const Icon(Icons.edit),
      color: Theme.of(context).colorScheme.error,
    );
  }

  Widget buildDeleteButton(BuildContext context, ProductEntity product) {
    return IconButton(
      onPressed: () {
        context.read<AdminProductBloc>().add(DeleteAdminProduct(product.id));
        ScaffoldMessenger.of(context)
          ..hideCurrentMaterialBanner()
          ..showSnackBar(const SnackBar(
              content: Text(
                'Sản phẩm đã được xóa!',
                textAlign: TextAlign.center,
              )));
      },
      icon: const Icon(Icons.delete),
      color: Theme.of(context).colorScheme.error,
    );
  }
}