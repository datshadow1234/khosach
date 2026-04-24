import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'user_db_client.g.dart';

@RestApi()
abstract class UserDbClient {
  factory UserDbClient(Dio dio, {String baseUrl}) = _UserDbClient;

  @PUT("/users/{uid}.json")
  Future<void> createUser(
      @Path("uid") String uid,
      @Query("auth") String token,
      @Body() Map<String, dynamic> data,
      );

  @GET("/users.json")
  Future<dynamic> getUserWithQuery(
      @Query("auth") String token,
      @Query("orderBy") String orderBy,
      @Query("equalTo") String equalTo,
      );
}