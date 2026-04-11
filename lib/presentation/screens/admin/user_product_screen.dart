import 'admin.dart';

class UserProductsScreen extends HookWidget {
  static const routeName = '/admin-product';
  const UserProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      BlocProvider.of<AdminProductBloc>(context).add(FetchAdminProducts());
      return null;
    }, []);

    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Kho Sản Phẩm',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
        ),
        centerTitle: false,
        actions: [
          _buildSystemActions(context, l10n),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).pushNamed(EditProductScreen.routeName),
        child: const Icon(Icons.add),
      ),

      body: BlocBuilder<AdminProductBloc, AdminProductState>(
        builder: (context, state) {
          if (state is AdminProductLoading) {
            return const Center(child: CircularProgressIndicator(strokeWidth: 2));
          }
          if (state is AdminProductError) {
            return Center(child: Text(state.message));
          }
          if (state is AdminProductLoaded) {
            return RefreshIndicator(
              onRefresh: () async {
                BlocProvider.of<AdminProductBloc>(context).add(FetchAdminProducts());
              },
              child: CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
                    sliver: SliverToBoxAdapter(
                      child: Text(
                        "Đang hiển thị ${state.allProducts.length} sản phẩm",
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            letterSpacing: 0.5,
                            fontWeight: FontWeight.w500
                        ),
                      ),
                    ),
                  ),
                  _buildProductSliverList(state.allProducts),
                ],
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
  Widget _buildProductSliverList(List products) {
    if (products.isEmpty) {
      return const SliverFillRemaining(
        child: Center(child: Text("Danh sách trống")),
      );
    }
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 80),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
              (context, index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.grey.shade200),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: UserProductListTile(products[index]),
              ),
            );
          },
          childCount: products.length,
        ),
      ),
    );
  }
  Widget _buildSystemActions(BuildContext context, AppLocalizations l10n) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.contrast_outlined, size: 20),
          onPressed: () => BlocProvider.of<ThemeCubit>(context).toggleTheme(),
        ),
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert),
          onSelected: (value) {
            if (value == 'logout') {
              BlocProvider.of<LogoutBloc>(context).add(LogoutSubmitted());
            } else {
              BlocProvider.of<LanguageCubit>(context).changeLanguage(value);
            }
          },
          itemBuilder: (ctx) => [
            PopupMenuItem(value: 'vi', child: Text('Tiếng Việt')),
            PopupMenuItem(value: 'en', child: Text('English')),
            const PopupMenuDivider(),
            const PopupMenuItem(
              value: 'logout',
              child: Text('Đăng xuất', style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      ],
    );
  }
}