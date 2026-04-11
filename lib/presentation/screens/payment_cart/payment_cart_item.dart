import '../admin/admin.dart';
import 'payment.dart';

class CartItemCard extends HookWidget {
  final String productId;
  final CartItemEntity cardItem;

  const CartItemCard({
    required this.productId,
    required this.cardItem,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(cardItem.productId),
      background: Container(
        color: Colors.redAccent,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete_outline, color: Colors.white, size: 28),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) => showConfirmDialog(
        context,
        'Xóa "${cardItem.title}" khỏi giỏ hàng?',
      ),
      onDismissed: (_) {
        BlocProvider.of<CartBloc>(context).add(RemoveCartEvent(productId));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade100),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(cardItem.imageUrl, width: 60, height: 60, fit: BoxFit.cover),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(cardItem.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text('${cardItem.price} đ', style: TextStyle(color: Colors.grey.shade600)),
                ],
              ),
            ),
            Text('x${cardItem.quantity}', style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}