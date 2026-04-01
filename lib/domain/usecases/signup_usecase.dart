import '../entities/auth_token_entity.dart';
import '../repositories/auth_repository.dart';

class SignupUseCase {
  final AuthRepository repository;

  SignupUseCase(this.repository);

  Future<AuthTokenEntity> call(
    String email,
    String password,
    String phone,
    String name,
    String address,
  ) {
    return repository.signup(email, password, phone, name, address);
  }
}
