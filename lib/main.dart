import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'data/clients/auth_client.dart';
import 'data/clients/user_db_client.dart';
import 'data/datasources/auth_local_data_source.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'data/repositories/login_repository_impl.dart';
import 'data/repositories/signup_repository_impl.dart';
import 'data/repositories/logout_repository_impl.dart';

import 'presentation/bloc/auth/auth_bloc.dart';
import 'presentation/bloc/auth/auth_event.dart';
import 'presentation/bloc/auth/auth_state.dart';
import 'presentation/bloc/login/login_bloc.dart';
import 'presentation/bloc/signup/signup_bloc.dart';
import 'presentation/bloc/logout/logout_bloc.dart';
import 'presentation/bloc/logout/logout_event.dart';
import 'presentation/bloc/logout/logout_state.dart';

import 'presentation/screens/auth/auth_screen.dart';
import 'presentation/screens/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  final sharedPreferences = await SharedPreferences.getInstance();
  runApp(MyApp(sharedPreferences: sharedPreferences));
}

class MyApp extends StatelessWidget {
  final SharedPreferences sharedPreferences;

  const MyApp({super.key, required this.sharedPreferences});

  @override
  Widget build(BuildContext context) {
    final dio = Dio(BaseOptions(connectTimeout: const Duration(seconds: 15)));
    final authClient = AuthClient(dio);
    final userDbClient = UserDbClient(dio);
    final authLocalDataSource = AuthLocalDataSourceImpl(sharedPreferences: sharedPreferences);

    final appAuthRepo = AuthRepositoryImpl(localDataSource: authLocalDataSource);
    final loginRepo = LoginRepositoryImpl(authClient: authClient, userDbClient: userDbClient, localDataSource: authLocalDataSource);
    final signupRepo = SignupRepositoryImpl(authClient: authClient, userDbClient: userDbClient, localDataSource: authLocalDataSource);
    final logoutRepo = LogoutRepositoryImpl(localDataSource: authLocalDataSource);

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthBloc(repository: appAuthRepo)..add(AppStarted())),
        BlocProvider(create: (_) => LoginBloc(repository: loginRepo)),
        BlocProvider(create: (_) => SignupBloc(repository: signupRepo)),
        BlocProvider(create: (_) => LogoutBloc(repository: logoutRepo)),
      ],
      child: MaterialApp(
        title: 'Cửa hàng sách',
        theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple), useMaterial3: true),
        home: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthAuthenticated) {
              if (state.authToken.role == "admin") return const MyHomePage1(title: 'Admin Screen');
              return const MyHomePage(title: 'User Screen');
            } else if (state is AuthUnauthenticated) {
              return const AuthScreen();
            }
            return const SplashScreen();
          },
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int index = 0;
  @override
  Widget build(BuildContext context) {
    return BlocListener<LogoutBloc, LogoutState>(
      listener: (context, state) {
        if (state is LogoutSuccess) context.read<AuthBloc>().add(AuthLoggedOut());
      },
      child: Scaffold(
        appBar: AppBar(title: Text(widget.title), actions: [
          IconButton(icon: const Icon(Icons.logout), onPressed: () => context.read<LogoutBloc>().add(LogoutSubmitted()))
        ]),
        body: const Center(child: Text('User Home Page Content')),
        bottomNavigationBar: NavigationBarTheme(
          data: const NavigationBarThemeData(),
          child: NavigationBar(
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
      ),
    );
  }
}

class MyHomePage1 extends StatefulWidget {
  const MyHomePage1({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage1> createState() => _MyHomePage1State();
}

class _MyHomePage1State extends State<MyHomePage1> {
  int index = 0;
  @override
  Widget build(BuildContext context) {
    return BlocListener<LogoutBloc, LogoutState>(
      listener: (context, state) {
        if (state is LogoutSuccess) context.read<AuthBloc>().add(AuthLoggedOut());
      },
      child: Scaffold(
        appBar: AppBar(title: Text(widget.title), actions: [
          IconButton(icon: const Icon(Icons.logout), onPressed: () => context.read<LogoutBloc>().add(LogoutSubmitted()))
        ]),
        body: const Center(child: Text('Admin Home Page Content')),
        bottomNavigationBar: NavigationBarTheme(
          data: const NavigationBarThemeData(),
          child: NavigationBar(
            selectedIndex: index,
            onDestinationSelected: (idx) => setState(() => index = idx),
            destinations: const [
              NavigationDestination(icon: Icon(Icons.home), label: "Admin"),
              NavigationDestination(icon: Icon(Icons.search), label: "Tìm kiếm"),
              NavigationDestination(icon: Icon(Icons.account_circle_outlined), label: "Cá nhân"),
            ],
          ),
        ),
      ),
    );
  }
}