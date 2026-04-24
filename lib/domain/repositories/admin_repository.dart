import '../entities/user_entity.dart';

abstract class AdminRepository {
  Future<UserEntity> getAdminProfile(String uid, String token);
  Future<void> updateAdminProfile(UserEntity admin, String token);
  Future<List<UserEntity>> getAllUsers(String token);
  Future<void> deleteUser(String uid, String token);
}