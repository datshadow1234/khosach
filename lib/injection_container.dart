import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shopbansach/presentation/blocs/auth_bloc/auth_bloc.dart';
import 'package:shopbansach/presentation/blocs/cart_bloc/cart_bloc.dart';
import 'package:shopbansach/presentation/blocs/login_bloc/login_bloc.dart';
import 'package:shopbansach/presentation/blocs/logout_bloc/logout_bloc.dart';
import 'package:shopbansach/presentation/blocs/order_bloc/order_bloc.dart';
import 'package:shopbansach/presentation/blocs/product_list_bloc/product_list_bloc.dart';
import 'package:shopbansach/presentation/blocs/signup_bloc/signup_bloc.dart';
import 'package:shopbansach/presentation/blocs/user_bloc/user_bloc.dart';
import 'core/Language/language_cubit.dart';
import 'data/clients/auth_client/auth_client.dart';
import 'data/clients/cart_client/cart_client.dart';
import 'data/clients/order_client/order_client.dart';
import 'data/clients/user_client/user_db_client.dart';
import 'data/clients/product_client/products_client.dart';
import 'data/datasources/auth_local_data_source.dart';
import 'data/repositories/SearchRepositoryImpl.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'data/repositories/cart_repository_impl.dart';
import 'data/repositories/login_repository_impl.dart';
import 'data/repositories/order_repository_impl.dart';
import 'data/repositories/signup_repository_impl.dart';
import 'data/repositories/logout_repository_impl.dart';
import 'data/repositories/product_repository_impl.dart';
import 'data/repositories/user_repository_impl.dart';
import 'domain/repositories/cart_repository.dart';
import 'domain/repositories/order_repository.dart';
import 'domain/repositories/product_repository.dart';
import 'domain/repositories/search_repository.dart';
import 'domain/repositories/user_repository.dart';
import 'domain/usecases/add_order_usecase.dart';
import 'domain/usecases/cart_usecase/add_to_cart_usecase.dart';
import 'domain/usecases/cart_usecase/clear_cart_usecase.dart';
import 'domain/usecases/cart_usecase/get_cart_usecase.dart';
import 'domain/usecases/cart_usecase/remove_cart_usecase.dart';
import 'domain/usecases/get_orders_usecase.dart';
import 'domain/usecases/get_products_usecase.dart';
import 'domain/usecases/get_user_info_usecase.dart';
import 'domain/usecases/search_products_usecase.dart';
import 'core/theme/theme_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  sl.registerLazySingleton(() => Dio(BaseOptions(
    baseUrl: dotenv.env['FIREBASE_URL'] ?? '',
    connectTimeout: const Duration(seconds: 15),
    receiveTimeout: const Duration(seconds: 15),
  )));

  sl.registerLazySingleton<AuthLocalDataSource>(() => AuthLocalDataSourceImpl(sharedPreferences: sl()));
  sl.registerLazySingleton(() => CartClient(sl()));
  sl.registerLazySingleton(() => AuthClient(sl()));
  sl.registerLazySingleton(() => UserDbClient(sl()));
  sl.registerLazySingleton(() => ProductClient(sl()));
  sl.registerLazySingleton(() => OrderClient(sl()));

  sl.registerLazySingleton<ProductRepository>(() => ProductRepositoryImpl(sl(), sl()));
  sl.registerLazySingleton<SearchRepository>(() => SearchRepositoryImpl());
  sl.registerLazySingleton<CartRepository>(() => CartRepositoryImpl(cartClient: sl(), authLocalDataSource: sl()));
  sl.registerLazySingleton<OrderRepository>(() => OrderRepositoryImpl(orderClient: sl()));
  sl.registerLazySingleton<UserRepository>(() => UserRepositoryImpl(userDbClient: sl()));

  sl.registerLazySingleton(() => AuthRepositoryImpl(localDataSource: sl()));
  sl.registerLazySingleton(() => LoginRepositoryImpl(authClient: sl(), userDbClient: sl(), localDataSource: sl()));
  sl.registerLazySingleton(() => SignupRepositoryImpl(authClient: sl(), userDbClient: sl(), localDataSource: sl()));
  sl.registerLazySingleton(() => LogoutRepositoryImpl(localDataSource: sl()));

  sl.registerLazySingleton(() => GetProductsUseCase(repository: sl<ProductRepository>()));
  sl.registerLazySingleton(() => SearchProductsUseCase(repository: sl<SearchRepository>()));
  sl.registerLazySingleton(() => GetCartUseCase(repository: sl<CartRepository>()));
  sl.registerLazySingleton(() => AddToCartUseCase(repository: sl<CartRepository>()));
  sl.registerLazySingleton(() => RemoveCartUseCase(repository: sl<CartRepository>()));
  sl.registerLazySingleton(() => ClearCartUseCase(repository: sl<CartRepository>()));
  sl.registerLazySingleton(() => AddOrderUseCase(sl<OrderRepository>()));
  sl.registerLazySingleton(() => GetOrdersUseCase(sl<OrderRepository>()));
  sl.registerLazySingleton(() => GetUserInfoUseCase(sl<UserRepository>()));

  sl.registerFactory(() => ThemeCubit());
  sl.registerFactory(() => LanguageCubit(sl()));
  sl.registerFactory(() => AuthBloc(repository: sl<AuthRepositoryImpl>()));
  sl.registerFactory(() => LoginBloc(repository: sl<LoginRepositoryImpl>()));
  sl.registerFactory(() => SignupBloc(repository: sl<SignupRepositoryImpl>()));
  sl.registerFactory(() => ProductListBloc(getProductsUseCase: sl(), searchProductsUseCase: sl()));
  sl.registerFactory(() => CartBloc(
    getCartUseCase: sl(),
    addToCartUseCase: sl(),
    removeCartUseCase: sl(),
    clearCartUseCase: sl(),
  ));
  sl.registerFactory(() => OrderBloc(addOrderUseCase: sl(), getOrdersUseCase: sl()));
  sl.registerFactory(() => UserBloc(getUserInfoUseCase: sl()));
  sl.registerFactory(() => LogoutBloc(repository: sl<LogoutRepositoryImpl>()));
}