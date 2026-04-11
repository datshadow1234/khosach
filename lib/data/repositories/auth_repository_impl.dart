import 'repositories.dart';
class AuthRepositoryImpl implements AuthRepository {
  final AuthLocalDataSource localDataSource;
  AuthRepositoryImpl({required this.localDataSource});

  @override
  Future<AuthTokenEntity?> tryAutoLogin() async {
    final authToken = await localDataSource.getAuthToken();
    if (authToken != null && authToken.isValid) return authToken;
    return null;
  }
}