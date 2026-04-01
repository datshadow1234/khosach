import '../entities/auth_token_entity.dart';

abstract class AuthRepository {
  Future<AuthTokenEntity> login(String email, String password);
  Future<AuthTokenEntity> signup(
    String email,
    String password,
    String phone,
    String name,
    String address,
  );
  Future<AuthTokenEntity?> tryAutoLogin();
  Future<void> logout();
}
