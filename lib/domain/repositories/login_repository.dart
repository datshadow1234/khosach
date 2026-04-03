import '../entities/auth_token_entity.dart';

abstract class LoginRepository {
  Future<AuthTokenEntity> signIn(String email, String password);
  Future<String> getUserRole(String uid, String token);
  Future<void> saveLocalToken(AuthTokenEntity entity);
}