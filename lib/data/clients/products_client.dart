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
}