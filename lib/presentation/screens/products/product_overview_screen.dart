import 'package:intl/intl.dart';
import 'product.dart';

class ProductsOverviewScreen extends HookWidget {
  const ProductsOverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<ProductListBloc>(context);
    final debounce = useRef<Timer?>(null);

    useEffect(() {
      bloc.add(FetchProductsEvent());
      return () {
        debounce.value?.cancel();
      };
    }, []);

    void onSearchChanged(String query) {
      if (debounce.value?.isActive ?? false) {
        debounce.value!.cancel();
      }
      debounce.value = Timer(const Duration(milliseconds: 300), () {
        if (context.mounted) {
          BlocProvider.of<ProductListBloc>(
            context,
          ).add(SearchProductsEvent(query));
        }
      });
    }

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(width: 8),
            Hero(
              tag: 'logo_home',
              child: Image.asset(
                'assets/Images/image.png',
                width: 32,
                height: 32,
              ),
            ),
            const SizedBox(width: 16),
            const Text(
              "Kho Sách",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              BlocProvider.of<ProductListBloc>(
                context,
              ).add(RefreshProductsEvent());
            },
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.language),
            onSelected: (String langCode) {
              BlocProvider.of<LanguageCubit>(context).changeLanguage(langCode);
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'vi', child: Text("Tiếng Việt")),
              const PopupMenuItem(value: 'en', child: Text("English")),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: () => BlocProvider.of<ThemeCubit>(context).toggleTheme(),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () =>
                BlocProvider.of<LogoutBloc>(context).add(LogoutSubmitted()),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SearchBar(
              hintText: 'Nhập tên sách...',
              leading: const Icon(Icons.search),
              onChanged: onSearchChanged,
            ),
          ),
          Expanded(
            child: BlocBuilder<ProductListBloc, ProductListState>(
              builder: (context, state) {
                if (state is ProductListLoading) {
                  return AppLoader(isLoading: true, child: _fakeUI());
                }

                if (state is ProductListLoaded) {
                  return RefreshIndicator(
                    onRefresh: () async {
                      BlocProvider.of<ProductListBloc>(
                        context,
                      ).add(RefreshProductsEvent());
                      await Future.delayed(const Duration(seconds: 1));
                    },
                    child: _buildProductList(context, state),
                  );
                }

                if (state is ProductListError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(state.message),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: () {
                            BlocProvider.of<ProductListBloc>(
                              context,
                            ).add(RefreshProductsEvent());
                          },
                          child: const Text('Thử lại'),
                        ),
                      ],
                    ),
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

  Widget _buildProductList(BuildContext context, ProductListLoaded state) {
    final groupedData = groupProductsByCategory(state.displayProducts);
    final categories = groupedData.keys.toList();

    if (categories.isEmpty) {
      return const Center(child: Text("Không tìm thấy sách."));
    }
    return ListView.builder(
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final categoryName = categories[index];
        final products = groupedData[categoryName]!;
        return _buildCategoryRow(context, categoryName, products);
      },
    );
  }

  Widget _fakeUI() {
    return ListView.builder(
      itemCount: 3,
      itemBuilder: (_, __) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(height: 20, width: 120, color: Colors.white),
            const SizedBox(height: 10),
            SizedBox(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 4,
                itemBuilder: (_, __) {
                  return Container(
                    width: 150,
                    margin: const EdgeInsets.all(8),
                    color: Colors.white,
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCategoryRow(
    BuildContext context,
    String title,
    List<ProductEntity> items,
  ) {
    final currencyFormat = NumberFormat.currency(
      locale: 'vi_VN',
      symbol: 'VNĐ',
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 240,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final product = items[index];
              return SizedBox(
                width: 150,
                child: Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => ProductDetailScreen(
                          product,
                          heroTag: '${product.id}_$title',
                        ),
                      ),
                    ),
                    child: Card(
                      clipBehavior: Clip.antiAlias,
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Hero(
                              tag: '${product.id}_$title',
                              child: Material(
                                color: Colors.transparent,
                                child: AppCachedImage(
                                  url: product.imageUrl,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product.title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  currencyFormat.format(product.price),
                                  style: const TextStyle(
                                    color: Colors.red,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

Map<String, List<ProductEntity>> groupProductsByCategory(
  List<ProductEntity> products,
) {
  final Map<String, List<ProductEntity>> data = {};
  for (final product in products) {
    data.putIfAbsent(product.category, () => []);
    data[product.category]!.add(product);
  }
  return data;
}
