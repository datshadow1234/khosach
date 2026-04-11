import 'usecase.dart';

class GetUserInfoUseCase {
  final UserRepository repository;
  GetUserInfoUseCase(this.repository);
  Future<UserEntity> call(String uid, String token) => repository.getUserInfo(uid, token);
}