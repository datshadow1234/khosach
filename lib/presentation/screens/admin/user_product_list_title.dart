import 'admin_screen_widget.dart';

class UserProductListTile extends StatelessWidget {
  static const routeName = '/admin-products';
  final ProductEntity product;

  const UserProductListTile(
      this.product, {
        super.key,
      });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(product.title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(product.imageUrl),
      ),
      trailing: SizedBox(
        width: 100,
        child: Row(
          children: [
            buildEditButton(context),
            buildDeleteButton(context),
          ],
        ),
      ),
    );
  }

  Widget buildEditButton(BuildContext context) {
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

  Widget buildDeleteButton(BuildContext context) {
    return IconButton(
      onPressed: () {
        context.read<AdminProductBloc>().add(DeleteAdminProduct(product.id));
        ScaffoldMessenger.of(context)
          ..hideCurrentMaterialBanner()
          ..showSnackBar(const SnackBar(
              content: Text(
                'Sản phẩm đã xóa',
                textAlign: TextAlign.center,
              )));
      },
      icon: const Icon(Icons.delete),
      color: Theme.of(context).colorScheme.error,
    );
  }
}