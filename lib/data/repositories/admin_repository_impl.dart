import 'repositories_widget.dart';

class AdminRepositoryImpl implements AdminRepository {
  final AdminDbClient adminDbClient;

  AdminRepositoryImpl({required this.adminDbClient});

  @override
  Future<UserEntity> getAdminProfile(String uid, String token) async {
    try {
      final response = await adminDbClient.getAdminWithQuery(token, '"uid"', '"$uid"');
      if (response.isEmpty) throw Exception("Không tìm thấy dữ liệu Admin");

      final userData = Map<String, dynamic>.from(response.values.first);
      final model = UserModel.fromJson(userData);

      return UserEntity(
        uid: model.uid,
        imageUrl: '',
        email: model.email,
        name: model.name,
        phone: model.phone,
        address: model.address,
        role: model.role,
      );
    } catch (e) {
      throw Exception('AdminRepo Error: $e');
    }
  }

  @override
  Future<void> updateAdminProfile(UserEntity admin, String token) async {
    try {
      final updateData = {
        'name': admin.name,
        'phone': admin.phone,
        'address': admin.address,
      };

      final response = await adminDbClient.getAdminWithQuery(token, '"uid"', '"${admin.uid}"');

      if (response.isNotEmpty) {
        String firebaseUrl = response.keys.first;
        await adminDbClient.updateAdminInfo(firebaseUrl, token, updateData);
      }
    } catch (e) {
      throw Exception('Admin Update Error: $e');
    }
  }

  @override
  Future<List<UserEntity>> getAllUsers(String token) async {
    try {
      final response = await adminDbClient.getAllUsers(token);
      final List<UserEntity> users = [];

      response.forEach((key, value) {
        final model = UserModel.fromJson(Map<String, dynamic>.from(value));
        users.add(UserEntity(
          uid: model.uid,
          imageUrl: '',
          email: model.email,
          name: model.name,
          phone: model.phone,
          address: model.address,
          role: model.role,
        ));
      });
      return users;
    } catch (e) {
      throw Exception('Get All Users Error: $e');
    }
  }

  @override
  Future<void> deleteUser(String uid, String token) async {
    try {
      final response = await adminDbClient.getAdminWithQuery(token, '"uid"', '"$uid"');
      if (response.isNotEmpty) {
        String firebaseUrl = response.keys.first;
        await adminDbClient.deleteUser(firebaseUrl, token);
      }
    } catch (e) {
      throw Exception('Delete User Error: $e');
    }
  }
}