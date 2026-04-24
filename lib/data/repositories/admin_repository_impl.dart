import 'repositories.dart';

class AdminRepositoryImpl implements AdminRepository {
  final AdminDbClient adminDbClient;

  AdminRepositoryImpl({required this.adminDbClient});

  @override
  Future<UserEntity> getAdminProfile(String uid, String token) async {
    try {
      final response = await adminDbClient.getAdminDirect(uid, token);
      if (response.isEmpty) {
        throw Exception("Không tìm thấy dữ liệu Admin tại node: $uid");
      }
      final model = AdminModel.fromJson(response);

      return model.toEntity();
    } catch (e) {
      throw Exception('AdminRepo Error: $e');
    }
  }

  @override
  Future<void> updateAdminProfile(UserEntity admin, String token) async {
    try {
      await adminDbClient.updateAdminInfo(
        admin.uid,
        token,
        {
          'name': admin.name,
          'phone': admin.phone,
          'address': admin.address,
        },
      );
    } catch (e) {
      throw Exception('Admin Update Error: $e');
    }
  }
  @override
  Future<List<UserEntity>> getAllUsers(String token) async {
    try {
      final response = await adminDbClient.getAllUsers(token);
      if (response == null || response is! Map || response.isEmpty) {
        return [];
      }
      final List<UserEntity> users = [];
      response.forEach((key, value) {
        if (value == null || value is! Map) return;
        final data = Map<String, dynamic>.from(value as Map);
        final role = (data['role'] ?? 'user').toString().toLowerCase().trim();
        if (role != 'user') return;

        users.add(
          UserEntity(
            uid: (data['uid'] ?? key).toString(),
            imageUrl: (data['imageUrl'] ?? '').toString(),
            email: (data['email'] ?? '').toString(),
            name: (data['name'] ?? '').toString(),
            phone: (data['phone'] ?? '').toString(),
            address: (data['address'] ?? '').toString(),
            role: role,
            latitude: (data['latitude'] is num)
                ? (data['latitude'] as num).toDouble()
                : 0.0,
            longitude: (data['longitude'] is num)
                ? (data['longitude'] as num).toDouble()
                : 0.0,
          ),
        );
      });
      return users;
    } catch (e) {
      throw Exception('Get All Users Error: $e');
    }
  }

  @override
  Future<void> deleteUser(String uid, String token) async {
    try {
      await adminDbClient.deleteUser(uid, token);
    } catch (e) {
      throw Exception('Delete User Error: $e');
    }
  }
}