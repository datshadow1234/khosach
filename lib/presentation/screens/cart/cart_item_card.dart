import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/cart_item_entity.dart';
import '../../blocs/cart_bloc/cart_bloc.dart';
import '../../blocs/cart_bloc/cart_event.dart';
import '../shared/dialog_utils.dart';

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
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Dismissible(
        key: ValueKey(widget.cardItem.productId),
        background: Container(
          color: Theme.of(context).colorScheme.error,
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 20),
          child: const Icon(Icons.delete, color: Colors.white, size: 30),
        ),
        direction: DismissDirection.endToStart,
        confirmDismiss: (direction) {
          return showConfirmDialog(
            context,
            'Bạn có chắc muốn xóa sản phẩm này khỏi giỏ hàng?',
          );
        },
        onDismissed: (direction) {
          context.read<CartBloc>().add(
            RemoveCartEvent(widget.productId),
          );
        },
        child: ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(widget.cardItem.imageUrl),
            backgroundColor: Colors.transparent,
          ),
          title: Text(
            widget.cardItem.title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text('Giá: ${widget.cardItem.price} VNĐ'),
          trailing: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              'x${widget.cardItem.quantity}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}