import 'screen_widget.dart';
class AdminMainScreen extends StatefulWidget {
  final String title;
  const AdminMainScreen({super.key, required this.title});

  @override
  State<AdminMainScreen> createState() => _AdminMainScreenState();
}

class _AdminMainScreenState extends State<AdminMainScreen> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    final screens = [
      const UserProductsScreen(),
      const SearchAdminScreen(),
      const StatisticScreen(),
      const PersonalAdminScreen(),
    ];

    return BlocListener<LogoutBloc, LogoutState>(
      listener: (context, state) {
        if (state is LogoutSuccess) context.read<AuthBloc>().add(AuthLoggedOut());
      },
      child: Scaffold(
        body: IndexedStack(
          index: index,
          children: screens,
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: index,
          onDestinationSelected: (idx) => setState(() => index = idx),
          destinations: const [
            NavigationDestination(icon: Icon(Icons.home), label: "Admin"),
            NavigationDestination(icon: Icon(Icons.search), label: "Tìm kiếm"),
            NavigationDestination(icon: Icon(Icons.bar_chart), label: "Thống kê"),
            NavigationDestination(icon: Icon(Icons.account_circle_outlined), label: "Cá nhân"),
          ],
        ),
      ),
    );
  }
}