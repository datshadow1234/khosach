import '../entities/auth_token_entity.dart';
import '../repositories/auth_repository.dart';
import '../repositories/user_repository.dart';

class SignupUseCase {
  final AuthRepository authRepository;
  final UserRepository userRepository;

  SignupUseCase({required this.authRepository, required this.userRepository});

  Future<AuthTokenEntity> call(
      String email, String password, String phone, String name, String address,
      ) async {
    // 1. Đăng ký qua Auth Repo
    final baseEntity = await authRepository.signup(email, password);

    // 2. Tạo profile User qua User Repo
    await userRepository.createUser(baseEntity.userId, baseEntity.token, email, phone, name, address);

    // Mặc định tạo mới là user
    final finalEntity = AuthTokenEntity(
      token: baseEntity.token,
      userId: baseEntity.userId,
      expiryDate: baseEntity.expiryDate,
      role: 'user',
    );

    // 3. Lưu Local
    await authRepository.saveLocalToken(finalEntity);

    return finalEntity;
  }
}