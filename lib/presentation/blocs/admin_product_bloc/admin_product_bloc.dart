import 'admin_product_bloc_widget.dart';

class AdminProductBloc extends Bloc<AdminProductEvent, AdminProductState> {
  final GetProductsUseCase getProductsUseCase;
  final AddProductUseCase addProductUseCase;
  final UpdateProductUseCase updateProductUseCase;
  final DeleteProductUseCase deleteProductUseCase;

  AdminProductBloc({
    required this.getProductsUseCase,
    required this.addProductUseCase,
    required this.updateProductUseCase,
    required this.deleteProductUseCase,
  }) : super(AdminProductInitial()) {

    on<FetchAdminProducts>((event, emit) async {
      emit(AdminProductLoading());
      try {
        final products = await getProductsUseCase.execute();
        emit(AdminProductLoaded(allProducts: products, displayProducts: products));
      } catch (e) {
        emit(AdminProductError(e.toString()));
      }
    });

    on<SearchAdminProducts>((event, emit) {
      if (state is AdminProductLoaded) {
        final current = state as AdminProductLoaded;
        final filtered = current.allProducts.where((p) =>
            p.title.toLowerCase().contains(event.query.toLowerCase())
        ).toList();
        emit(AdminProductLoaded(allProducts: current.allProducts, displayProducts: filtered));
      }
    });

    on<AddAdminProduct>((event, emit) async {
      emit(AdminProductActionLoading());
      try {
        await addProductUseCase.execute(event.product);
        emit(AdminProductActionSuccess());
        add(FetchAdminProducts()); // Load lại list sau khi thêm
      } catch (e) {
        emit(AdminProductError(e.toString()));
      }
    });

    on<UpdateAdminProduct>((event, emit) async {
      emit(AdminProductActionLoading());
      try {
        await updateProductUseCase.execute(event.product);
        emit(AdminProductActionSuccess());
        add(FetchAdminProducts());
      } catch (e) {
        emit(AdminProductError(e.toString()));
      }
    });

    on<DeleteAdminProduct>((event, emit) async {
      try {
        await deleteProductUseCase.execute(event.id);
        add(FetchAdminProducts());
      } catch (e) {
        emit(AdminProductError(e.toString()));
      }
    });
  }
}
