import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopbansach/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:shopbansach/presentation/bloc/auth_bloc/auth_event.dart';
import 'package:shopbansach/presentation/bloc/logout_bloc/logout_bloc.dart';
import 'package:shopbansach/presentation/bloc/logout_bloc/logout_event.dart';
import 'package:shopbansach/presentation/bloc/logout_bloc/logout_state.dart';
import 'package:shopbansach/presentation/screens/products/product_overview_screen.dart';
import 'package:shopbansach/presentation/screens/products/search_product.dart';
import '../../../../../core/theme/theme_cubit.dart';

class UserMainScreen extends StatefulWidget {
  final String title;
  const UserMainScreen({super.key, required this.title});

  @override
  State<UserMainScreen> createState() => _UserMainScreenState();
}

class _UserMainScreenState extends State<UserMainScreen> {
  int index = 0;

  final screens = [
    const ProductsOverviewScreen(),
    const Center(child: Text("Giỏ hàng")),
    const Center(child: Text("Đơn hàng")),
    const Center(child: Text("Cá nhân")),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocListener<LogoutBloc, LogoutState>(
      listener: (context, state) {
        if (state is LogoutSuccess) {
          context.read<AuthBloc>().add(AuthLoggedOut());
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          actions: [
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
        body: IndexedStack(index: index, children: screens),
        bottomNavigationBar: NavigationBar(
          selectedIndex: index,
          onDestinationSelected: (idx) => setState(() => index = idx),
          destinations: const [
            NavigationDestination(icon: Icon(Icons.home), label: "Trang chủ"),
            NavigationDestination(icon: Icon(Icons.shopping_cart), label: "Giỏ hàng"),
            NavigationDestination(icon: Icon(Icons.shopping_bag), label: "Đơn hàng"),
            NavigationDestination(icon: Icon(Icons.account_circle_outlined), label: "Cá nhân"),
          ],
        ),
      ),
    );
  }
}