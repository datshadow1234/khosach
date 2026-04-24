import 'screens/screen_widget.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<ThemeCubit>()),
        BlocProvider(create: (_) => sl<LanguageCubit>()),
        BlocProvider(create: (_) => sl<AuthBloc>()..add(AppStarted())),
        BlocProvider(create: (_) => sl<LoginBloc>()),
        BlocProvider(create: (_) => sl<SignupBloc>()),
        BlocProvider(create: (_) => sl<ProductListBloc>()),
        BlocProvider(create: (_) => sl<AdminProductBloc>()),
        BlocProvider(create: (_) => sl<LogoutBloc>()),
        BlocProvider(create: (_) => sl<CartBloc>()..add(LoadCartEvent())),
        BlocProvider(create: (_) => sl<OrderBloc>()),
        BlocProvider(create: (_) => sl<UserBloc>()),
        BlocProvider(create: (_) => sl<AdminProfileBloc>()),
        BlocProvider(create: (_) => sl<StatisticBloc>()),
      ],
      child: BlocBuilder<LanguageCubit, Locale>(
        builder: (context, locale) {
          return BlocBuilder<ThemeCubit, ThemeMode>(
            builder: (context, themeMode) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                locale: locale,
                localizationsDelegates: AppLocalizations.localizationsDelegates,
                supportedLocales: AppLocalizations.supportedLocales,
                themeMode: themeMode,
                theme: ThemeData(
                  useMaterial3: true,
                  colorSchemeSeed: Colors.deepPurple,
                ),
                darkTheme: ThemeData(
                  useMaterial3: true,
                  brightness: Brightness.dark,
                  colorSchemeSeed: Colors.deepPurple,
                ),
                routes: {
                  CartScreen.routeName: (context) => const CartScreen(),
                  PaymentCartScreen1.routeName: (context) =>
                      const PaymentCartScreen1(),
                  EditProductScreen.routeName: (context) {
                    final args =
                        ModalRoute.of(context)?.settings.arguments
                            as ProductEntity?;
                    return EditProductScreen(args);
                  },
                },
                home: BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    if (state is AuthAuthenticated) {
                      return state.authToken.role == "admin"
                          ? const AdminMainScreen(title: 'Admin Panel')
                          : const UserMainScreen(title: 'Kho Sách');
                    }
                    if (state is AuthUnauthenticated) {
                      return AuthScreen();
                    }
                    return const SplashScreen();
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
