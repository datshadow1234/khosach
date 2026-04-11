import '/core/widgets/widget.dart';

final sl = GetIt.instance;

Future<void> init() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  final authDio = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 15),
    receiveTimeout: const Duration(seconds: 15),
  ));

  final dbDio = Dio(BaseOptions(
    baseUrl: dotenv.env['FIREBASE_URL'] ?? '',
    connectTimeout: const Duration(seconds: 15),
    receiveTimeout: const Duration(seconds: 15),
  ));

  sl.registerLazySingleton<Dio>(() => dbDio);
  sl.registerLazySingleton<Dio>(() => authDio, instanceName: 'authDio');

  sl.registerLazySingleton<AuthLocalDataSource>(() => AuthLocalDataSourceImpl(sharedPreferences: sl()));
  sl.registerLazySingleton(() => CartClient(sl()));
  sl.registerLazySingleton(() => AuthClient(sl()));
  sl.registerLazySingleton(() => UserDbClient(sl()));
  sl.registerLazySingleton(() => ProductClient(sl()));
  sl.registerLazySingleton(() => OrderClient(sl()));

  sl.registerLazySingleton<ProductRepository>(() => ProductRepositoryImpl(sl(), sl()));
  sl.registerLazySingleton<SearchRepository>(() => SearchRepositoryImpl());
  sl.registerFactory<CartRepository>(() => CartRepositoryImpl(
    cartClient: sl(),
    authLocalDataSource: sl(),
  ));
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

  sl.registerLazySingleton(() => AddProductUseCase(repository: sl<ProductRepository>()));
  sl.registerLazySingleton(() => UpdateProductUseCase(repository: sl<ProductRepository>()));
  sl.registerLazySingleton(() => DeleteProductUseCase(repository: sl<ProductRepository>()));

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

  sl.registerFactory(() => AdminProductBloc(
    getProductsUseCase: sl(),
    addProductUseCase: sl(),
    updateProductUseCase: sl(),
    deleteProductUseCase: sl(),
  ));
  sl.registerLazySingleton(() => AdminDbClient(sl()));
  sl.registerLazySingleton<AdminRepository>(() => AdminRepositoryImpl(adminDbClient: sl()),);

  sl.registerLazySingleton(() => GetAdminProfileUseCase(sl()));
  sl.registerLazySingleton(() => AdminUpdateInfoUseCase(sl()));

  sl.registerFactory(() => AdminProfileBloc(
      getAdminProfileUseCase: sl(),
      adminUpdateInfoUseCase: sl(),
    ),
  );
  sl.registerLazySingleton<StatisticRepository>(
        () => StatisticRepositoryImpl(orderClient: sl<OrderClient>()),
  );

  sl.registerFactory(() => StatisticBloc(repository: sl<StatisticRepository>()));
}