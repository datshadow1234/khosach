import 'repositories.dart';

class LoginRepositoryImpl implements LoginRepository {
  final AuthClient authClient;
  final UserDbClient userDbClient;
  final AuthLocalDataSource localDataSource;
  final String _apiKey = dotenv.env['FIREBASE_API_KEY'] ?? '';

  LoginRepositoryImpl({required this.authClient, required this.userDbClient, required this.localDataSource});

  @override
  Future<AuthTokenEntity> signIn(String email, String password) async {
    try {
      final res = await authClient.signIn(_apiKey, {
        'email': email.trim(),
        'password': password.trim(),
        'returnSecureToken': true,
      });

      return AuthTokenEntity(
        token: res.token,
        userId: res.userId,
        expiryDate: DateTime.now().add(
          Duration(seconds: int.parse(res.expiresIn)),
        ),
      );
    } on DioException catch (e) {
      print('SIGN IN ERROR: ${e.response?.data}');
      throw Exception(e.response?.data.toString());
    }
  }
  @override
  Future<String> getUserRole(String uid, String token) async {
    try {
      final data = await userDbClient.getUserWithQuery(token, '"uid"', '"$uid"');

      if (data.isNotEmpty) {
        final userValues = data.values.first;
        return userValues['role']?.toString().toLowerCase() ?? 'user';
      }
    } catch (e) {
      print("Lỗi LoginRepository getUserRole: $e");
    }
    return 'user';
  }

  @override
  Future<void> saveLocalToken(AuthTokenEntity entity) async => await localDataSource.saveAuthToken(entity);
}