import 'cart.dart';

class OrderItemCard extends StatelessWidget {
  final CartItemEntity cardItem;
  final String productId;

  const OrderItemCard({
    super.key,
    required this.cardItem,
    required this.productId,
  });

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<CartBloc>();

    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          Checkbox(
            value: cardItem.isSelected,
            onChanged: (_) {
              bloc.add(ToggleSelectItemEvent(productId));
            },
          ),
          Hero(
            tag: 'cart_img_$productId',
            child: AppCachedImage(
              url: cardItem.imageUrl,
              width: 60,
              height: 80,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cardItem.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  cardItem.price.toVND(),
                  style: const TextStyle(
                    color: Colors.redAccent,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.remove_circle_outline),
                onPressed: () {
                  bloc.add(DecreaseCartItemEvent(productId));
                },
              ),
              Text('${cardItem.quantity}'),
              IconButton(
                icon: const Icon(Icons.add_circle_outline),
                onPressed: () {
                  bloc.add(AddCartEvent(cardItem));
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
