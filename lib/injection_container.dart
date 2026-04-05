import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shopbansach/presentation/bloc/cart_bloc/cart_bloc.dart';
import 'core/Language/language_cubit.dart';
import 'data/clients/auth_client.dart';
import 'data/clients/user_db_client.dart';
import 'data/clients/products_client.dart';
import 'data/datasources/auth_local_data_source.dart';
import 'data/repositories/SearchRepositoryImpl.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'data/repositories/cart_repository_impl.dart';
import 'data/repositories/login_repository_impl.dart';
import 'data/repositories/signup_repository_impl.dart';
import 'data/repositories/logout_repository_impl.dart';
import 'data/repositories/product_repository_impl.dart';
import 'domain/repositories/cart_repository.dart';
import 'domain/repositories/product_repository.dart';
import 'domain/repositories/search_repository.dart';
import 'domain/usecases/add_to_cart_usecase.dart';
import 'domain/usecases/clear_cart_usecase.dart';
import 'domain/usecases/get_cart_usecase.dart';
import 'domain/usecases/get_products_usecase.dart';
import 'domain/usecases/remove_cart_usecase.dart';
import 'domain/usecases/search_products_usecase.dart';
import 'presentation/bloc/auth_bloc/auth_bloc.dart';
import 'presentation/bloc/login_bloc/login_bloc.dart';
import 'presentation/bloc/logout_bloc/logout_bloc.dart';
import 'presentation/bloc/product_detail_bloc/product_detail_bloc.dart';
import 'presentation/bloc/product_list_bloc/product_list_bloc.dart';
import 'presentation/bloc/signup_bloc/signup_bloc.dart';
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
  sl.registerLazySingleton(() => AuthClient(sl()));
  sl.registerLazySingleton(() => UserDbClient(sl()));
  sl.registerLazySingleton(() => ProductClient(sl()));

  sl.registerLazySingleton<ProductRepository>(() => ProductRepositoryImpl(sl(), sl()));
  sl.registerLazySingleton<SearchRepository>(() => SearchRepositoryImpl());

  sl.registerLazySingleton(() => AuthRepositoryImpl(localDataSource: sl()));
  sl.registerLazySingleton(() => LoginRepositoryImpl(authClient: sl(), userDbClient: sl(), localDataSource: sl()));
  sl.registerLazySingleton(() => SignupRepositoryImpl(authClient: sl(), userDbClient: sl(), localDataSource: sl()));
  sl.registerLazySingleton(() => LogoutRepositoryImpl(localDataSource: sl()));

  sl.registerLazySingleton(() => GetProductsUseCase(repository: sl<ProductRepository>()));
  sl.registerLazySingleton(() => SearchProductsUseCase(repository: sl<SearchRepository>()));

  sl.registerFactory(() => ThemeCubit());
  sl.registerFactory(() => AuthBloc(repository: sl<AuthRepositoryImpl>()));
  sl.registerFactory(() => LoginBloc(repository: sl<LoginRepositoryImpl>()));
  sl.registerFactory(() => SignupBloc(repository: sl<SignupRepositoryImpl>()));
  sl.registerFactory(() => LogoutBloc(repository: sl<LogoutRepositoryImpl>()));
  sl.registerFactory(() => ProductListBloc(getProductsUseCase: sl(), searchProductsUseCase: sl()));
  sl.registerFactory(() => ProductDetailBloc());

  sl.registerLazySingleton<CartRepository>(() => CartRepositoryImpl());

  sl.registerLazySingleton(() => GetCartUseCase(repository: sl<CartRepository>()));
  sl.registerLazySingleton(() => AddToCartUseCase(repository: sl<CartRepository>()));
  sl.registerLazySingleton(() => RemoveCartUseCase(repository: sl<CartRepository>()));
  sl.registerLazySingleton(() => ClearCartUseCase(repository: sl<CartRepository>()));

  sl.registerFactory(() => CartBloc(
    getCartUseCase: sl(),
    addToCartUseCase: sl(),
    removeCartUseCase: sl(),
    clearCartUseCase: sl(),
  ));
  sl.registerFactory(() => LanguageCubit(sl<SharedPreferences>()));
}