import 'product.dart';

class ProductsOverviewScreen extends StatefulWidget {
  const ProductsOverviewScreen({super.key});

  @override
  State<ProductsOverviewScreen> createState() => _ProductsOverviewScreenState();
}
class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    context.read<ProductListBloc>().add(FetchProductsEvent());
  }
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
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.language),
            onSelected: (String langCode) {
              context.read<LanguageCubit>().changeLanguage(langCode);
            },
            itemBuilder: (BuildContext context) => [
              PopupMenuItem(value: 'vi', child: Text(l10n.vietnamese)),
              PopupMenuItem(value: 'en', child: Text(l10n.english)),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: () => context.read<ThemeCubit>().toggleTheme(),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => context.read<LogoutBloc>().add(LogoutSubmitted()),
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SearchBar(
              hintText: 'Nhập tên sách...',
              leading: const Icon(Icons.search),
              onChanged: _onSearchChanged,
            ),
          ),
          Expanded(
            child: BlocBuilder<ProductListBloc, ProductListState>(
              builder: (context, state) {
                if (state is ProductListLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (state is ProductListLoaded) {
                  if (state.displayProducts.isEmpty) {
                    return const Center(child: Text("Không tìm thấy sách."));
                  }
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
          ),
        ],
      ),
    );
  }
}