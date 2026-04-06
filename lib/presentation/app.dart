import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shopbansach/presentation/screens/payment_cart/payment_cart_screen.dart';
import 'package:shopbansach/presentation/screens/user_main_screen.dart';
import '../core/Language/language_cubit.dart';
import 'blocs/auth_bloc/auth_bloc.dart';
import 'blocs/auth_bloc/auth_event.dart';
import 'blocs/auth_bloc/auth_state.dart';
import 'blocs/cart_bloc/cart_bloc.dart';
import 'blocs/cart_bloc/cart_event.dart';
import 'blocs/login_bloc/login_bloc.dart';
import 'blocs/logout_bloc/logout_bloc.dart';
import 'blocs/order_bloc/order_bloc.dart';
import 'blocs/product_list_bloc/product_list_bloc.dart';
import 'blocs/product_list_bloc/product_list_event.dart';
import 'blocs/signup_bloc/signup_bloc.dart';
import 'blocs/user_bloc/user_bloc.dart';
import 'screens/admin_main_screen.dart';
import '../injection_container.dart';
import '../core/theme/theme_cubit.dart';
import 'screens/auth/auth_screen.dart';
import 'screens/splash_screen.dart';

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