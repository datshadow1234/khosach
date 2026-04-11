import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'products_client.g.dart';

@RestApi()
abstract class ProductClient {
  factory ProductClient(Dio dio, {String? baseUrl}) = _ProductClient;

  @GET('/products.json')
  Future<dynamic> getProducts(
      @Query('auth') String token,
      );

  @POST('/products.json')
  Future<dynamic> addProduct(
      @Query('auth') String token,
      @Body() Map<String, dynamic> body,
      );

  @PATCH('/products/{id}.json')
  Future<dynamic> updateProduct(
      @Path('id') String id,
      @Query('auth') String token,
      @Body() Map<String, dynamic> body,
      );

  @DELETE('/products/{id}.json')
  Future<void> deleteProduct(
      @Path('id') String id,
      @Query('auth') String token,
      );
}