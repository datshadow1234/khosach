import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/product_list/product_list_bloc.dart';
import '../../bloc/product_list/product_list_event.dart';
import '../../bloc/product_list/product_list_state.dart';
import 'product_detail_screen.dart';

class SearchScreen extends StatelessWidget {
  static const routeName = '/search';

  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tìm kiếm'),
      ),
      body: Column(
        children: [
          TextField(
            onChanged: (value) {
              context.read<ProductListBloc>().add(
                SearchProductsEvent(value),
              );
            },
            decoration: InputDecoration(
              hintText: 'Tìm kiếm',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          Expanded(
            child: BlocBuilder<ProductListBloc, ProductListState>(
              builder: (context, state) {
                if (state is ProductListLoaded) {
                  return ListView.builder(
                    itemCount: state.displayProducts.length,
                    itemBuilder: (context, index) {
                      final product = state.displayProducts[index];

                      return ListTile(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => ProductDetailScreen(product),
                            ),
                          );
                        },
                        title: Text(product.title),
                        subtitle: Text('${product.price}'),
                        leading: CircleAvatar(
                          backgroundImage:
                          NetworkImage(product.imageUrl),
                        ),
                      );
                    },
                  );
                }

                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }
}