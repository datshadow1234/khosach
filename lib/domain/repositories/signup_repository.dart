import '../entities/auth_token_entity.dart';

abstract class SignupRepository {
  Future<AuthTokenEntity> signUp(String email, String password);
  Future<void> createUserInfo(String uid, String token, Map<String, dynamic> data);
  Future<void> saveLocalToken(AuthTokenEntity entity);
}