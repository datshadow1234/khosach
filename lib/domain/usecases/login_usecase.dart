import '../entities/auth_token_entity.dart';
import '../repositories/auth_repository.dart';
import '../repositories/user_repository.dart';

class LoginUseCase {
  final AuthRepository authRepository;
  final UserRepository userRepository;

  LoginUseCase({required this.authRepository, required this.userRepository});

  Future<AuthTokenEntity> call(String email, String password) async {
    // 1. Lấy Token từ Auth Repo
    final baseEntity = await authRepository.login(email, password);

    // 2. Lấy Role từ User Repo
    final role = await userRepository.getUserRole(baseEntity.userId, baseEntity.token);

    // 3. Gộp lại
    final finalEntity = AuthTokenEntity(
      token: baseEntity.token,
      userId: baseEntity.userId,
      expiryDate: baseEntity.expiryDate,
      role: role,
    );

    // 4. Lưu Local
    await authRepository.saveLocalToken(finalEntity);

    return finalEntity;
  }
}