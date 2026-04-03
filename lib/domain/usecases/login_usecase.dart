import '../entities/auth_token_entity.dart';
import '../repositories/login_repository.dart';

class LoginUseCase {
  final LoginRepository repository;

  LoginUseCase({required this.repository});

  Future<AuthTokenEntity> call(String email, String password) async {
    final baseEntity = await repository.signIn(email, password);
    final role = await repository.getUserRole(baseEntity.userId, baseEntity.token);

    final finalEntity = AuthTokenEntity(
      token: baseEntity.token,
      userId: baseEntity.userId,
      expiryDate: baseEntity.expiryDate,
      role: role,
    );

    await repository.saveLocalToken(finalEntity);

    return finalEntity;
  }
}