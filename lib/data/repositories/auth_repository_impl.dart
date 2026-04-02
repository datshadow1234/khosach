import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../domain/entities/auth_token_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../clients/auth_client.dart';
import '../datasources/auth_local_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthClient authClient;
  final AuthLocalDataSource localDataSource;
  final String _apiKey = dotenv.env['FIREBASE_API_KEY'] ?? '';

  AuthRepositoryImpl({
    required this.authClient,
    required this.localDataSource,
  });

  @override
  Future<AuthTokenEntity> login(String email, String password) async {
    final response = await authClient.signIn(_apiKey, {
      'email': email,
      'password': password,
      'returnSecureToken': true,
    });

    return AuthTokenEntity(
      token: response.token,
      userId: response.userId,
      expiryDate: DateTime.now().add(Duration(seconds: int.parse(response.expiresIn))),
    );
  }

  @override
  Future<AuthTokenEntity> signup(String email, String password) async {
    final response = await authClient.signUp(_apiKey, {
      'email': email,
      'password': password,
      'returnSecureToken': true,
    });

    return AuthTokenEntity(
      token: response.token,
      userId: response.userId,
      expiryDate: DateTime.now().add(Duration(seconds: int.parse(response.expiresIn))),
    );
  }

  @override
  Future<void> saveLocalToken(AuthTokenEntity entity) async {
    await localDataSource.saveAuthToken(entity);
  }

  @override
  Future<AuthTokenEntity?> tryAutoLogin() async {
    final authToken = await localDataSource.getAuthToken();
    if (authToken != null && authToken.isValid) {
      return authToken;
    }
    return null;
  }

  @override
  Future<void> logout() async {
    await localDataSource.clearAuthToken();
  }
}