import 'product_widget.dart';

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
            icon: const Icon(Icons.search),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const SearchScreen()),
            ),
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