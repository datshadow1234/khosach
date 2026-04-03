// lib/domain/usecases/try_auto_login_usecase.dart
import '../entities/auth_token_entity.dart';
import '../repositories/auth_repository.dart';

class TryAutoLoginUseCase {
  final AuthRepository repository;

  TryAutoLoginUseCase({required this.repository});

  Future<AuthTokenEntity?> call() async {
    return await repository.tryAutoLogin();
  }
}