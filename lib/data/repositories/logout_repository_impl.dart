import '../../domain/repositories/logout_repository.dart';
import '../datasources/auth_local_data_source.dart';

class LogoutRepositoryImpl implements LogoutRepository {
  final AuthLocalDataSource localDataSource;
  LogoutRepositoryImpl({required this.localDataSource});

  @override
  Future<void> clearSession() async {
    await localDataSource.clearAuthToken();
  }
}