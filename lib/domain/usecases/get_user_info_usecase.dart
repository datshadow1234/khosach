import '../entities/user_entity.dart';
import '../repositories/user_repository.dart';

class GetUserInfoUseCase {
  final UserRepository repository;
  GetUserInfoUseCase(this.repository);
  Future<UserEntity> call(String uid, String token) => repository.getUserInfo(uid, token);
}