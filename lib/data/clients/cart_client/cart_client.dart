import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../models/cart_model/cart_item_model.dart';

part 'cart_client.g.dart';
@RestApi()
abstract class CartClient {
  factory CartClient(Dio dio, {String baseUrl}) = _CartClient;

  @GET("/carts/{uid}.g.json")
  Future<Map<String, CartItemModel>?> getCart(
      @Path("uid") String uid,
      @Query("auth") String token,
      );

  @PUT("/carts/{uid}.json")
  Future<void> updateCart(
      @Path("uid") String uid,
      @Query("auth") String token,
      @Body() Map<String, dynamic> cartData,
      );

  @DELETE("/carts/{uid}.json")
  Future<void> deleteCart(
      @Path("uid") String uid,
      @Query("auth") String token,
      );
}