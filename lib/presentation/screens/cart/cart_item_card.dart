import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/cart_item_entity.dart';
import '../../bloc/cart_bloc/cart_bloc.dart';
import '../../bloc/cart_bloc/cart_event.dart';
import '../shared/dialog_utils.dart';

class CartItemCard extends StatelessWidget {
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
      key: ValueKey(cardItem.id),
      background: Container(
        color: Theme.of(context).colorScheme.error,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete, color: Colors.white, size: 40),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) => showConfirmDialog(
        context,
        'Bạn có muốn xóa sản phẩm này khỏi giỏ hàng?',
      ),
      onDismissed: (_) {
        context.read<CartBloc>().add(RemoveCartEvent(productId));
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(cardItem.imageUrl),
          ),
          title: Text(cardItem.title),
          subtitle: Text('Giá: ${cardItem.price} VNĐ'),
          trailing: Text('${cardItem.quantity}x'),
        ),
      ),
    );
  }
}