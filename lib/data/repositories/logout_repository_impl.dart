import 'repositories_widget.dart';

class LogoutRepositoryImpl implements LogoutRepository {
  final AuthLocalDataSource localDataSource;
  LogoutRepositoryImpl({required this.localDataSource});

  @override
  Future<void> clearSession() async {
    await localDataSource.clearAuthToken();
  }
}