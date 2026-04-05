import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../bloc/cart_bloc/cart_bloc.dart';
import '../../bloc/cart_bloc/cart_state.dart';
import 'cart_item_card.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';

  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.cart.toUpperCase()),
      ),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state is CartLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is CartLoaded) {
            return Column(
              children: <Widget>[
                buildCartSummary(state, context, l10n),
                const SizedBox(height: 10),
                Expanded(
                  child: state.items.isEmpty
                      ? Center(child: Text(l10n.emptyCart))
                      : buildCartDetails(state),
                )
              ],
            );
          }

          if (state is CartError) {
            return Center(child: Text(state.message));
          }

          return Center(child: Text(l10n.startAdding));
        },
      ),
    );
  }

  Widget buildCartDetails(CartLoaded state) {
    return ListView.builder(
      itemCount: state.items.length,
      itemBuilder: (context, index) {
        final item = state.items[index];
        return CartItemCard(
          productId: item.productId,
          cardItem: item,
        );
      },
    );
  }

  Widget buildCartSummary(CartLoaded state, BuildContext context, AppLocalizations l10n) {
    return Card(
      margin: const EdgeInsets.all(15),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              l10n.total,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            Chip(
              label: Text(
                '${state.totalAmount} đ',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              backgroundColor: Theme.of(context).primaryColor,
            ),
          ],
        ),
      ),
    );
  }
}