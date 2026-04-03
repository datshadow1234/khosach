import '../entities/auth_token_entity.dart';

abstract class AuthRepository {
  Future<AuthTokenEntity?> tryAutoLogin();
}