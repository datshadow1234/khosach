import '../entities/auth_token_entity.dart';

abstract class AuthRepository {
  Future<AuthTokenEntity> login(String email, String password);
  Future<AuthTokenEntity> signup(String email, String password);
  Future<void> saveLocalToken(AuthTokenEntity entity);
  Future<AuthTokenEntity?> tryAutoLogin();
  Future<void> logout();
}