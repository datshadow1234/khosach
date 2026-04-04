import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopbansach/presentation/screens/products/product_detail_screen.dart';

import '../../bloc/product_list_bloc/product_list_bloc.dart';
import '../../bloc/product_list_bloc/product_list_event.dart';
import '../../bloc/product_list_bloc/product_list_state.dart';

class SearchScreen extends StatefulWidget {
  static const routeName = '/search';
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  Timer? _debounce;

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      context.read<ProductListBloc>().add(SearchProductsEvent(query));
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tìm kiếm Sách')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            // Sử dụng SearchBar của Material 3
            child: SearchBar(
              hintText: 'Nhập tên sách...',
              leading: const Icon(Icons.search),
              onChanged: _onSearchChanged,
            ),
          ),
          Expanded(
            child: BlocBuilder<ProductListBloc, ProductListState>(
              builder: (context, state) {
                if (state is ProductListLoaded) {
                  if (state.displayProducts.isEmpty) {
                    return const Center(child: Text("Không tìm thấy sách."));
                  }
                  return ListView.builder(
                    itemCount: state.displayProducts.length,
                    itemBuilder: (context, index) {
                      final product = state.displayProducts[index];
                      return ListTile(
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => ProductDetailScreen(product)),
                        ),
                        title: Text(product.title),
                        subtitle: Text('${product.price} VNĐ'),
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(product.imageUrl),
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