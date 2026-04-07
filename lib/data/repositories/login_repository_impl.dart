import 'repositories_widget.dart';

class LoginRepositoryImpl implements LoginRepository {
  final AuthClient authClient;
  final UserDbClient userDbClient;
  final AuthLocalDataSource localDataSource;
  final String _apiKey = dotenv.env['FIREBASE_API_KEY'] ?? '';

  LoginRepositoryImpl({required this.authClient, required this.userDbClient, required this.localDataSource});

  @override
  Future<AuthTokenEntity> signIn(String email, String password) async {
    final res = await authClient.signIn(_apiKey, {'email': email, 'password': password, 'returnSecureToken': true});
    return AuthTokenEntity(token: res.token, userId: res.userId, expiryDate: DateTime.now().add(Duration(seconds: int.parse(res.expiresIn))));
  }

  @override
  Future<String> getUserRole(String uid, String token) async {
    try {
      final data = await userDbClient.getUserInfo(uid, token);
      if (data != null && data['role'] != null) return data['role'];
    } catch (_) {}
    return 'user';
  }

  @override
  Future<void> saveLocalToken(AuthTokenEntity entity) async => await localDataSource.saveAuthToken(entity);
}