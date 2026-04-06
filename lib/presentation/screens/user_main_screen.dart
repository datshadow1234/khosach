import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shopbansach/presentation/screens/products/product_overview_screen.dart';
import '../blocs/auth_bloc/auth_bloc.dart';
import '../blocs/auth_bloc/auth_event.dart';
import '../blocs/cart_bloc/cart_bloc.dart';
import '../blocs/cart_bloc/cart_event.dart';
import '../blocs/logout_bloc/logout_bloc.dart';
import '../blocs/logout_bloc/logout_state.dart';
import 'cart/cart_screen.dart';
import 'order/orders_screen.dart';


class UserMainScreen extends StatefulWidget {
  final String title;
  const UserMainScreen({super.key, required this.title});

  @override
  State<UserMainScreen> createState() => _UserMainScreenState();
}

class _UserMainScreenState extends State<UserMainScreen> {
  int index = 0;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<CartBloc>().add(LoadCartEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final screens = [
      const ProductsOverviewScreen(),
      const CartScreen(),
      const OrdersScreen(),
      Center(child: Text(l10n.profile)),
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
            NavigationDestination(icon: const Icon(Icons.home), label: l10n.home),
            NavigationDestination(icon: const Icon(Icons.shopping_cart), label: l10n.cart),
            NavigationDestination(icon: const Icon(Icons.shopping_bag), label: l10n.orders),
            NavigationDestination(icon: const Icon(Icons.account_circle_outlined), label: l10n.profile),
          ],
        ),
      ),
    );
  }
}