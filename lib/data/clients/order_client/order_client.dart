import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'order_client.g.dart';

@RestApi()
abstract class OrderClient {
  factory OrderClient(Dio dio, {String baseUrl}) = _OrderClient;

  @POST("/orders.json")
  Future<void> createOrder(
      @Query("auth") String token,
      @Body() Map<String, dynamic> orderData,
      );

  @GET("/orders.json")
  Future<dynamic> getOrders(
      @Query("auth") String token,
      @Query("orderBy") String? orderBy,
      @Query("equalTo") String? uid,
      );
  @PATCH("/orders/{id}.json")
  Future<void> updateOrderStatus(
      @Path("id") String id,
      @Query("auth") String token,
      @Body() Map<String, dynamic> data,
      );
}