import 'repositories.dart';

class SignupRepositoryImpl implements SignupRepository {
  final AuthClient authClient;
  final UserDbClient userDbClient;
  final AuthLocalDataSource localDataSource;
  final String _apiKey = dotenv.env['FIREBASE_API_KEY'] ?? '';

  SignupRepositoryImpl({
    required this.authClient,
    required this.userDbClient,
    required this.localDataSource
  });

  @override
  Future<AuthTokenEntity> signUp(String email, String password) async {
    try {
      final res = await authClient.signUp(_apiKey, {
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
      print('SIGN UP ERROR: ${e.response?.data}');
      throw Exception(e.response?.data.toString());
    }
  }

  @override
  Future<void> createUserInfo(String uid, String token, Map<String, dynamic> data) async {
    final newUserMap = {
      'uid': uid,
      'email': data['email'] ?? '',
      'name': data['name'] ?? '',
      'phone': data['phone'] ?? '',
      'address': data['address'] ?? '',
      'role': 'user',
    };

    await userDbClient.createUser(uid, token, newUserMap);
  }

  @override
  Future<void> saveLocalToken(AuthTokenEntity entity) async =>
      await localDataSource.saveAuthToken(entity);
}