import 'product_widget.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routeName = '/product-detail';
  final ProductEntity product;

  const ProductDetailScreen(this.product, {super.key});
  void _addToCart(BuildContext context, AppLocalizations l10n) {
    final cartItem = _convertToCartItem();
    context.read<CartBloc>().add(AddCartEvent(cartItem));

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(l10n.addedToCart),
          duration: const Duration(seconds: 2),
          action: SnackBarAction(
            label: l10n.undo,
            onPressed: () {
              context.read<CartBloc>().add(RemoveCartEvent(product.id ?? ''));
            },
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.productDetail),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            const SizedBox(height: 20),
            Container(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 300,
                        width: 200,
                        child: Image.network(
                          product.imageUrl,
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: 150,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildInfo(l10n.appTitle, product.title,
                                    valueColor: Colors.red, italic: true),
                                _buildInfo(l10n.author, product.author),
                                _buildInfo(l10n.country, product.coutry),
                                _buildInfo(l10n.category, product.category),
                                _buildInfo(l10n.price, "${product.price}"),
                                buildShoppingCartIcon(context, l10n),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              width: 200,
              height: 40,
              child: ElevatedButton(
                onPressed: () => _addToCart(context, l10n),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                child: Text(
                  l10n.orderNow,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              width: double.infinity,
              child: Column(
                children: [
                  Text(
                    l10n.description,
                    style: const TextStyle(color: Colors.grey, fontSize: 20),
                  ),
                  Text(
                    product.description,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                    ),
                    textAlign: TextAlign.start,
                    softWrap: true,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildInfo(String label, String value,
      {Color valueColor = Colors.grey, bool italic = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.black, fontSize: 20),
        ),
        Text(
          value,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: valueColor,
            fontSize: 18,
            fontStyle: italic ? FontStyle.italic : FontStyle.normal,
          ),
        ),
      ],
    );
  }

  Widget buildShoppingCartIcon(BuildContext context, AppLocalizations l10n) {
    return Row(
      children: [
        Text(
          l10n.addToCart,
          style: const TextStyle(fontSize: 18),
        ),
        IconButton(
          onPressed: () => _addToCart(context, l10n),
          icon: const Icon(Icons.shopping_cart),
        ),
      ],
    );
  }

  CartItemEntity _convertToCartItem() {
    return CartItemEntity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      productId: product.id ?? '',
      title: product.title,
      quantity: 1,
      price: product.price,
      imageUrl: product.imageUrl,
      category: product.category,
      author: product.author,
      language: product.language,
      country: product.coutry,
    );
  }
}