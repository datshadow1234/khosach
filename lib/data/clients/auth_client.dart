import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../models/auth_response_model.dart';

part 'auth_client.g.dart';

@RestApi(baseUrl: "https://identitytoolkit.googleapis.com/v1")
abstract class AuthClient {
  factory AuthClient(Dio dio, {String baseUrl}) = _AuthClient;

  @POST("/accounts:signInWithPassword")
  Future<AuthResponseModel> signIn(
      @Query("key") String apiKey,
      @Body() Map<String, dynamic> body,
      );

  @POST("/accounts:signUp")
  Future<AuthResponseModel> signUp(
      @Query("key") String apiKey,
      @Body() Map<String, dynamic> body,
      );
}