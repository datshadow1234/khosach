import '../entities/user_entity.dart';

abstract class UserRepository {
  Future<void> createUser(
      String uid,
      String token,
      String email,
      String phone,
      String name,
      String address,
      String imageUrl,
      );

  Future<UserEntity> getUserInfo(String uid, String token);

  Future<String> getUserRole(String uid, String token);
}