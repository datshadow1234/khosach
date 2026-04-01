import '../../domain/entities/auth_token_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_data_source.dart';
import '../datasources/auth_remote_data_source.dart';
import '../models/auth_token_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<AuthTokenEntity> login(String email, String password) async {
    final authTokenModel = await remoteDataSource.authenticate(email, password, 'signInWithPassword');
    final role = await remoteDataSource.isAdmin(authTokenModel.token, authTokenModel.userId);
    final updatedAuthToken = authTokenModel.copyWith(role: role);
    await localDataSource.saveAuthToken(updatedAuthToken);
    return updatedAuthToken;
  }

  @override
  Future<AuthTokenEntity> signup(String email, String password, String phone, String name, String address) async {
    final authTokenModel = await remoteDataSource.authenticate(email, password, 'signUp', phone, name, address);
    final role = await remoteDataSource.isAdmin(authTokenModel.token, authTokenModel.userId);
    final updatedAuthToken = authTokenModel.copyWith(role: role);
    await localDataSource.saveAuthToken(updatedAuthToken);
    return updatedAuthToken;
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
