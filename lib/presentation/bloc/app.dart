import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopbansach/presentation/bloc/logout_bloc/logout_bloc.dart';
import 'package:shopbansach/presentation/screens/user_main_screen.dart';
import '../screens/admin_main_screen.dart';
import '../../injection_container.dart';
import 'auth_bloc/auth_bloc.dart';
import 'auth_bloc/auth_event.dart';
import 'auth_bloc/auth_state.dart';
import 'product_list_bloc/product_list_bloc.dart';
import 'product_list_bloc/product_list_event.dart';
import '../../core/theme/theme_cubit.dart';
import '../screens/auth/auth_screen.dart';
import '../screens/splash_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<ThemeCubit>()),
        BlocProvider(create: (_) => sl<AuthBloc>()..add(AppStarted())),
        BlocProvider(create: (_) => sl<ProductListBloc>()..add(FetchProductsEvent())),
        BlocProvider(create: (_) => sl<LogoutBloc>()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            themeMode: themeMode,
            theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.deepPurple, brightness: Brightness.light),
            darkTheme: ThemeData(useMaterial3: true, brightness: Brightness.dark, colorSchemeSeed: Colors.deepPurple),
            home: BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                if (state is AuthAuthenticated) {
                  return state.authToken.role == "admin"
                      ? const AdminMainScreen(title: 'Admin Panel')
                      : const UserMainScreen(title: 'Kho Sách');
                }
                return state is AuthUnauthenticated ? const AuthScreen() : const SplashScreen();
              },
            ),
          );
        },
      ),
    );
  }
}