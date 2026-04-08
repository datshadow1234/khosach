import 'usecase_widget.dart';

class LogoutUseCase {
  final LogoutRepository repository;

  LogoutUseCase({required this.repository});

  Future<void> call() async {
    return await repository.clearSession();
  }
}