import 'repositories_widget.dart';

class UserRepositoryImpl implements UserRepository {
  final UserDbClient userDbClient;

  UserRepositoryImpl({required this.userDbClient});

  @override
  Future<void> createUser(
      String uid,
      String token,
      String email,
      String phone,
      String name,
      String address,
      ) async {
    await userDbClient.createUser(
      uid,
      token,
      {
        'uid': uid,
        'email': email,
        'name': name,
        'phone': phone,
        'address': address,
        'role': 'user',
      },
    );
  }

  @override
  Future<UserEntity> getUserInfo(String uid, String token) async {
    try {
      final response = await userDbClient.getUserInfo(uid, token);
      if (response == null) {
        return UserEntity(
          uid: uid,
          imageUrl: '',
          email: 'Chưa cập nhật',
          name: 'Khách hàng',
          phone: 'Chưa có SĐT',
          address: 'Chưa cập nhật địa chỉ giao hàng',
          role: 'user',
        );
      }

      final model = UserModel.fromJson(Map<String, dynamic>.from(response));
      return UserModel.toEntity(model);

    } catch (e) {
      throw Exception('Lỗi xử lý dữ liệu User: $e');
    }
  }

  @override
  Future<String> getUserRole(String uid, String token) async {
    try {
      final response = await userDbClient.getUserInfo(uid, token);
      if (response == null) return 'user';
      return response['role'] ?? 'user';
    } catch (e) {
      return 'user';
    }
  }
}