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
      final response = await userDbClient.getUserWithQuery(token, '"uid"', '"$uid"');

      if (response.isEmpty) {
        return UserEntity(
          uid: uid, imageUrl: '', email: 'Chưa cập nhật',
          name: 'Khách hàng', phone: 'Chưa có SĐT',
          address: 'Chưa cập nhật', role: 'user',
        );
      }
      final userData = Map<String, dynamic>.from(response.values.first);
      final model = UserModel.fromJson(userData);
      return UserModel.toEntity(model);

    } catch (e) {
      throw Exception('Lỗi xử lý dữ liệu User: $e');
    }
  }

  @override
  Future<String> getUserRole(String uid, String token) async {
    try {
      final response = await userDbClient.getUserWithQuery(token, '"uid"', '"$uid"');

      if (response.isNotEmpty) {
        final userData = response.values.first;

        final role = userData['role']?.toString().toLowerCase().trim() ?? 'user';
        debugPrint("--- QUYỀN HẠN TÌM THẤY: $role ---");
        return role;
      }
    } catch (e) {
      debugPrint("Lỗi lấy role: $e");
    }
    return 'user';
  }
}