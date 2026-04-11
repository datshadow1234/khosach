import '../usecase.dart';

class AdminUpdateInfoUseCase {
  final AdminRepository repository;
  AdminUpdateInfoUseCase(this.repository);

  Future<void> call(UserEntity admin, String token) =>
      repository.updateAdminProfile(admin, token);
}