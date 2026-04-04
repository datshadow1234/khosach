import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'data/clients/auth_client.dart';
import 'data/clients/user_db_client.dart';
import 'data/clients/products_client.dart';
import 'data/datasources/auth_local_data_source.dart';
import 'data/repositories/SearchRepositoryImpl.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'data/repositories/login_repository_impl.dart';
import 'data/repositories/signup_repository_impl.dart';
import 'data/repositories/logout_repository_impl.dart';
import 'data/repositories/product_repository_impl.dart';
import 'domain/usecases/get_products_usecase.dart';
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

  // 3. Repositories
  sl.registerLazySingleton(() => AuthRepositoryImpl(localDataSource: sl()));
  sl.registerLazySingleton(() => LoginRepositoryImpl(authClient: sl(), userDbClient: sl(), localDataSource: sl()));
  sl.registerLazySingleton(() => SignupRepositoryImpl(authClient: sl(), userDbClient: sl(), localDataSource: sl()));
  sl.registerLazySingleton(() => LogoutRepositoryImpl(localDataSource: sl()));
  sl.registerLazySingleton(() => ProductRepositoryImpl(sl(), sl()));

  sl.registerLazySingleton(() => GetProductsUseCase(repository: sl<ProductRepositoryImpl>()));
  sl.registerLazySingleton(() => SearchProductsUseCase(repository: SearchRepositoryImpl()));

  sl.registerFactory(() => ThemeCubit());
  sl.registerFactory(() => AuthBloc(repository: sl<AuthRepositoryImpl>()));
  sl.registerFactory(() => LoginBloc(repository: sl<LoginRepositoryImpl>()));
  sl.registerFactory(() => SignupBloc(repository: sl<SignupRepositoryImpl>()));
  sl.registerFactory(() => LogoutBloc(repository: sl<LogoutRepositoryImpl>()));
  sl.registerFactory(() => ProductListBloc(getProductsUseCase: sl(), searchProductsUseCase: sl()));
  sl.registerFactory(() => ProductDetailBloc());
}