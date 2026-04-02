import '../../domain/repositories/user_repository.dart';
import '../clients/user_db_client.dart';

class UserRepositoryImpl implements UserRepository {
  final UserDbClient userDbClient;

  UserRepositoryImpl({required this.userDbClient});

  @override
  Future<void> createUser(String uid, String token, String email, String phone, String name, String address) async {
    await userDbClient.createUser(uid, token, {
      'uid': uid,
      'email': email,
      'name': name,
      'phone': phone,
      'address': address,
      'birthday': '',
      'role': 'user'
    });
  }

  @override
  Future<String> getUserRole(String uid, String token) async {
    try {
      final userData = await userDbClient.getUserInfo(uid, token);
      if (userData != null && userData['role'] != null) {
        return userData['role'];
      }
    } catch (e) {
      print("Lỗi lấy Role từ DB: $e");
    }
    return 'user'; // Fallback an toàn
  }
}