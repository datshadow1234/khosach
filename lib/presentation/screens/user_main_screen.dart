import 'screen_widget.dart';

class UserMainScreen extends StatefulWidget {
  final String title;
  const UserMainScreen({super.key, required this.title});

  @override
  State<UserMainScreen> createState() => _UserMainScreenState();
}

class _UserMainScreenState extends State<UserMainScreen> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final screens = [
      const ProductsOverviewScreen(),
      const CartScreen(),
      const OrdersScreen(),
      const PersonalScreen(),
    ];

    return BlocListener<LogoutBloc, LogoutState>(
      listener: (context, state) {
        if (state is LogoutSuccess) {
          context.read<AuthBloc>().add(AuthLoggedOut());
        }
      },
      child: Scaffold(
        body: IndexedStack(index: index, children: screens),
        bottomNavigationBar: NavigationBar(
          selectedIndex: index,
          onDestinationSelected: (idx) => setState(() => index = idx),
          destinations: [
            NavigationDestination(
              icon: const Icon(Icons.home),
              label: l10n.home,
            ),
            NavigationDestination(
              icon: const Icon(Icons.shopping_cart),
              label: l10n.cart,
            ),
            NavigationDestination(
              icon: const Icon(Icons.shopping_bag),
              label: l10n.orders,
            ),
            NavigationDestination(
              icon: const Icon(Icons.account_circle_outlined),
              label: l10n.profile,
            ),
          ],
        ),
      ),
    );
  }
}
