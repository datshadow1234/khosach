import 'usecase.dart';

class TryAutoLoginUseCase {
  final AuthRepository repository;

  TryAutoLoginUseCase({required this.repository});

  Future<AuthTokenEntity?> call() async {
    return await repository.tryAutoLogin();
  }
}