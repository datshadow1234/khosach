abstract class UserRepository {
  Future<void> createUser(String uid, String token, String email, String phone, String name, String address);
  Future<String> getUserRole(String uid, String token);
}