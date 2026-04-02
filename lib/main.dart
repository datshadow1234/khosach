import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopbansach/presentation/bloc/auth_bloc.dart';
import 'package:shopbansach/presentation/bloc/auth_event.dart';
import 'package:shopbansach/presentation/bloc/auth_state.dart';
import 'package:shopbansach/presentation/screens/auth/auth_screen.dart';
import 'package:shopbansach/presentation/screens/chatbot_rasa_ai/chatbot_rasa_ai.dart';
import 'package:shopbansach/presentation/screens/splash_screen.dart';

import 'data/clients/auth_client.dart';
import 'data/clients/user_db_client.dart';
import 'data/datasources/auth_local_data_source.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'data/repositories/user_repository_impl.dart';
import 'domain/usecases/login_usecase.dart';
import 'domain/usecases/logout_usecase.dart';
import 'domain/usecases/signup_usecase.dart';
import 'domain/usecases/try_auto_login_usecase.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

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
    // 1. Khởi tạo Dio
    final dio = Dio(BaseOptions(connectTimeout: const Duration(seconds: 15)));

    // 2. Khởi tạo Clients
    final authClient = AuthClient(dio);
    final userDbClient = UserDbClient(dio);

    // 3. Khởi tạo Local Storage
    final authLocalDataSource = AuthLocalDataSourceImpl(sharedPreferences: sharedPreferences);

    // 4. Khởi tạo Repositories
    final authRepository = AuthRepositoryImpl(
      authClient: authClient,
      localDataSource: authLocalDataSource,
    );
    final userRepository = UserRepositoryImpl(
      userDbClient: userDbClient,
    );

    // 5. Khởi tạo UseCases & BLoC
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthBloc(
            loginUseCase: LoginUseCase(
                authRepository: authRepository,
                userRepository: userRepository
            ),
            signupUseCase: SignupUseCase(
                authRepository: authRepository,
                userRepository: userRepository
            ),
            logoutUseCase: LogoutUseCase(authRepository),
            tryAutoLoginUseCase: TryAutoLoginUseCase(authRepository),
          )..add(AppStarted()),
        ),
      ],
      child: MaterialApp(
        title: 'Cửa hàng sách',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            // Xử lý điều hướng dựa trên State của BLoC
            if (state is AuthAuthenticated) {
              if (state.authToken.role == "admin") {
                return const MyHomePage1(title: 'Admin Screen');
              } else {
                return const MyHomePage(title: 'User Screen');
              }
            } else if (state is AuthUnauthenticated || state is AuthFailure) {
              return const AuthScreen();
            }
            // Mặc định (AuthInitial hoặc AuthLoading) sẽ hiện SplashScreen
            return const SplashScreen();
          },
        ),
        routes: {
          ChatbotScreen1.routeName: (context) => const ChatbotScreen1(),
        },
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  static const routeName = '/';
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int index = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title), actions: [
        IconButton(
          icon: Icon(Icons.logout),
          onPressed: () => context.read<AuthBloc>().add(LogoutRequested()),
        )
      ]),
      body: Center(child: Text('User Home Page Content')),
      bottomNavigationBar: NavigationBarTheme(
        data: const NavigationBarThemeData(),
        child: NavigationBar(
          selectedIndex: index,
          onDestinationSelected: (index) => setState(() => (this.index = index)),
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

class MyHomePage1 extends StatefulWidget {
  const MyHomePage1({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage1> createState() => _MyHomePage1State();
}

class _MyHomePage1State extends State<MyHomePage1> {
  late int index = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title), actions: [
        IconButton(
          icon: Icon(Icons.logout),
          onPressed: () => context.read<AuthBloc>().add(LogoutRequested()),
        )
      ]),
      body: Center(child: Text('Admin Home Page Content')),
      bottomNavigationBar: NavigationBarTheme(
        data: const NavigationBarThemeData(),
        child: NavigationBar(
          selectedIndex: index,
          onDestinationSelected: (index) => setState(() => (this.index = index)),
          destinations: const [
            NavigationDestination(icon: Icon(Icons.home), label: "Admin"),
            NavigationDestination(icon: Icon(Icons.search), label: "Tìm kiếm"),
            NavigationDestination(icon: Icon(Icons.account_circle_outlined), label: "Cá nhân"),
          ],
        ),
      ),
    );
  }
}
