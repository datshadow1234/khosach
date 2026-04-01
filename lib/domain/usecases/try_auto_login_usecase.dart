import '../entities/auth_token_entity.dart';
import '../repositories/auth_repository.dart';

class TryAutoLoginUseCase {
  final AuthRepository repository;

  TryAutoLoginUseCase(this.repository);

  Future<AuthTokenEntity?> call() {
    return repository.tryAutoLogin();
  }
}
