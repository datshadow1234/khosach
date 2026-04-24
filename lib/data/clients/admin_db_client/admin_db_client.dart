import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'admin_db_client.g.dart';

@RestApi()
abstract class AdminDbClient {
  factory AdminDbClient(Dio dio, {String baseUrl}) = _AdminDbClient;

  @GET("/users/{uid}.json")
  Future<dynamic> getAdminDirect(
      @Path("uid") String uid,
      @Query("auth") String token,
      );

  @GET("/users.json")
  Future<dynamic> getAdminWithQuery(
      @Query("auth") String token,
      @Query("orderBy") String orderBy,
      @Query("equalTo") String equalTo,
      );

  @PATCH("/users/{uid}.json")
  Future<void> updateAdminInfo(
      @Path("uid") String uid,
      @Query("auth") String token,
      @Body() Map<String, dynamic> body,
      );

  @GET("/users.json")
  Future<dynamic> getAllUsers(
      @Query("auth") String token,
      );

  @DELETE("/users/{uid}.json")
  Future<void> deleteUser(
      @Path("uid") String uid,
      @Query("auth") String token,
      );
}