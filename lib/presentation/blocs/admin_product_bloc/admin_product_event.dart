import 'admin_product.dart';

  abstract class AdminProductEvent extends Equatable {
  @override
  List<Object?> get props => [];
  }
  class FetchAdminProducts extends AdminProductEvent {}
  class SearchAdminProducts extends AdminProductEvent {
  final String query;
  SearchAdminProducts(this.query);
  }
  class AddAdminProduct extends AdminProductEvent {
  final ProductEntity product;
  AddAdminProduct(this.product);
  }
  class UpdateAdminProduct extends AdminProductEvent {
  final ProductEntity product;
  UpdateAdminProduct(this.product);
  }
  class DeleteAdminProduct extends AdminProductEvent {
  final String id;
  DeleteAdminProduct(this.id);
  }