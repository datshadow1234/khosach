import 'usecase_widget.dart';

class GetAdminProfileUseCase {
  final AdminRepository repository;

  GetAdminProfileUseCase(this.repository);

  Future<UserEntity> call(String uid, String token) {
    return repository.getAdminProfile(uid, token);
  }
}