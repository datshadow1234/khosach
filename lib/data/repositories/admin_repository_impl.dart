import '../models/admin_model/admin_model.dart';
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
        final model = AdminModel.fromJson(Map<String, dynamic>.from(value as Map));
        users.add(model.toEntity());
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