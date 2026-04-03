import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../domain/entities/auth_token_entity.dart';
import '../../domain/repositories/signup_repository.dart';
import '../clients/auth_client.dart';
import '../clients/user_db_client.dart';
import '../datasources/auth_local_data_source.dart';

class SignupRepositoryImpl implements SignupRepository {
  final AuthClient authClient;
  final UserDbClient userDbClient;
  final AuthLocalDataSource localDataSource;
  final String _apiKey = dotenv.env['FIREBASE_API_KEY'] ?? '';

  SignupRepositoryImpl({required this.authClient, required this.userDbClient, required this.localDataSource});

  @override
  Future<AuthTokenEntity> signUp(String email, String password) async {
    final res = await authClient.signUp(_apiKey, {'email': email, 'password': password, 'returnSecureToken': true});
    return AuthTokenEntity(token: res.token, userId: res.userId, expiryDate: DateTime.now().add(Duration(seconds: int.parse(res.expiresIn))));
  }

  @override
  Future<void> createUserInfo(String uid, String token, Map<String, dynamic> data) async {
    await userDbClient.createUser(uid, token, data);
  }

  @override
  Future<void> saveLocalToken(AuthTokenEntity entity) async => await localDataSource.saveAuthToken(entity);
}