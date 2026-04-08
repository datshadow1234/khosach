import 'payment_widget.dart';

class CartItemCard extends StatefulWidget {
  final String productId;
  final CartItemEntity cardItem;

  const CartItemCard({
    required this.productId,
    required this.cardItem,
    super.key,
  });

  @override
  State<CartItemCard> createState() => _CartItemCardState();
}

class _CartItemCardState extends State<CartItemCard> {
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(widget.cardItem.productId),
      background: Container(
        color: Theme.of(context).colorScheme.error,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: const Icon(Icons.delete, color: Colors.white, size: 30),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) {
        return showConfirmDialog(
          context,
          'Bạn có chắc muốn xóa sản phẩm "${widget.cardItem.title}" khỏi giỏ hàng?',
        );
      },
      onDismissed: (direction) {
        context.read<CartBloc>().add(
          RemoveCartEvent(widget.productId),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(widget.cardItem.imageUrl),
            backgroundColor: Colors.transparent,
          ),
          title: Text(
            widget.cardItem.title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text('Giá: ${widget.cardItem.price} đ'),
          trailing: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.blueGrey.shade50,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              'SL: ${widget.cardItem.quantity}',
              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
            ),
          ),
        ),
      ),
    );
  }
}