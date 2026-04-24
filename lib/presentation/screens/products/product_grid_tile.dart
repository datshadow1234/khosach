import 'product.dart';

class ProductGridTile extends StatelessWidget {
  final ProductEntity product;

  const ProductGridTile(this.product, {super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        footer: GridTileBar(
          backgroundColor: const Color.fromARGB(255, 146, 115, 141),
          leading: SizedBox(
            width: 100,
            child: Text(product.title, overflow: TextOverflow.ellipsis),
          ),
        ),
        child: GestureDetector(
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => ProductDetailScreen(
                product,
                heroTag: '${product.id}_${product.title}',
              ),
            ),
          ),
          child: Image.network(product.imageUrl, fit: BoxFit.cover),
        ),
      ),
    );
  }
}
