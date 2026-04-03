import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../domain/entities/auth_token_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../clients/auth_client.dart';
import '../datasources/auth_local_data_source.dart';
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