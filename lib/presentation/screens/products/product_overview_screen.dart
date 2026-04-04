import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme/theme_cubit.dart';
import '../../bloc/product_list_bloc/product_list_bloc.dart';
import '../../bloc/product_list_bloc/product_list_event.dart';
import '../../bloc/product_list_bloc/product_list_state.dart';
import 'products_grid.dart';
import 'search_product.dart';

class ProductsOverviewScreen extends StatefulWidget {
  const ProductsOverviewScreen({super.key});

  @override
  State<ProductsOverviewScreen> createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ProductListBloc>().add(FetchProductsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BOOKSTORE'),
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: () => context.read<ThemeCubit>().toggleTheme(),
          ),
          searchProduct(),
        ],
      ),
      body: BlocBuilder<ProductListBloc, ProductListState>(
        builder: (context, state) {
          if (state is ProductListLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is ProductListLoaded) {
            return ProductsGrid(products: state.displayProducts);
          }

          if (state is ProductListError) {
            return Center(
              child: Text(state.message),
            );
          }

          return const SizedBox();
        },
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     Navigator.of(context).pushNamed(ChatbotScreen1.routeName);
      //   },
      //   child: const Icon(Icons.message),
      // ),
    );
  }

  Widget searchProduct() {
    return IconButton(
      onPressed: () {
        Navigator.of(context).pushNamed(SearchScreen.routeName);
      },
      icon: const Icon(Icons.search),
    );
  }
}