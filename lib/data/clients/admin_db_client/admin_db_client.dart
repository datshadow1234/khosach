import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
part 'admin_db_client.g.dart';

@RestApi(baseUrl: "https://bookstore-project-f0504-default-rtdb.asia-southeast1.firebasedatabase.app")
abstract class AdminDbClient {
  factory AdminDbClient(Dio dio, {String baseUrl}) = _AdminDbClient;

  @GET("/users.json")
  Future<dynamic> getAdminWithQuery(
      @Query("auth") String token,
      @Query("orderBy") String orderBy,
      @Query("equalTo") String equalTo,
      );

  @PATCH("/users/{firebaseUrl}.json")
  Future<void> updateAdminInfo(
      @Path("firebaseUrl") String firebaseUrl,
      @Query("auth") String token,
      @Body() Map<String, dynamic> body,
      );

  @GET("/users.json")
  Future<dynamic> getAllUsers(
      @Query("auth") String token,
      );

  @DELETE("/users/{firebaseUrl}.json")
  Future<void> deleteUser(
      @Path("firebaseUrl") String firebaseUrl,
      @Query("auth") String token,
      );
}