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
        BlocProvider(create: (_) => sl<ProductListBloc>()..add(FetchProductsEvent())),
        BlocProvider(create: (_) => sl<LogoutBloc>()),
        BlocProvider(create: (_) => sl<CartBloc>()..add(LoadCartEvent())),
        BlocProvider(create: (_) => sl<OrderBloc>()),
        BlocProvider(create: (_) => sl<UserBloc>()),
      ],
      child: BlocBuilder<LanguageCubit, Locale>(
        builder: (context, locale) {
          return BlocBuilder<ThemeCubit, ThemeMode>(
            builder: (context, themeMode) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                locale: locale,
                localizationsDelegates: const [
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales: AppLocalizations.supportedLocales,
                themeMode: themeMode,
                theme: ThemeData(
                  useMaterial3: true,
                  colorSchemeSeed: Colors.deepPurple,
                  brightness: Brightness.light,
                ),
                darkTheme: ThemeData(
                  useMaterial3: true,
                  brightness: Brightness.dark,
                  colorSchemeSeed: Colors.deepPurple,
                ),
                routes: {
                  PaymentCartScreen1.routeName: (context) => const PaymentCartScreen1(),
                },
                home: BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    if (state is AuthAuthenticated) {
                      return state.authToken.role == "admin"
                          ? const AdminMainScreen(title: 'Admin Panel')
                          : const UserMainScreen(title: 'Kho Sách');
                    }
                    if (state is AuthUnauthenticated) {
                      return const AuthScreen();
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